from fastapi import FastAPI
from pydantic import BaseModel
from supabase import create_client, Client
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
import random
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# -----------------------------
# FASTAPI APP
# -----------------------------
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -----------------------------
# SUPABASE CONFIG
# -----------------------------
SUPABASE_URL = "https://kywgvsnmvwvjtedsdral.supabase.co"
SUPABASE_SERVICE_ROLE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5d2d2c25tdnd2anRlZHNkcmFsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2ODY1NDI4NSwiZXhwIjoyMDg0MjMwMjg1fQ.ixVnxb2oqHw4DhvAMzDi20ifo37Ovd50htKSc3BsSPU"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

# -----------------------------
# EMAIL CONFIG
# -----------------------------
SMTP_USER = "saveonix@gmail.com"
SMTP_PASS = "ilcznfdwflggwkfg"
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587


def send_email(to_email, otp):
    subject = "Your OTP Code"

    html_content = f"""
    <h2>Password Reset OTP</h2>
    <p>Your OTP code is:</p>
    <h1>{otp}</h1>
    <p>This OTP expires in 5 minutes.</p>
    """

    msg = MIMEMultipart()
    msg["From"] = SMTP_USER
    msg["To"] = to_email
    msg["Subject"] = subject
    msg.attach(MIMEText(html_content, "html"))

    server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    server.starttls()
    server.login(SMTP_USER, SMTP_PASS)
    server.sendmail(SMTP_USER, to_email, msg.as_string())
    server.quit()


# -----------------------------
# REQUEST MODELS
# -----------------------------
class SignupRequest(BaseModel):
    email: str
    password: str
    full_name: str | None = None


class LoginRequest(BaseModel):
    email: str
    password: str


class SendOtpRequest(BaseModel):
    email: str


class VerifyOtpRequest(BaseModel):
    email: str
    otp: str


class ResetPasswordRequest(BaseModel):
    email: str
    otp: str
    new_password: str


# -----------------------------
# ROOT
# -----------------------------
@app.get("/")
def home():
    return {"message": "Backend running"}


# -----------------------------
# SIGNUP
# -----------------------------
@app.post("/signup")
def signup(data: SignupRequest):
    try:
        response = supabase.auth.sign_up(
            {
                "email": data.email,
                "password": data.password,
            }
        )

        if response.user is None:
            return {"error": "Signup failed"}

        supabase.table("users").insert(
            {
                "id": response.user.id,
                "email": response.user.email,
                "full_name": data.full_name,
            }
        ).execute()

        return {"message": "Signup successful"}

    except Exception as e:
        return {"error": str(e)}


# -----------------------------
# LOGIN
# -----------------------------
@app.post("/login")
def login(data: LoginRequest):
    try:
        response = supabase.auth.sign_in_with_password(
            {
                "email": data.email,
                "password": data.password,
            }
        )

        if response.user is None:
            return {"error": "Invalid credentials"}

        return {
            "message": "Login successful",
            "user": {
                "id": response.user.id,
                "email": response.user.email,
            },
            "access_token": response.session.access_token,
        }

    except Exception as e:
        return {"error": str(e)}


# -----------------------------
# SEND OTP
# -----------------------------
@app.post("/send-otp")
def send_otp(data: SendOtpRequest):
    try:

        if data.email == SMTP_USER:
            return {"error": "Not allowed"}

        # Get users
        users = supabase.auth.admin.list_users()

        user = next((u for u in users if u.email == data.email), None)

        if not user:
            return {"error": "User not found"}

        otp = str(random.randint(100000, 999999))

        expires_at = datetime.utcnow() + timedelta(minutes=5)

        # Remove previous OTP
        supabase.table("otp_codes").delete().eq("email", data.email).execute()

        # Insert new OTP
        supabase.table("otp_codes").insert(
            {
                "email": data.email,
                "otp": otp,
                "expires_at": expires_at.isoformat(),
            }
        ).execute()

        send_email(data.email, otp)

        return {"message": "OTP sent"}

    except Exception as e:
        return {"error": str(e)}


# -----------------------------
# VERIFY OTP
# -----------------------------
@app.post("/verify-otp")
def verify_otp(data: VerifyOtpRequest):
    try:

        result = (
            supabase.table("otp_codes")
            .select("*")
            .eq("email", data.email)
            .execute()
        )

        if not result.data:
            return {"error": "OTP not found"}

        record = result.data[0]

        if record["otp"].strip() != data.otp.strip():
            return {"error": "Invalid OTP"}

        expires = datetime.fromisoformat(record["expires_at"])

        if datetime.utcnow() > expires:
            return {"error": "OTP expired"}

        return {"message": "OTP verified"}

    except Exception as e:
        return {"error": str(e)}


# -----------------------------
# RESET PASSWORD
# -----------------------------
@app.post("/reset-password")
def reset_password(data: ResetPasswordRequest):
    try:

        result = (
            supabase.table("otp_codes")
            .select("*")
            .eq("email", data.email)
            .execute()
        )

        if not result.data:
            return {"error": "OTP not found"}

        record = result.data[0]

        if record["otp"].strip() != data.otp.strip():
            return {"error": "Invalid OTP"}

        expires = datetime.fromisoformat(record["expires_at"])

        if datetime.utcnow() > expires:
            return {"error": "OTP expired"}

        users = supabase.auth.admin.list_users()

        user = next((u for u in users if u.email == data.email), None)

        if not user:
            return {"error": "User not found"}

        supabase.auth.admin.update_user_by_id(
            user.id,
            {"password": data.new_password},
        )

        supabase.table("otp_codes").delete().eq("email", data.email).execute()

        return {"message": "Password updated"}

    except Exception as e:
        return {"error": str(e)}