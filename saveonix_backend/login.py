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
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5d2d2c25tdnd2anRlZHNkcmFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg2NTQyODUsImV4cCI6MjA4NDIzMDI4NX0.UcnRh6Aw_mUCr4gcWb0TrtDl7A_vfyCfxwK5yeQ9mZA"


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


class ForgotPasswordRequest(BaseModel):
    email: str


class VerifyOtpRequest(BaseModel):
    email: str
    token: str


class ResetPasswordRequest(BaseModel):
    new_password: str


# -----------------------------
# TEST ROUTE
# -----------------------------
@app.get("/")
def home():
    return {"message": "Backend is running"}

# -----------------------------
# SIGNUP
# -----------------------------
@app.post("/signup")
def signup(data: SignupRequest):

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


# -----------------------------
# LOGIN
# -----------------------------
@app.post("/login")
def login(data: LoginRequest):

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


# -----------------------------
# FORGOT PASSWORD
# -----------------------------
@app.post("/forgot-password")
def forgot_password(data: ForgotPasswordRequest):

    supabase.auth.reset_password_for_email(data.email)

    return {"message": "OTP sent to email"}


# -----------------------------
# VERIFY OTP
# -----------------------------
@app.post("/verify-otp")
def verify_otp(data: VerifyOtpRequest):

    response = supabase.auth.verify_otp({
        "email": data.email,
        "token": data.token,
        "type": "recovery"
    })

    return {"message": "OTP verified"}


# -----------------------------
# RESET PASSWORD
# -----------------------------
@app.post("/reset-password")
def reset_password(data: ResetPasswordRequest):

    supabase.auth.update_user({
        "password": data.new_password
    })

    return {"message": "Password updated successfully"}