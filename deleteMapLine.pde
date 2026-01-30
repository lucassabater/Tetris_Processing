// Checks all lines to see if the are full
void checkLine() {
  for (int y = rows - 1; y >= 0; y--) {

    if (!isLineFull(y)) {
      continue;
    }
    
    //Eliminates empty lines from grid
    for (int z = y; z > 0; z--) {
      for (int x = 0; x < cols; x++) {
        grid[x][z] = grid[x][z - 1];
      }
    }

    for (int x = 0; x < cols; x++) {
      grid[x][0] = 0;
    }
    y++;
  }
}

//Checks if current line is full
boolean isLineFull(int y) {
  for (int x = 0; x < cols; x++) {
    if (grid[x][y] == 0) {
      return false;
    }
  }
  return true;
}
