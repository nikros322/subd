from sqlalchemy import create_engine, Column, Integer, String, Text, ForeignKey
from sqlalchemy.orm import sessionmaker, declarative_base, relationship

DATABASE_URL = "postgresql://postgres:@localhost:5432/red_hood_db"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class Story(Base):
    __tablename__ = "stories"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False) # Исправлено nullфable
    author = Column(String(255), default="Шарль Перро") # Добавлено для фронта
    description = Column(Text)
    audio_url = Column(String(500))
    cover_url = Column(String(500)) # Ссылка на обложку
    map_url = Column(String(500))   # Ссылка на файл карты

    # Связь с точками
    points = relationship("RoutePoint", back_populates="story", cascade="all, delete-orphan")

class RoutePoint(Base):
    __tablename__ = "route_points"

    id = Column(Integer, primary_key=True, index=True)
    story_id = Column(Integer, ForeignKey("stories.id", ondelete="CASCADE"))
    t = Column(Integer, nullable=False)
    x = Column(Integer, nullable=False)
    y = Column(Integer, nullable=False)
    event = Column(String(255))

    story = relationship("Story", back_populates="points")