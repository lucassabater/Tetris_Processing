class ActivePiece {
  public PVector[] currentPositions = new PVector[4];
  public int type = 0;

  ActivePiece(int type) {
    this.type = type;
    for (int i = 0; i < 4; i++) {
      currentPositions[i] = new PVector(0, 0);
    }
  }

  void updatePositions(PVector[] newCoords) {
    for (int i=0; i<4; i++) {
      this.currentPositions[i] = newCoords[i];
    }
  }

  void display(int startX, int startY) {
    if (type == 0) return;

    fill(getColor(type));
    stroke(0);

    for (PVector pos : currentPositions) {
      int px = (int) pos.x;
      int py = (int) pos.y;

      if (px >= 0 && px < cols && py >= 0 && py < rows) {
        rect(startX + px * cellSize, startY + py * cellSize, cellSize, cellSize);
      }
    }
  }
}
