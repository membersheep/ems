class DeviceManager {  
  int inputIndex = -1;
  String inputName = "";
  int controllerIndex = -1;
  String controllerName = "";
  int outputIndex = -1;
  String outputName = "";
  
  public void setupIODevices() {
    MidiBus.findMidiDevices();
    addControllerInputs();
    addAllOutputs();
  }
  
  // Adds LPD8 and MIDI Mix controllers if found
  public Boolean addControllerInputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableInputs().length; i++) {
      if (MidiBus.availableInputs()[i] == "LPD8" || MidiBus.availableInputs()[i] == "MIDI Mix") {
        midiBus.addInput(MidiBus.availableInputs()[i]);
        found = true;
      }
    }
    return found;
  }
  
  public Boolean addAllOutputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableOutputs().length; i++) {
      midiBus.addOutput(MidiBus.availableOutputs()[i]);
      found = true;
    }
    return found;
  }
}
