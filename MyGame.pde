import ddf.minim.*;
Minim minim;
AudioPlayer[] _musicPlayer;

class MyGame extends Game {
  // --- Field(start) ---
  public Clock _clock;
  public Enemy[] _enemy;
  public Block[] _block;
  public Hand _hand;
  public Button _button;
  private String[] se_name = { 
    "game_bgm.mp3", "catch.mp3", "puyon1.mp3", "clock.wav"
  };
  public float[] _blockX;
  public float[] _blockY;
  public float _blockInterval;
  public int _time;
  public int _minute;
  public int _state;
  public int _hp;
  public int _startCount;
  public int _count;
  public int _score;
  public PImage _kawa;
  public PImage _tuki;
  public PImage _wakare;
  public boolean _gameStart;
  public PImage _kumo;
  public PImage _bridge;
  public PImage _orihiko;
  public PImage _orihime;
  public PImage _over;
  public boolean _push;
  public boolean _pushButton;
  static final int BLOCK_MAX = 3;
  static final int ENEMY_MAX = 3;
  static final int SE_MAX = 4;
  // Screen state  
  static final int MOVE_FRONT = 1;
  static final int GAME_TITLE = 0;
  static final int GAME_PLAY = 1;
  static final int GAME_CLEAR = 2;
  static final int GAME_OVER = 3;
  // --- Field(end) ---

  static final int RIVER_X = 20;
  static final int RIVER_Y = 50;
  
  private PGraphics g;

  public MyGame( PApplet appleat ) {
    super( appleat );
    minim = new Minim( appleat );
    _musicPlayer = new AudioPlayer[ SE_MAX ];
    // BGM
    for ( int i = 0; i < SE_MAX; i ++ ) {
      _musicPlayer[ i ] = minim.loadFile( se_name[ i ] );
    }    
    _musicPlayer[ 0 ].loop();
    g = createGraphics(width, height);
  }

  void initialize() {
    _kawa = loadImage( "kawa2.png" );
    _tuki = loadImage( "orihiko2.png" );
    _bridge = loadImage( "bridge.png" );
    _wakare = loadImage( "wakare1.png" );
    _orihime = loadImage( "orihime1.png" );
    _orihiko = loadImage( "orihiko.png" );
    _kumo = loadImage( "kumo1.png" );
    _state = GAME_TITLE;
    _block = new Block[ BLOCK_MAX ];
    _blockX = new float[ _block.length ];
    _blockY = new float[ _block.length ];
    _enemy = new Enemy[ ENEMY_MAX ];
    for ( int i = 0; i < _block.length; i++ ) {
      _block[i] = new Block( this, i );
      _blockX[i] = (float)_block[i].position.x;
      _blockY[i] = (float)_block[i].position.y;
      _enemy[i] = new Enemy( this, _bridge.width );
      _enemy[i].position.set(  150 + i * 50, height + ( int )random( height ) );
    }
    _blockInterval = (float)abs( _blockY[0] - _blockY[1] );
    _button = new Button( this );
    _hand = new Hand( this );
    _clock = new Clock( this );
    // position set
    _button.alive();
    gameInitialize();
    super.initialize();
    g.beginDraw();
    g.background( 0 );
    g.imageMode( CENTER );
    g.image( _kawa, width / 2, height / 2, width + 100, height + 100 );
    g.image( _bridge, width / 2, height / 2, width - 50, height - 5 );
    g.endDraw();
  }

  void gameInitialize() {
    _pushButton = false;
    _push = false;
    _gameStart = false;
    _startCount = 0;
    _minute = 0;
    _time = 0;
    _hp = 0;
    _clock.position.set( width  + 10 + ( int )random( width ), height / 2 );
    for ( int i = 0; i < _block.length; i++ ) {
      _block[i]._catch = false;
      _block[i]._state = _block[i].WAIT_STATE;
      _enemy[i].position.set(  150 + i * 50, height + ( int )random( 30, height ) );
    }
  }

  void update() {
    switch( _state ) {
    case GAME_TITLE:
      _state = title();
      break;
    case GAME_PLAY:
      _state = gameplay();
      break;
    case GAME_CLEAR:
      _state = gameclear();
      break;
    case GAME_OVER:
      _state = gameover();
      break;
    }
  }


