import javax.sound.midi.*;

interface DeviceListener {
  void rawMidi(byte[] data) ;
  void controllerChange(ControlChange change);
  void noteOn(Note note);
  void noteOff(Note note);
}

class DeviceManager implements Receiver {  
  ArrayList<String> outputNames;
  MidiDevice.Info[] devices;
  MidiDevice controllerDevice;
  Transmitter controllerTransmitter;
  ArrayList<Receiver> outputs;
  MidiDevice clockDevice;
  String clockSourceName = "INTERNAL";
  int clockSourceIndex = -1;
  boolean isShifting = false;

  DeviceManager(ArrayList<String> outputs) {
    outputNames = outputs;
  }
  
  // SETUP

  public void setupIODevices() {
    devices = MidiSystem.getMidiDeviceInfo();
    addControllerInputs();
    addAllOutputs();
  }
  
  // Adds MIDI Mix controller if found
  public void addControllerInputs() {
    for (int i = 0; i < devices.length; i++) {
      MidiDevice.Info info = devices[i];
      try {
        MidiDevice device = MidiSystem.getMidiDevice(devices[i]);
        if (info.getName().contains("Mix")) {
          controllerDevice = device;
          if (!device.isOpen()) { 
            device.open();
          }
          controllerTransmitter = controllerDevice.getTransmitter();
          controllerTransmitter.setReceiver(this); 
          println("Midi device " + info.getName() + " controller found!");
          break;
        }
      } catch (MidiUnavailableException e) {
        println("Midi device " + info.getName() + " unavailable as controller");
      }
    }
  }
  
  public void addAllOutputs() {
    outputs = new ArrayList<Receiver>();
    for (int i = 0; i < devices.length; i++) {
      MidiDevice.Info info = devices[i];
      println("Found Midi device " + info.getName());
      //if (!outputNames.contains(info.getName())) {
      if (!info.getName().contains("Interface")) {
        continue;
      }
      try {
        MidiDevice device = MidiSystem.getMidiDevice(devices[i]);
        if (!device.isOpen()) { 
          device.open();
        }
        Receiver receiver = device.getReceiver();
        outputs.add(receiver);
        println("Midi device " + info.getName() + " added as output.");
      } catch (MidiUnavailableException e) {
        println("Midi device " + info.getName() + " unavailable as output");
        println(e);
      }
    }
  }

  public String setNextClock() {
    clockSourceIndex++;
    if (clockSourceIndex < devices.length) {
      try {
        MidiDevice device = MidiSystem.getMidiDevice(devices[clockSourceIndex]);
        if (!device.isOpen()) { 
          device.open();
        }
        Transmitter clockTransmitter = device.getTransmitter();
        clockTransmitter.setReceiver(this); 
        clockDevice = device;
        clockSourceName = devices[clockSourceIndex].getName();
        println("Midi device " + devices[clockSourceIndex].getName() + " added as clock.");
      } catch (MidiUnavailableException e) {
        println("Midi device " + devices[clockSourceIndex].getName() + " unavailable as clock");
      }
      clockManager.useMidiClock();
    } else if (clockSourceIndex == devices.length) {
      clockSourceIndex = -1;
      clockSourceName = "INTERNAL";
      clockManager.useInternalClock();
    }
    return clockSourceName;
  }

  // SEND

  public void sendNoteOn(int channel, int note, int velocity) {
    ShortMessage message = new ShortMessage();
    try {
      message.setMessage(ShortMessage.NOTE_ON, channel, note, velocity);
    } catch (InvalidMidiDataException e) {
      println("InvalidMidiDataException");
    }
    long timeStamp = -1;
    for (Receiver receiver : outputs) {
      try {
        receiver.send(message, timeStamp);
      } catch (IllegalStateException e) {
        println("IllegalStateException");
      }
    }
  }

  public void sendNoteOff(int channel, int note, int velocity) {
    ShortMessage message = new ShortMessage();
    try {
      message.setMessage(ShortMessage.NOTE_OFF, channel, note, velocity);
    } catch (InvalidMidiDataException e) {
      println("InvalidMidiDataException");
    }
    long timeStamp = -1;
    for (Receiver receiver : outputs) {
      try {
        receiver.send(message, timeStamp);
      } catch (IllegalStateException e) {
        println("IllegalStateException");
      }
    }
  }

  public void sendPulse() {
    try {
      ShortMessage message = new ShortMessage(ShortMessage.TIMING_CLOCK);
      long timeStamp = -1;
      for (Receiver receiver : outputs) {
        receiver.send(message, timeStamp);
      }
    } catch (InvalidMidiDataException e) {
      println("InvalidMidiDataException");
    } catch (IllegalStateException e) {
      println("IllegalStateException");
    }
    
  }

  // RECEIVE

