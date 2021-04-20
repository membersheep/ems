class ClockManager {
  Sequencer sequencer;
  MIDIClock midiClock;
  InternalClock internalClock;
  
  ClockManager(Sequencer inSequencer) {
    sequencer = inSequencer;
    midiClock = new MIDIClock(sequencer);
    internalClock = new InternalClock(sequencer);
    internalClock.start();
  }
  
  void useInternalClock() {
    internalClock.isRunning = true;
  }
  
  void useMidiClock() {
    internalClock.isRunning = false;
  }
  
  void setSpeed(int value) {
    if (internalClock.isRunning) {
      internalClock.setBPM(60+value);
    } else {
      midiClock.division = value/32;
    }
  }
}

class InternalClock extends Thread {
  public ClockListener listener;
  public int bpm = 120;
  public int pulse = 0;
  public int division = 4; // 1 - 2 - 3 - 4
  int ppqn = 24; // pulses per quarter note MIDI standard value is 24
  
  Boolean isActive = true;
  Boolean isRunning = true;
  long previousTime; // in ns
  double pulseInterval; // in ns

  InternalClock(ClockListener inListener) {
    listener = inListener;
    pulseInterval = 1000.0 / (bpm / 60.0 * ppqn) * 1000000; 
    previousTime = System.nanoTime();
  }
  
  public void setBPM(int newBpm) {
    bpm = newBpm;
    pulseInterval = 1000.0 / (bpm / 60.0 * ppqn) * 1000000; 
  }

  void run() {
    try {
      while(isActive) {
        if (!isRunning) { continue; }
        long timePassed = System.nanoTime() - previousTime;
        if (timePassed < (long)pulseInterval) {
          continue;
        } 
        listener.pulse();
        //byte[] pulseMessage= {(byte)0xF8};
        //midiBus.sendMessage(pulseMessage);
        pulse++;
        int pulsesPerTick = ppqn / division; // 24 - 12 - 8 - 6
        if (pulse % pulsesPerTick == 0) {
          listener.tick();
        }
        if (pulse % pulsesPerTick == pulsesPerTick/2) {
          listener.tock();
        }
        // calculate real time until next pulse
        long delay = ((long)pulseInterval*5/3 - (System.nanoTime() - previousTime));
        previousTime = System.nanoTime();
        if (delay > 0) {
          Thread.sleep(delay/1000000);
        }
      }
    }  catch(InterruptedException e) {
      println("force quit...");
    }
  }
} 

class MIDIClock {
  public ClockListener listener;
  public int pulse;
  public int division;
  
  public MIDIClock(ClockListener inListener) {
    listener = inListener; 
    pulse = 0;
    division = 4;
  }
  
  public void pulse() {
    listener.pulse();
    pulse++;
    int pulsesPerTick = 24 / division; // 24 - 12 - 8 - 6
    if (pulse % pulsesPerTick == 0) {
      listener.tick();
    }
    if (pulse % pulsesPerTick == pulsesPerTick/2) {
      listener.tock();
    }
  }
}

interface ClockListener {
    void tick();
    void tock();
    void pulse();
}
