MyGame _game;
PFont font;
private boolean _once;

void setup() {
  size( displayHeight / 2, displayHeight );
  _game = new MyGame( this );
  font = createFont( "Meryou", 40 );
  textFont( font );
  noCursor();
  _once = false;
}

void draw() {
  _game.run();
}

void mouseReleased() {
  if ( _game._hand._isCatch ) {
    _game._hand.released();
  }
  if( _once == true ){
    _game._push = false;
    _once = false;
  }
}

void mousePressed(){
  if(_once == false){
    _game._push = true;
    _once = true;
  }
}

