class Clock extends Item {
  public int _speed;
  public int _frameCount;
  static final int MOVE_RIGHT = 2;
  private MyGame theParent;
  
  public Clock( Game _parent ) {
    super( _parent, "clock4.png", 1, 1 );
    changeAnimation( MOVE_RIGHT );
    _speed = 2;
    _frameCount = 0;
    theParent = ( MyGame )_parent;
  }

  public void update( double deltaTime ) {
    if ( theParent._gameStart ) {
      this.position.x -= _speed;
      _frameCount += 1;
      if ( _frameCount >= 360 ) {
        if ( this.position.x <= 0 ) {
          this.alive();
          this.position.set( random( width ) + width, random( height - 50 ) );
          _frameCount = 0;
        }
      }
    }
    super.update( deltaTime );
  }
}

