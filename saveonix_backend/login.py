from fastapi import FastAPI
from pydantic import BaseModel
from supabase import create_client, Client
from fastapi.middleware.cors import CORSMiddleware

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
SUPABASE_KEY = "YOUR_SUPABASE_KEY"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

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
    token: str


class ResetPasswordRequest(BaseModel):
    email: str
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

        return {
            "message": "Signup successful",
            "user": {
                "id": response.user.id,
                "email": response.user.email
            }
        }

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
            "user": {
                "id": response.user.id,
                "email": response.user.email
            },
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

        supabase.auth.sign_in_with_otp({
            "email": data.email
        })

        return {"message": "OTP sent to email"}

    except Exception as e:
        return {"error": str(e)}


# -----------------------------
# VERIFY OTP
# -----------------------------
@app.post("/verify-otp")
def verify_otp(data: VerifyOtpRequest):

    try:

        response = supabase.auth.verify_otp({
            "email": data.email,
            "token": data.token,
            "type": "email"
        })

        if response.user is None:
            return {"error": "Invalid OTP"}

        return {
            "message": "OTP verified",
            "user": {
                "id": response.user.id,
                "email": response.user.email
            }
        }

    except Exception as e:
        return {"error": str(e)}


# -----------------------------
# RESET PASSWORD
# -----------------------------
@app.post("/reset-password")
def reset_password(data: ResetPasswordRequest):

    try:

        supabase.auth.admin.update_user_by_id(
            data.email,
            {"password": data.new_password}
        )

        return {"message": "Password updated successfully"}

    except Exception as e:
        return {"error": str(e)}