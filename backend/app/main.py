# app/main.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.utils.const import get_settings
from app.utils.schemas import Somar

app = FastAPI()
settings = get_settings()

print(f"ALLOWED ORIGIN -> https://{settings.FRONTEND}.{settings.DOMAIN}")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[f"https://{settings.FRONTEND}.{settings.DOMAIN}"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/soma")
def somar(request: Somar):
    if request.auth != settings.AUTH:
        raise HTTPException(status_code=403, detail="Código de autorização inválido.")
    try:
        resultado = request.n1 + request.n2
        return {
            "status": "sucesso",
            "resultado": resultado,
            "mensagem": f"A soma de {request.n1} + {request.n2} = {resultado}",
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
