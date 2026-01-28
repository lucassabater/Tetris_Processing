//Constants
int smallGridlength = 4;
int cellSize = 30;
int cols = 10;
int rows = 20;
int margin = 30;

//Assets
PImage imgGameOver;
PFont retroFont;

// Game State Variables
int[][] grid = new int[cols][rows];
int score = 0;
int level = 1;
int lines = 0;
int gameSeed = 0;
int nextPieceType = 1;
int holdPieceType = 1;
boolean gameOver = false;
ActivePiece activePiece;


void setup() {
  size(660, 650);
  strokeWeight(1);
  
  imgGameOver = loadImage("Assets/end.jpg");
  imgGameOver.resize(width, height);
  retroFont = createFont("Assets/PressStart2P-Regular.ttf", 60);
  textFont(retroFont);
  
  initializeMQTT();
}

void draw() {
  if (gameOver) {
    drawGameOverScreen();
    
  } else {
    background(cBackground);
    drawBoard(((smallGridlength*cellSize) + 2 * margin), margin);
    drawHold(margin, margin);
    drawInfo((smallGridlength*cellSize) + (cols * cellSize) + (margin * 3), margin);
    //activePiece.display();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    //mqttReset();
    if (gameOver) {
      gameOver = false;
    } else {
      gameOver = true;
    }
  }
}
