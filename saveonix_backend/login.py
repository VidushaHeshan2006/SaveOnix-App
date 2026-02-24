from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from supabase import create_client, Client
from fastapi.middleware.cors import CORSMiddleware

# -----------------------------
# FASTAPI APP
# -----------------------------
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to your frontend URL in production
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
    full_name: str | None = None  # optional


class LoginRequest(BaseModel):
    email: str
    password: str


# ROOT TEST

@app.get("/")
def home():
    return {"message": "Backend is running"}
# SIGNUP

@app.post("/signup")
def signup(data: SignupRequest):
    try:
        response = supabase.auth.sign_up({
            "email": data.email,
            "password": data.password
        })

        if response.user is None:
            return {"error": "Signup failed, email may already exist"}

        # Insert into your users table
        supabase.table("users").insert({
            "id": response.user.id,
            "email": response.user.email,
            "full_name": data.full_name
        }).execute()

        return {
            "message": "Signup successful",
            "user": {
                "id": response.user.id,
                "email": response.user.email,
                "full_name": data.full_name
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

        if response.user is None or response.session is None:
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