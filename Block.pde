class Block extends Item {
  public static final int WAIT_STATE = 0;
  public static final int CATCH_STATE = 1;
  public static final int MOVE_STATE = 2;
  public MyGame _parent;
  private int _state;
  public int _hitCount;
  private int _num;
  public int _count;
  private Boolean _move;
  private boolean _catch;
  private final int INTERVAL = 70;

  public Block( Game parent, int num ) {
    super( parent, "rock1.png", 1, 1 );
    _num = num;
    this._parent = ( MyGame )parent;
    _state = WAIT_STATE;
    _hitCount = 3;
    _move = false;
    _count = 0;
    _catch = false;
    this.position.set( width - 50, height - ( INTERVAL * ( _num + 1 ) ) );
  }

  public void update( double deltaTime ) {
    switch( _state ) {
    case WAIT_STATE:
      this.position.set( width - 50, height - ( INTERVAL * ( _num + 1 ) ) );
      _move = false;
      _count = 0;
      _hitCount = 3;
      if( _catch == true ){
        _state = CATCH_STATE;
        _catch = false;
      }
      break;
    case CATCH_STATE:
      this.position.set( mouseX, mouseY );
      break;
    case MOVE_STATE:
      if ( _parent._gameStart ) {
        _move = true;
        _count++;
        if ( _hitCount >= 0 && _count <= 240 ) {
          for ( int i = 0; i < _parent._enemy.length; i++ ) {
            if ( this.hitTest( this._parent._enemy[i], 30 ) && this._move && !_parent._enemy[i]._move ) {
              _parent.sePlay( 2 );
              this._parent._enemy[i].positionResetEnemy();
              _hitCount -= 1;
            }
          }
        } else {
          _state = WAIT_STATE;
          _catch = false;
        }
      }
      break;
    }
    super.update( deltaTime );
  }
  
  public void onCatch(){
    _catch = true;
  }
}

