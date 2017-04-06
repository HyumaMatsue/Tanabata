class Hand extends BaseCharacter {
  public MyGame _parent;
  public int x_max, y_max;
  public int x_blk, y_blk;
  public int x_btn, y_btn;
  public int ene_disX, ene_disY;
  public boolean _isCatch;

  public Hand( Game parent ) {
    super( parent, "hand.png", 1, 1 );
    _parent = ( MyGame )parent;
    _isCatch = false;
  }

  public void update( double deltaTime ) {
    if ( mousePressed ) {
      if (!_isCatch ) {
        // Block catch & Enemy catch
        for ( int i = 0; i < _parent._block.length; i++ ) {
          _parent._block[i].getX();
          _parent._block[i].getY();
          x_blk =  abs( ( int )_parent._block[i].getX() - ( int )mouseX );
          y_blk = abs( ( int )_parent._block[i].getY() - ( int )mouseY );
          ene_disX = abs( ( int )_parent._enemy[i].getX() - ( int )mouseX );
          ene_disY = abs( ( int )_parent._enemy[i].getY() - ( int )mouseY );
          // hit Block
          if ( x_blk <= 30 && y_blk <= 30 ) {
            _parent._block[i].onCatch();
            _isCatch = true;
            return;
          }
          if ( ene_disX <= 30 && ene_disY <= 30 ) {
            _parent._enemy[i]._state = _parent._enemy[i].CATCH_STATE;
            _isCatch = true;
            return;
          }
        }
        x_max =  abs( ( int )_parent._clock.getX() - ( int )mouseX );
        y_max = abs( ( int )_parent._clock.getY() - ( int )mouseY );
        
        //Clock catch
        if ( x_max <= 30 && y_max <= 30 && _parent._clock.isDead() == false) {
          _parent._clock.dead();
          _parent.sePlay( 3 );
          for ( int i = 0; i < _parent._enemy.length; i++ ) {
            _parent._enemy[i]._getClock = true;
          }
        }
      }
    }
    super.update( deltaTime );
  }

  void released() {
    for ( int i = 0; i < _parent._block.length; i++ ) {
      if( _parent._block[i]._state == _parent._block[i].CATCH_STATE ){
        _parent._block[i]._state = _parent._block[i].MOVE_STATE;
      }
      _parent._enemy[i]._state = _parent._enemy[i].MOVE_STATE;
    }
    _isCatch = false;
  }
  
  
  // button
  public void buttonPushed() {
    x_btn = abs( ( int )_parent._button.getX() - ( int )mouseX );
    y_btn = abs( ( int )_parent._button.getY() - ( int )mouseY ); 
    if ( x_btn <= 80 && y_btn <= 30 && _parent._pushButton == false ) {
      _parent._pushButton = true;
    }
  }
}

