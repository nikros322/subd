from pydantic import BaseModel, Field
from typing import List, Optional


class RoutePointRead(BaseModel):
    t: int
    x: int
    y: int
    event: Optional[str] = None

    class Config:
        from_attributes = True


class StoryRead(BaseModel):
    id: int
    title: str
    author: str  # Новое поле
    description: Optional[str] = None
    audio_url: str
    cover_url: Optional[str] = None  # Новое поле
    map_url: Optional[str] = None  # Новое поле

    # Мапим points из БД в название route для фронтенда
    route: List[RoutePointRead] = Field(..., alias="points")

    class Config:
        from_attributes = True
        populate_by_name = True  # Чтобы alias работал при чтении из БД