class ActivePiece {
  PVector[] currentPositions = new PVector[4];
  int type = 0;

  ActivePiece() {
    for (int i = 0; i < 4; i++) {
      currentPositions[i] = new PVector(0, 0);
    }
  }

  void updatePositions(PVector[] newCoords) {
    for (int i=0; i<4; i++) {
      this.currentPositions[i] = newCoords[i];
    }
  }

  void setType(int newType) {
    this.type = newType;
  }

  void display() {
    if (type == 0) return;

    fill(getColor(type));
    stroke(0);

    for (PVector pos : currentPositions) {
      int px = (int)pos.x;
      int py = (int)pos.y;
      if (px >= 0 && px < cols) {
        rect(px * cellSize, py * cellSize, cellSize, cellSize);
      }
    }
  }
}
