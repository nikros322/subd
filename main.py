from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
import os

from database import SessionLocal, Story
import schemas

app = FastAPI(
    title="Сказка Красная Шапочка API",
    description="",
    version="1.3.0"
)

# СОЗДАНИЕ ПАПОК ДЛЯ СТАТИКИ (чтобы не было ошибок 404)
for path in ["static/audio", "static/images"]:
    if not os.path.exists(path):
        os.makedirs(path)

# НАСТРОЙКА CORS
origins = ["*"] # Для разработки разрешаем всем, чтобы фронт не мучался

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 3. ИНЪЕКЦИЯ ЗАВИСИМОСТИ (DB Session)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# МОНТИРОВАНИЕ СТАТИКИ (Задача MP3)
# Позволяет обращаться к файлам: http://127.0.0.1:8000/static/audio/redhood.m4a
app.mount("/static", StaticFiles(directory="static"), name="static")

# ЭНДПОИНТ ПОЛУЧЕНИЯ СКАЗКИ
@app.get("/red-hood", response_model=schemas.StoryRead)
def get_story(db: Session = Depends(get_db)):
    # Запрос в базу данных
    story_db = db.query(Story).filter(Story.id == 1).first()

    if not story_db:
        raise HTTPException(status_code=404, detail="Сказка не найдена в базе")

    # ВАЖНО: Больше не нужно вручную писать story_db.route = story_db.points.
    # Pydantic теперь сам подхватит points и переименует в route благодаря alias в схемах.
    return story_db