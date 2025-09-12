from pydantic import BaseModel


class Somar(BaseModel):
    auth: str
    n1: float
    n2: float
