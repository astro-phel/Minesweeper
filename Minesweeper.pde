import de.bezier.guido.*;

int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS];
private ArrayList<MSButton> mines = new ArrayList<MSButton>();
boolean alive = true;

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);
  Interactive.make(this);

  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}

public void setMines() {
  int numMines = 40;
  while (mines.size() < numMines) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw() {
  background(0);

  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].draw();
    }
  }

  if (alive && isWon()) {
    displayWinningMessage();
  }
}

public boolean isWon() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      MSButton btn = buttons[r][c];
      if (!btn.isClicked() && !mines.contains(btn)) {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage() {
  alive = false;

  for (MSButton b : mines) {
    b.click(true);
  }

  String msg = "you lose D:";
  for (int i = 0; i < msg.length(); i++) {
    if (i < NUM_COLS)
      buttons[0][i].setLabel("" + msg.charAt(i));
  }
}

public void displayWinningMessage() {
  alive = false;

  String msg = "woah you're so goated";
  for (int i = 0; i < msg.length(); i++) {
    if (i < NUM_COLS)
      buttons[0][i].setLabel("" + msg.charAt(i));
  }
}

public boolean isValid(int r, int c) {
  return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}

public int countMines(int row, int col) {
  int count = 0;
  for (int r = row - 1; r <= row + 1; r++) {
    for (int c = col - 1; c <= col + 1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c])) {
        count++;
      }
    }
  }
  return count;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton(int row, int col) {
    width = 400 / NUM_COLS;
    height = 400 / NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol * width;
    y = myRow * height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add(this);
  }

  public void mousePressed() {
    if (!alive || clicked) return;

    if (mouseButton == RIGHT) {
      if (!clicked) {
        flagged = !flagged;
      }
      return;
    }

    if (flagged) return;

    clicked = true;

    if (mines.contains(this)) {
      displayLosingMessage();
      return;
    }

    int mineCount = countMines(myRow, myCol);
    if (mineCount > 0) {
      setLabel(mineCount);
    } else {
      for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
          if (isValid(r, c) && !(r == myRow && c == myCol)) {
            MSButton neighbor = buttons[r][c];
            if (!neighbor.isClicked()) {
              neighbor.mousePressed();
            }
          }
        }
      }
    }
  }

  public void draw() {
    if (flagged)
      fill(150); // Flagged gray
    else if (clicked && mines.contains(this))
      fill(#420c09); // Red for mine
    else if (clicked)
      fill(132, 165, 184); // Revealed
    else
      fill(66, 104, 124); // Hidden

    rect(x, y, width, height);
    fill(179, 218, 241);
    text(myLabel, x + width / 2, y + height / 2);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = "" + newLabel;
  }

  public boolean isFlagged() {
    return flagged;
  }

  public boolean isClicked() {
    return clicked;
  }

  public void click(boolean b) {
    clicked = b;
  }
}
