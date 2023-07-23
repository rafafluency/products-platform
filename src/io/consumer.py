from fastapi import FastAPI

from src.common import logger

logger = logger.get_logger()
app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Olá, FastAPI!"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
