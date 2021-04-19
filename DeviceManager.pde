class DeviceManager {  
  String clockSourceName = "";
  
  public void setupIODevices() {
    MidiBus.findMidiDevices();
    addControllerInputs();
    addAllOutputs();
  }
  
  // Adds LPD8 and MIDI Mix controllers if found
  public Boolean addControllerInputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableInputs().length; i++) {
      if (MidiBus.availableInputs()[i].contains("Mix")) {
        midiBus.addInput(MidiBus.availableInputs()[i]);
        found = true;
      }
    }
    return found;
  }
  
  public void addAllOutputs() {
    for (int i = 0; i < MidiBus.availableOutputs().length; i++) {
      midiBus.addOutput(MidiBus.availableOutputs()[i]);
    }
  }
  
  public void addAllInputs() {
    for (int i = 0; i < MidiBus.availableInputs().length; i++) {
      println(MidiBus.availableInputs()[i]);
      println(midiBus.addInput(MidiBus.availableInputs()[i]));
    }
  }
  
  public void removeNonControllerInputs() {
    for (int i = 0; i < MidiBus.availableInputs().length; i++) {
      if (MidiBus.availableInputs()[i].contains("Mix")) {
        continue;
      } else {
        midiBus.removeInput(MidiBus.availableInputs()[i]);
      }
    }
  }
}
