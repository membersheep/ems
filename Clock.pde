class Clock {
  public ClockListener listener;
  public int tick;
  public int bpm;
  public int division;
  public long startTime;
  
  public Clock(ClockListener inListener) {
    listener = inListener; 
    tick = 0;
    bpm = 120;
    division = 4;
    startTime = millis();
  }
  
  public void update() {
    long currentTime = millis();
    long elapsedTime = currentTime - startTime;
    int newTick = (int)elapsedTime * bpm * division / 60000;
    if (tick != newTick) {
      listener.tick();
    }
    tick = newTick;
  }
}

class MIDIClock {
  public ClockListener listener;
  public int tick;
  public int division;
  
  public MIDIClock(ClockListener inListener) {
    listener = inListener; 
    tick = 0;
    division = 4;
  }
  
  public void pulse() {
    listener.pulse();
    tick++;
    int pulsesPerTick = 24 / division; // 24 - 12 - 8 - 6
    if (tick % pulsesPerTick == 0) {
      listener.tick();
    }
  }
}

interface ClockListener {
    void tick();
    void pulse();
}
