from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI()

class Note(BaseModel):
    id: int
    content: str

notes = []

@app.post("/notes", response_model=Note)
def create_note(note: Note):
    if any(n.id == note.id for n in notes):
        raise HTTPException(status_code=400, detail="Note ID already exists")
    notes.append(note)
    return note

@app.get("/notes", response_model=List[Note])
def list_notes():
    return notes

@app.get("/notes/{note_id}", response_model=Note)
def get_note(note_id: int):
    for note in notes:
        if note.id == note_id:
            return note
    raise HTTPException(status_code=404, detail="Note not found")

@app.put("/notes/{note_id}", response_model=Note)
def update_note(note_id: int, updated: Note):
    for idx, note in enumerate(notes):
        if note.id == note_id:
            notes[idx] = updated
            return updated
    raise HTTPException(status_code=404, detail="Note not found")

@app.delete("/notes/{note_id}")
def delete_note(note_id: int):
    for idx, note in enumerate(notes):
        if note.id == note_id:
            notes.pop(idx)
            return {"msg": "Note deleted"}
    raise HTTPException(status_code=404, detail="Note not found")
