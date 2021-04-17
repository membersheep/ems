class DeviceManager {  
  int inputIndex = -1;
  String inputName = "";
  int controllerIndex = -1;
  String controllerName = "";
  int outputIndex = -1;
  String outputName = "";
  
  public String[] defaults() {
    String[] outputs = MidiBus.availableOutputs();
    String[] inputs = MidiBus.availableInputs();
    String output = "";
    String input = "";
    for (int i = 0; i < outputs.length; i++) {
      if (outputs[i].contains("fmidi")) {
        output = outputs[i];
        println("default output found");
      }
    }
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i].contains("Mix")) {
        input = inputs[i];
        println("default input found");
      }
    }
    return new String[]{input, output};
  }
  
  public String getNextController() {
    if (MidiBus.availableInputs().length > controllerIndex + 1) {
      return MidiBus.availableInputs()[controllerIndex + 1];
    } else if (MidiBus.availableInputs().length > 0) {
      return MidiBus.availableInputs()[0];
    } else {
      return "";
    }
  }
  
  public int getNextControllerIndex() {
    if (MidiBus.availableInputs().length > controllerIndex + 1) {
      return controllerIndex + 1;
    } else if (MidiBus.availableInputs().length > 0) {
      return 0;
    } else {
      return -1;
    }
  }
  
  public String getNextInput() {
    if (MidiBus.availableInputs().length > inputIndex + 1) {
      return MidiBus.availableInputs()[inputIndex + 1];
    } else {
      return "INTERNAL";
    }
  }
  
  public int getNextInputIndex() {
    if (MidiBus.availableInputs().length > inputIndex + 1) {
      return inputIndex + 1;
    } else {
      return -1;
    }
  }
  
  public String nextOutput() {
    if (MidiBus.availableOutputs().length > outputIndex + 1) {
      outputIndex = outputIndex + 1;
      outputName = MidiBus.availableOutputs()[outputIndex];
    } else {
      outputIndex = -1;
      outputName = "ALL";
    }
    return outputName;
  }
  
  public Boolean addAllOutputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableOutputs().length; i++) {
      midiBus.addOutput(MidiBus.availableOutputs()[i]);
      found = true;
    }
    return found;
  }
  
  // Adds LPD8 and MIDI Mix controllers if found
  public Boolean addKnownInputs() {
    Boolean found = false;
    for (int i = 0; i < MidiBus.availableInputs().length; i++) {
      if (MidiBus.availableInputs()[i] == "LPD8" || MidiBus.availableInputs()[i] == "MIDI Mix") {
        midiBus.addInput(MidiBus.availableInputs()[i]);
        found = true;
      }
    }
    return found;
  }
}
