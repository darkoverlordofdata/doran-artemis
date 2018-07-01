using Artemis;
using Artemis.Annotations;
//  using SDL;
//  using SDL.Video;
//  using SDLImage;
using System;
using Microsoft.Xna.Framework;

int main (string[] args) {
    //  new Demo().run();
    var t = new Test();
    t.test();
    return 1;
}

class MyArgs : EventArgs {
    private string _message = "Frodo";
    
    public string message {
        get { return _message; }
    }
}

class Test : Object {

    Event onEvent = (sender, args) => {
        print("this is also the event %s\n", ((MyArgs)args).message);
    };
    
    void myEvent(Test sender, MyArgs args) {
        print("again with the event %s\n", args.message);
        
    }
    public void test() {
        EventHandler<MyArgs> frodo;
        
        frodo = new EventHandler<MyArgs>();
        frodo.add(onEvent);
        frodo.add((Event)myEvent);
    
        EventHelpers.raise(this, frodo, new MyArgs());
    
    }
        
}


//  public class Demo : Game {

//  }
//  public class Game : Object {

//      Window? window;
//  	Renderer? renderer;
//      Display? display;
//  	DisplayMode displayMode;
//  	Event evt;
//  	float fps = 60f;
//  	float delta = 1.0f/60.0f;
//  	bool running;
//  	string resourceBase;
//  	double currentTime;
//  	double accumulator;
//  	double freq;

//      public Game() {
//          Object( 
//          );
//      }

//  	public Window initialize(int width, int height, string name) {

//          if (SDL.Init(SDL.InitFlag.VIDEO | SDL.InitFlag.TIMER | SDL.InitFlag.EVENTS) < 0)
//  			throw new SdlException.Initialization(SDL.GetError());

//  		if (SDLImage.Init(SDLImage.InitFlags.PNG) < 0)
//  			throw new SdlException.ImageInitialization(SDL.GetError());

//  		if (!SDL.Hint.SetHint(Hint.RENDER_SCALE_QUALITY, "1"))	
//  			throw new SdlException.TextureFilteringNotEnabled(SDL.GetError());

//  		if (SDLTTF.Init() == -1)
//              throw new SdlException.TtfInitialization(SDL.GetError());
            
//          if (SDLMixer.Open(22050, SDL.Audio.AudioFormat.S16LSB, 2, 4096) == -1)
//  			print("SDL_mixer unagle to initialize! SDL Error: %s\n", SDL.GetError());
        
//          display = 0;
//          display.GetMode(0, out displayMode);
            
//  		var window = new Window(name, Window.POS_CENTERED, Window.POS_CENTERED, width, height, WindowFlags.SHOWN);
        
//  		if (window == null)
//  			throw new SdlException.OpenWindow(SDL.GetError());
		
//  		renderer = Renderer.Create(window, -1, RendererFlags.ACCELERATED | RendererFlags.PRESENTVSYNC);
//  		if (renderer == null)
//              throw new SdlException.CreateRenderer(SDL.GetError());
            
//          freq = SDL.Timer.GetPerformanceFrequency();
            
//          return window;
//      }

//      public void run() {

//          window = initialize(700, 500, "fred");
//          var running = true;
//          while (running) {
//             running = doEvents();
//          }
//      }

//      public bool doEvents() {
//          while (Event.poll(out evt) != 0) {
//              switch (evt.type) {
                
//              case EventType.QUIT:
//                  return false;

//              case EventType.KEYDOWN:
//                  if (evt.key.keysym.sym == Input.Keycode.ESCAPE) { return false; }
//                  break;

//              }
//          }
//          return true;
//      }

//  }

