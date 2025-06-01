import de.bezier.guido.*;

//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean alive = true;

void setup (){
  size(400, 400);
  textAlign(CENTER,CENTER);
  
  // make the manager
  Interactive.make(this);
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int r = 0; r < NUM_ROWS; r++)
    for(int c = 0; c < NUM_COLS; c++)
      buttons[r][c] = new MSButton(r, c);
  setMines();
}
public void setMines(){
  int numMines = 40;
  while (mines.size() < numMines){
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!(mines.contains(buttons[r][c]))) 
      mines.add(buttons[r][c]);
  }
}
public void draw (){
  background(0);
  if(isWon())
  displayWinningMessage();
}
public boolean isWon(){
  for (int r = 0; r < NUM_ROWS; r++ )
  for (int c = 0; c < NUM_COLS; c++ )
  if (!buttons[r][c].isClicked() && !mines.contains(buttons[r][c]))
  return false;
   return true;
}
public void displayLosingMessage(){
  for(int r = 0; r < NUM_ROWS; r++)
  for(int c = 0; c < NUM_COLS; c++)
   if(mines.contains(buttons[r][c]))
    buttons[r][c].revealMine();
  String message = "you lose D:";
  int startCol = (NUM_COLS - message.length()) / 2;
  int row = NUM_ROWS / 2;
  for (int i = 0; i < message.length(); i++)
    buttons[row][startCol + i].setLabel(Character.toString(message.charAt(i)));
      alive = false;
}
public void displayWinningMessage(){
  String message = "woah you're so goated";
  int startCol = (NUM_COLS - message.length()) / 2;
  int row = NUM_ROWS / 2;
  for (int i = 0; i < message.length(); i++)
    buttons[row][startCol + i].setLabel(Character.toString(message.charAt(i)));
      alive = false;
}
public boolean isValid(int r, int c){
  return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col){
  int numMines = 0;
  for(int r = row - 1; r <= row + 1; r++)
  for(int c = col - 1; c <= col + 1; c++)
   if(isValid(r, c) && mines.contains(buttons[r][c]))
    numMines++;
    return numMines;
}
public class MSButton{
  private int myRow, myCol;
  private float x,y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  
public MSButton (int row, int col){
  width = 400 / NUM_COLS;
  height = 400 / NUM_ROWS;
  myRow = row;
  myCol = col;
  x = myCol * width;
  y = myRow * height;
  myLabel = "";
  flagged = clicked = false;
  Interactive.add(this); //register it with the manager
}
//called by manager
public void mousePressed (){
  if (!alive) return;
  if (mouseButton == RIGHT && !clicked){
    flagged = !flagged;
    return;
  }
  if (flagged || clicked) return;
  clicked = true;
  if (mines.contains(this)){
  displayLosingMessage();
  }
  else{
  int mineCount = countMines(myRow, myCol);
  if (mineCount > 0) {
  setLabel(mineCount);
   }
   else {
    for (int r = myRow - 1; r <= myRow + 1; r++) 
    for (int c = myCol - 1; c <= myCol + 1; c++) 
    if (isValid(r, c) && !(r == myRow && c == myCol)) 
    buttons[r][c].mousePressed();
  }
}
}
public void revealMine() {
  clicked = true;
}
public boolean isClicked() {
  return clicked;
}
public void draw (){
  if (flagged)
  fill(0);
  else if(clicked && mines.contains(this))
  fill(255, 0, 0);
  else if(clicked)
  fill(200);
  else 
  fill(100);
  rect(x, y, width, height);
  fill(0);
  text(myLabel, x + width/2, y + height/2);
}
public void setLabel(String newLabel){
  myLabel = newLabel;
}
public void setLabel(int newLabel){
  myLabel = "" + newLabel;
}
public boolean isFlagged(){
  return flagged;
}
}