  public void send(MidiMessage message, long timeStamp) {
    byte[] data = message.getMessage();
    if((int)((byte)data[0] & 0xF0) == ShortMessage.NOTE_ON) {
      Note note = new Note((int)(data[0] & 0x0F),(int)(data[1] & 0xFF),(int)(data[2] & 0xFF));
      noteOn(note);
    } else if((int)((byte)data[0] & 0xF0) == ShortMessage.NOTE_OFF) {
      Note note = new Note((int)(data[0] & 0x0F),(int)(data[1] & 0xFF),(int)(data[2] & 0xFF));
      noteOff(note);
    } else if((int)((byte)data[0] & 0xF0) == ShortMessage.CONTROL_CHANGE) {
      ControlChange cc = new ControlChange((int)(data[0] & 0x0F),(int)(data[1] & 0xFF),(int)(data[2] & 0xFF));
      controllerChange(cc);
    } else {
      rawMidi(data);
    }
  }

  public void close() {
    println("Midi device closed");
  }

  // MIDI CALLBACKS

  void rawMidi(byte[] data) {  
    if (clockManager.internalClock.isRunning) {
      return;
    }
    if(data[0] == (byte)0xFC) {
      sequencer.stop();
    } else if(data[0] == (byte)0xF8) { // CLOCK PULSE
      clockManager.midiClock.pulse();
    }
  }

  void controllerChange(ControlChange change) {
    switch (change.number()) {
        case 16: sequencer.updateTrackAccents("1", change.value()); break;
        case 17: sequencer.updateTrackOffset("1", change.value()); break;
        case 18: sequencer.updateTrackBeats("1", change.value()); break;
        case 19: sequencer.updateTrackLength("1", change.value()); break;
        case 20: sequencer.updateTrackAccents("2", change.value()); break;
        case 21: sequencer.updateTrackOffset("2", change.value()); break;
        case 22: sequencer.updateTrackBeats("2", change.value()); break;
        case 23: sequencer.updateTrackLength("2", change.value()); break;
        case 24: sequencer.updateTrackAccents("3", change.value()); break;
        case 25: sequencer.updateTrackOffset("3", change.value()); break;
        case 26: sequencer.updateTrackBeats("3", change.value()); break;
        case 27: sequencer.updateTrackLength("3", change.value()); break;
        case 28: sequencer.updateTrackAccents("4", change.value()); break;
        case 29: sequencer.updateTrackOffset("4", change.value()); break;
        case 30: sequencer.updateTrackBeats("4", change.value()); break;
        case 31: sequencer.updateTrackLength("4", change.value()); break;
        case 46: sequencer.updateTrackAccents("5", change.value()); break;
        case 47: sequencer.updateTrackOffset("5", change.value()); break;
        case 48: sequencer.updateTrackBeats("5", change.value()); break;
        case 49: sequencer.updateTrackLength("5", change.value()); break;
        case 50: sequencer.updateTrackAccents("6", change.value()); break;
        case 51: sequencer.updateTrackOffset("6", change.value()); break;
        case 52: sequencer.updateTrackBeats("6", change.value()); break;
        case 53: sequencer.updateTrackLength("6", change.value()); break;
        case 54: sequencer.updateTrackAccents("7", change.value()); break;
        case 55: sequencer.updateTrackOffset("7", change.value()); break;
        case 56: sequencer.updateTrackBeats("7", change.value()); break;
        case 57: sequencer.updateTrackLength("7", change.value()); break;
        case 58: sequencer.updateTrackAccents("8", change.value()); break;
        case 59: sequencer.updateTrackOffset("8", change.value()); break;
        case 60: sequencer.updateTrackBeats("8", change.value()); break;
        case 61: sequencer.updateTrackLength("8", change.value()); break;
        default: break;
      }
      if (isShifting) {
        switch (change.number()) {
          case 62: sequencer.updateLFOPeriod(change.value()); break; 
          default: break;
        }
      } else {
        switch (change.number()) {
          case 62: 
            if (sequencer.isEditingTrackId == "") {
              clockManager.setSpeed(change.value());
            } else {
              sequencer.updateLFOAmount(change.value()); 
            }
            break; 
          default: break;
        }
      } 
    //else if (deviceManager.controllerName.contains("LPD8")) {
    //  switch (change.number()) {
    //    case 1: sequencer.updateTrackBeats("1", change.value()); break;
    //    case 2: sequencer.updateTrackBeats("2", change.value()); break;
    //    case 3: sequencer.updateTrackBeats("3", change.value()); break;
    //    case 4: sequencer.updateTrackBeats("4", change.value()); break;
    //    case 5: sequencer.updateTrackLength("1", change.value()); break;
    //    case 6: sequencer.updateTrackLength("2", change.value()); break;
    //    case 7: sequencer.updateTrackLength("3", change.value()); break;
    //    case 8: sequencer.updateTrackLength("4", change.value()); break;
    //    default: break;
    //  }
    //}
    ui.updateTrackLabels();
  }

