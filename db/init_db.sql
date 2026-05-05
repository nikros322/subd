CREATE TABLE stories (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    audio_url VARCHAR(500)
);

CREATE TABLE route_points (
    id SERIAL PRIMARY KEY,
    story_id INTEGER REFERENCES stories(id) ON DELETE CASCADE,
    t INTEGER NOT NULL,
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    event VARCHAR(255)
);