class Enemy extends BaseCharacter {

  static final int MOVE_STATE = 0;
  static final int CATCH_STATE = 1;
  static final int MOVE_ANIM = 0;
  static final int SPEED = 4;
  static final int SLOW = 1;
  public MyGame _parent;
  private int _state;
  public int _speed;
  public int _posY;
  public int _count;
  public Boolean _move;
  public boolean _getClock;
  private float _bridgeWidth;


  public Enemy( Game parent, float bridgeWidth ) {
    super( parent, "hikobosi1.png", 3, 1 );
    changeAnimation( MOVE_ANIM );
    _parent = ( MyGame )parent;
    _speed = SPEED;
    _state = MOVE_STATE;
    _posY = 1000;
    _getClock = false;
    _move = false;
    _count = 0;
    _bridgeWidth = bridgeWidth;
  }

  void update( double deltaTime ) {
    switch( _state ) {
    case MOVE_STATE:
      _move = false;
      if ( _parent._gameStart ) {
        if ( _getClock ) {
          _speed = SLOW;
          _count++;
          if ( _count > 180 ) {
            _count = 0;
            _getClock = false;
          }
        } else {
          _speed = SPEED;
        }
        this.position.y -= _speed;
        if ( this.position.y <= 50 ) {
          _parent._hp += 1;
          positionResetEnemy();
        }
      }
      break;
    case CATCH_STATE:
      _move = true;
      this.position.set( mouseX, mouseY );
      break;
    }
    super.update( deltaTime );
  }

  public void positionResetEnemy() {
    double posX = 0;
    posX =  ( double )random( 140, width - 140 );
    this.position.set(posX, _posY);
  }
}

