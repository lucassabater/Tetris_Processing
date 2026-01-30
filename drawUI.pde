// Colors
color cBackground = color(40, 44, 52);
color cBoard = color(20, 20, 25);
color cLine = color(60);
color cText = color(255);

// Main Panel 10x20
void drawBoard(int startX, int startY) {
  fill(cBoard);
  stroke(cLine);
  rect(startX, startY, cols * cellSize, rows * cellSize);

  // Draw cells
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      int valor = grid[x][y];
      if (valor > 0) {
        fill(getColor(valor));
        stroke(0);
        rect(startX + (x * cellSize), startY + (y * cellSize), cellSize, cellSize);
      } else {
        // Smaller line size for empty space
        noFill();
        stroke(cLine);
        rect(startX + (x * cellSize), startY + (y * cellSize), cellSize, cellSize);
      }
    }
  }
}

// Left Panel: holding piece
void drawHold(int x, int y) {
  fill(cText);
  textSize(20);
  textAlign(LEFT);
  text("HOLD", x, y + 20);

  noFill();
  stroke(cLine);
  rect(x, y + cellSize, smallGridlength * cellSize, smallGridlength * cellSize);

  drawPreviewPiece(holdPieceType, x, y + cellSize);
}

// Right Panel: Next and Score
void drawInfo(int x, int y) {
  fill(cText);
  textSize(20);
  textAlign(LEFT);
  text("NEXT", x, y + 20);

  // Next Piece Border
  noFill();
  stroke(cLine);
  rect(x, y + cellSize, smallGridlength * cellSize, smallGridlength * cellSize);

  drawPreviewPiece(nextPieceType, x, y + cellSize);

  // Score Section
  int yStats = y + 200;

  fill(cText);
  textSize(20);
  text("SCORE", x, yStats + 10);
  fill(255, 255, 0);
  text(str(score), x, yStats + 40);

  fill(cText);
  text("SEED", x, yStats + 80);
  fill(0, 255, 255);
  text(str(gameSeed), x, yStats + 110);
}


// Función mejorada para dibujar Next/Hold con escalado automático
void drawPreviewPiece(int type, int boxX, int boxY) {
  if (type == 0) return;

  float boxWidth = 4 * cellSize;
  float boxHeight = 4 * cellSize;

  float scaleFactor = 0.85;
  float miniCellSize = cellSize * scaleFactor;

  PVector[] shape = getPreviewShape(type);

  float pieceBlockWidth = 4 * miniCellSize;
  float pieceBlockHeight = 4 * miniCellSize;

  float marginX = (boxWidth - pieceBlockWidth) / 2;
  float marginY = (boxHeight - pieceBlockHeight) / 2;

  fill(getColor(type));
  stroke(0);

  for (PVector p : shape) {
    float drawX = boxX + marginX + (p.x * miniCellSize);
    float drawY = boxY + marginY + (p.y * miniCellSize);

    rect(drawX, drawY, miniCellSize, miniCellSize);
  }
}

// Game Over Screen
void infoScreen() {
  background(0);
  imageMode(CORNER);
  image(imgGameOver, 0, 0);
  textAlign(CENTER, CENTER);

  if (gameOver == true) {
    // Veil for better text reading
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);

    fill(255, 0, 0);
    textSize(60);
    text("GAME OVER", width/2, height/2 - 40);
  }

  // Fliker effect using frameCount
  if (frameCount % 60 < 30) {
    fill(255);
  } else {
    fill(150);
  }

  textSize(30);
  if (gameOver) {
    text("Press 'R' to Restart", width/2, height/2 + 40);
  } else {
    text("Press BUTTON to start", width/2, height/2 + 40);
  }

  if (gameOver == true) {
    fill(255, 255, 0);
    textSize(20);
    text("Final Score: " + score, width/2, height/2 + 90);
  }
}