  // TITLE
  private int title() {
    int result = _state;
    background( 255 );
    textSize( 40 );
    fill( 0 );
    textAlign( CENTER );
    text( "彦星ブロック", width / 2, height / 2 - 150 );
    image( _orihiko, width - 130, height - 100 );
    if ( mousePressed ) {
      _hand.buttonPushed();
    }
    if ( _pushButton == true ) {
      if ( _push == true ) {
        sePlay( 1 );
        result = GAME_PLAY;
        _push = false;
        _pushButton = false;
      }
    }
    _button.update( delta );
    _hand.update( delta );
    _hand.position.set( mouseX, mouseY );
    gameInitialize();
    return result;
  }

  // GAME 
  public int gameplay() {
    int result = _state;
    background( 255 );
    imageMode( CENTER );
    image(g, width / 2, height / 2);
    
    // over
    if ( _hp == 3 ) {
      result = GAME_OVER;
      gameInitialize();
    }
    _clock.update( delta );
    image( _kumo, width - 70, 30 );
    image( _kumo, width - 150, 40 );
    image( _orihime, width / 2, 50 );
    textSize( 20 );
    fill( 0 );
    textAlign( CENTER );
    fill( 0 );
    text( _minute, width - 70, 50 );
    text( _time, width - 120, 50 );
    text( "7月7日     時     分", width - 120, 50 );
    fill( 160, 82, 45, 200 );
    strokeWeight( 2 );
    rectMode( CENTER );
    for( int i = 0; i < _block.length; i++ ){
     rect( (float)_blockX[i], (float)_blockY[i], _blockInterval, _blockInterval );
    }
    for ( int i = 0; i < _block.length; i++ ) {
      _block[i].update( delta );
      _enemy[i].update( delta );
    }
    _hand.update( delta );
    _hand.position.set( mouseX, mouseY );
    // time 
    if ( !_gameStart ) {
      _startCount++;
      textSize( 70 );
      fill( 0 );
      text( 5 - _count, width / 2, height / 2 );
      if ( _startCount >= 60 ) {
        _count++;
        _startCount = 0;
        if ( _count >= 5 ) {
          _gameStart = true;
          _count = 0;
        }
      }
    } else {
      _minute++;
      if ( _minute >= 60 ) {
        _time += 1;
        _minute = 0;
      }
      if ( _time >= 24 ) {
        _score = _hp;
        result = GAME_CLEAR;
        gameInitialize();
      }
    }
    return result;
  }


  // GAME CLEAR
  private int gameclear() {
    int result = _state;
    background( 179, 255, 240 );
    textSize( 40 );
    image( _wakare, width / 2, 250 );
    fill( 0 );
    text( "CLEAR", width / 2, 550 );
    textSize( 30 );
    text( "織姫のもとについた彦星の数 " + _score + "人", width / 2, 455 );
    if ( mousePressed ) {
      _hand.buttonPushed();
    }
    if ( _pushButton == true ) {
      if ( _push == true ) {
        sePlay( 1 );
        result = GAME_TITLE;
        _push = false;
        _pushButton = false;
      }
    }
    _button.update( delta );
    _hand.update( delta );
    _hand.position.set( mouseX, mouseY );
    return result;
  }


  // GAME OVER
  private int gameover() {
    int result = _state;
    background( 105, 105, 105 );
    textSize( 40 );
    text( "GAMEOVER", width / 2, 500 );
    if ( mousePressed ) {
      _hand.buttonPushed();
    }
    if ( _pushButton == true ) {
      if ( _push == true ) {
        sePlay( 1 );
        result = GAME_TITLE;
        _pushButton = false;
        _push = false;
      }
    }
    image( _tuki, width / 2, 250 );
    _button.update( delta );
    _hand.update( delta );
    _hand.position.set( mouseX, mouseY );
    return result;
  }


  // BGM STOP
  void stop() {
    _musicPlayer[ 0 ].close();
    minim.stop();
  }
  // SE Play
  public void sePlay( int _state ) {
    switch( _state ) {
    case 0:
      // wait
      break;
    case 1:
      _musicPlayer[ _state ].play();
      _musicPlayer[ _state ].rewind();
      _state =  0;
      break;
    case 2:
      _musicPlayer[ _state ].play();
      _musicPlayer[ _state ].rewind();
      _state = 0;
      break;
    case 3:
      _musicPlayer[ _state ].play();
      _musicPlayer[ _state ].rewind();
      _state = 0;
      break;
    }
  }
}

