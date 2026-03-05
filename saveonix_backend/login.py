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
SUPABASE_SERVICE_ROLE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5d2d2c25tdnd2anRlZHNkcmFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg2NTQyODUsImV4cCI6MjA4NDIzMDI4NX0.UcnRh6Aw_mUCr4gcWb0TrtDl7A_vfyCfxwK5yeQ9mZA"  # service role key required
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

# -----------------------------
# EMAIL CONFIG (GMAIL SMTP)
# -----------------------------
SMTP_USER = "vidushaheshan316@gmail.com"  # OTP sender email
SMTP_PASS = "gchhoazcwkciwnip"           # Gmail App Password
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587

def send_email(to_email, otp):
    subject = "Your OTP Code"
    html_content = f"""
    <html>
    <body>
        <h2>OTP Verification</h2>
        <p>Your OTP code is:</p>
        <h1 style="color:blue;">{otp}</h1>
        <p>This OTP is valid for 5 minutes.</p>
    </body>
    </html>
    """
    msg = MIMEMultipart()
    msg['From'] = SMTP_USER
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(html_content, 'html'))

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
        response = supabase.auth.sign_up({
            "email": data.email,
            "password": data.password
        })
        if response.user is None:
            return {"error": "Signup failed"}

        supabase.table("users").insert({
            "id": response.user.id,
            "email": response.user.email,
            "full_name": data.full_name
        }).execute()

        return {"message": "Signup successful", "user": {"id": response.user.id, "email": response.user.email}}
    except Exception as e:
        return {"error": str(e)}

# -----------------------------
# LOGIN
# -----------------------------
@app.post("/login")
def login(data: LoginRequest):
    try:
        response = supabase.auth.sign_in_with_password({
            "email": data.email,
            "password": data.password
        })
        if response.user is None:
            return {"error": "Invalid email or password"}

        return {
            "message": "Login successful",
            "user": {"id": response.user.id, "email": response.user.email},
            "access_token": response.session.access_token
        }
    except Exception as e:
        return {"error": str(e)}

# -----------------------------
# SEND OTP
# -----------------------------
@app.post("/send-otp")
def send_otp(data: SendOtpRequest):
    try:
        # Prevent user from entering SMTP sender email
        if data.email == SMTP_USER:
            return {"error": "You cannot reset the SMTP sender email"}

        # Check if user exists in Supabase Auth
        users = supabase.auth.admin.list_users().execute()
        user = next((u for u in users.data if u["email"] == data.email), None)
        if not user:
            return {"error": "User not found"}

        # Generate OTP and expiry
        otp = f"{random.randint(100000, 999999)}"
        expires_at = datetime.utcnow() + timedelta(minutes=5)

        # Save OTP to table
        supabase.table("otp_codes").insert({
            "email": data.email,
            "otp": otp,
            "expires_at": expires_at.isoformat()
        }).execute()

        # Send OTP email
        send_email(data.email, otp)
        return {"message": "OTP sent to email"}
    except Exception as e:
        return {"error": str(e)}

# -----------------------------
# VERIFY OTP
# -----------------------------
@app.post("/verify-otp")
def verify_otp(data: VerifyOtpRequest):
    try:
        record = supabase.table("otp_codes") \
            .select("*").eq("email", data.email).order("expires_at", desc=True).limit(1).execute()
        otp_record = record.data[0] if record.data else None

        if not otp_record:
            return {"error": "OTP not found"}
        if otp_record["otp"] != data.otp:
            return {"error": "Invalid OTP"}
        if datetime.utcnow() > datetime.fromisoformat(otp_record["expires_at"]):
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
        # Verify OTP
        record = supabase.table("otp_codes") \
            .select("*").eq("email", data.email).order("expires_at", desc=True).limit(1).execute()
        otp_record = record.data[0] if record.data else None

        if not otp_record or otp_record["otp"] != data.otp:
            return {"error": "Invalid OTP"}
        if datetime.utcnow() > datetime.fromisoformat(otp_record["expires_at"]):
            return {"error": "OTP expired"}

        # Get user from Supabase
        user_list = supabase.auth.admin.list_users().execute()
        user = next((u for u in user_list.data if u["email"] == data.email), None)
        if not user:
            return {"error": "User not found"}

        # Update user password (service_role key)
        supabase.auth.admin.update_user_by_id(user["id"], {"password": data.new_password})

        # Delete OTP
        supabase.table("otp_codes").delete().eq("email", data.email).execute()

        return {"message": "Password updated successfully"}
    except Exception as e:
        return {"error": str(e)}