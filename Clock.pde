class Clock {
  public ClockListener listener;
  public int tick;
  public int bpm;
  public long startTime;
  
  public Clock(ClockListener inListener) {
    listener = inListener; 
    tick = 0;
    bpm = 120;
    startTime = millis();
  }
  
  public void update() {
    long currentTime = millis();
    long elapsedTime = currentTime - startTime;
    int newTick = (int)elapsedTime * bpm / 60000;
    if (tick != newTick) {
      listener.tick();
    }
    tick = newTick;
  }
}

interface ClockListener {
    void tick();
}
