class Button extends BaseCharacter {
  public MyGame _parent;
  public Button( Game parent ) {
    super( parent, "button2.png", 1, 1 );
    _parent = ( MyGame )parent;
  }

  public void update( double deltaTime ) {
    if ( !_parent._pushButton ) {
      this.position.set( width / 2, height / 2 + 100 );
    }
    super.update( deltaTime );
  }
}

