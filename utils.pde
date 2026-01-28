//Standar Tetris Color Mapping
color getColor(int type) {
  switch(type) {
  case 1:
    return color(0, 255, 255);   // I - Cyan
  case 2:
    return color(0, 0, 255);     // J - Dark Blue
  case 3:
    return color(255, 165, 0);   // L - Orange
  case 4:
    return color(255, 255, 0);   // O - Yellow
  case 5:
    return color(0, 255, 0);     // S - Green
  case 6:
    return color(128, 0, 128);   // T - Purple
  case 7:
    return color(255, 0, 0);     // Z - Red
  default:
    return color(100);          // Gray (Filler)
  }
}

//Game Start SetUp
void onStartUp(byte[] payload) {
  if (payload.length != 4) {
    println("ERROR: Startup incorrect payload. Length: " + payload.length);
    return;
  }

  resetInterface();
  gameSeed = (payload[0] & 0xFF << 8) | payload[1] & 0xFF;

  activePiece = new ActivePiece(int(payload[2]));  
  nextPieceType = int(payload[3]);

  score = 0;
  gameOver = false;
}

//Reset all game UI
void resetInterface() {
  score = 0;
  level = 1;
  gameOver = false;
  holdPieceType = 0;
  nextPieceType = 0;
  activePiece.show = false;

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      grid[x][y] = 0;
    }
  }
}

//Piece Definition for drawing
PVector[] getBaseShape(int type) {
  PVector[] shape = new PVector[4];

  switch (type) {
  case 1: // LINE (I)
    shape[0] = new PVector(-1, 0);
    shape[1] = new PVector(0, 0);
    shape[2] = new PVector(1, 0);
    shape[3] = new PVector(2, 0);
    break;
  case 2: // SQUARE (O)
    shape[0] = new PVector(0, 0);
    shape[1] = new PVector(1, 0);
    shape[2] = new PVector(0, 1);
    shape[3] = new PVector(1, 1);
    break;
  case 3: // T_SHAPE
    shape[0] = new PVector(-1, 0);
    shape[1] = new PVector(0, 0);
    shape[2] = new PVector(1, 0);
    shape[3] = new PVector(0, 1);
    break;
  case 4: // L_SHAPE
    shape[0] = new PVector(-1, 0);
    shape[1] = new PVector(0, 0);
    shape[2] = new PVector(1, 0);
    shape[3] = new PVector(1, 1);
    break;
  case 5: // Z_SHAPE
    shape[0] = new PVector(-1, 1);
    shape[1] = new PVector(0, 1);
    shape[2] = new PVector(0, 0);
    shape[3] = new PVector(1, 0);
    break;
  case 6: // J_SHAPE
    shape[0] = new PVector(-1, 1);
    shape[1] = new PVector(-1, 0);
    shape[2] = new PVector(0, 0);
    shape[3] = new PVector(1, 0);
    break;
  case 7: // S_SHAPE
    shape[0] = new PVector(-1, 0);
    shape[1] = new PVector(0, 0);
    shape[2] = new PVector(0, 1);
    shape[3] = new PVector(1, 1);
    break;
  default: // Fallback
    for (int i=0; i<4; i++) shape[i] = new PVector(0, 0);
  }
  return shape;
}

PVector[] getPreviewShape(int type) {
  PVector[] shape = getBaseShape(type);

  float offsetX = 0;
  float offsetY = 0;

  switch (type) {
  case 1: // I (Barra) - Ancho 4
    // Original X: -1, 0, 1, 2
    // Queremos que ocupe todo el ancho (0, 1, 2, 3)
    // -1 + 1.0 = 0
    offsetX = 1.0; 
    
    // Centrado vertical: El centro es 1.5
    offsetY = 1.5; 
    break;

  case 2: // O (Cuadrado) - Ancho 2
    // Original X: 0, 1
    // Queremos que esté en el centro (columnas 1 y 2)
    // 0 + 1.0 = 1
    offsetX = 1.0;
    
    // Centrado vertical (filas 1 y 2)
    offsetY = 1.0;
    break;

  default: // T, L, J, Z, S - Ancho 3 (pivote en 0,0)
    // El centro del grid 4x4 es 1.5
    // Simplemente movemos el pivote (0,0) al centro (1.5, 1.5)
    offsetX = 1.5;
    offsetY = 1.5;
    break;
  }

  for (PVector p : shape) {
    p.add(offsetX, offsetY, 0);
  }

  return shape;
}