  void noteOn(Note note) {
    if (isShifting) {
      switch (note.pitch()) {
        case 3: sequencer.rollTrack("1"); break;
        case 6: sequencer.rollTrack("2"); break;
        case 9: sequencer.rollTrack("3"); break;
        case 12: sequencer.rollTrack("4"); break;
        case 15: sequencer.rollTrack("5"); break;
        case 18: sequencer.rollTrack("6"); break;
        case 21: sequencer.rollTrack("7"); break;
        case 24: sequencer.rollTrack("8"); break;
        default: break;
      }  
    } else {
      switch (note.pitch()) {
        case 1: sequencer.muteTrack("1"); break;
        case 4: sequencer.muteTrack("2"); break;
        case 7: sequencer.muteTrack("3"); break;
        case 10: sequencer.muteTrack("4"); break;
        case 13: sequencer.muteTrack("5"); break;
        case 16: sequencer.muteTrack("6"); break;
        case 19: sequencer.muteTrack("7"); break;
        case 22: sequencer.muteTrack("8"); break;
        case 3: sequencer.editTrackLFO("1"); break;
        case 6: sequencer.editTrackLFO("2"); break;
        case 9: sequencer.editTrackLFO("3"); break;
        case 12: sequencer.editTrackLFO("4"); break;
        case 15: sequencer.editTrackLFO("5"); break;
        case 18: sequencer.editTrackLFO("6"); break;
        case 21: sequencer.editTrackLFO("7"); break;
        case 24: sequencer.editTrackLFO("8"); break;
        case 27: isShifting = true; break;
        default: break;
      }
    }   
    // SOLO
    switch (note.pitch()) {
      case 2: sequencer.addSoloTrack("1"); break;
      case 5: sequencer.addSoloTrack("2"); break;
      case 8: sequencer.addSoloTrack("3"); break;
      case 11: sequencer.addSoloTrack("4"); break;
      case 14: sequencer.addSoloTrack("5"); break;
      case 17: sequencer.addSoloTrack("6"); break;
      case 20: sequencer.addSoloTrack("7"); break;
      case 23: sequencer.addSoloTrack("8"); break;
      default: break;
    }
    //else if (deviceManager.controllerName.contains("LPD8")) {
    //  switch (note.pitch()) {
    //    case 36: sequencer.decrementTrackOffset("1"); break;
    //    case 37: sequencer.decrementTrackOffset("2"); break;
    //    case 38: sequencer.decrementTrackOffset("3"); break;
    //    case 39: sequencer.decrementTrackOffset("4"); break;
    //    case 40: sequencer.incrementTrackOffset("1"); break;
    //    case 41: sequencer.incrementTrackOffset("2"); break;
    //    case 42: sequencer.incrementTrackOffset("3"); break;
    //    case 43: sequencer.incrementTrackOffset("4"); break;
    //    default: break;
    //  } 
    //}
    ui.updateTrackLabels();
  }

  void noteOff(Note note) {
    if (isShifting) {
      switch (note.pitch()) {
        case 3: sequencer.rollTrack("1"); break;
        case 6: sequencer.rollTrack("2"); break;
        case 9: sequencer.rollTrack("3"); break;
        case 12: sequencer.rollTrack("4"); break;
        case 15: sequencer.rollTrack("5"); break;
        case 18: sequencer.rollTrack("6"); break;
        case 21: sequencer.rollTrack("7"); break;
        case 24: sequencer.rollTrack("8"); break;
        case 27: 
          isShifting = false;
          sequencer.clearSoloTracks();
          sequencer.updatePatternChain();
          break;
        default: break;
      }
    } else {
      switch (note.pitch()) {
        case 27: 
          isShifting = false; 
          break;
        default: break;
      }
    }
    // SOLO
    switch (note.pitch()) {
      case 2: sequencer.removeSoloTrack("1"); break;
      case 5: sequencer.removeSoloTrack("2"); break;
      case 8: sequencer.removeSoloTrack("3"); break;
      case 11: sequencer.removeSoloTrack("4"); break;
      case 14: sequencer.removeSoloTrack("5"); break;
      case 17: sequencer.removeSoloTrack("6"); break;
      case 20: sequencer.removeSoloTrack("7"); break;
      case 23: sequencer.removeSoloTrack("8"); break;
      default: break;
    } 
    // A/B
    if (isShifting) {
      switch (note.pitch()) {
        case 25: sequencer.chainA(); break;
        case 26: sequencer.chainB(); break;
        default: break;
      } 
    } else {
      switch (note.pitch()) {
        case 25: sequencer.showA(); break;
        case 26: sequencer.showB(); break;
        default: break;
      } 
    }
    ui.updateTrackLabels();
  }
}
