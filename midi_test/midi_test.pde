import javax.sound.midi.*;
import java.util.*;
import java.awt.*;

MidiDevice device;
MidiDevice.Info[] infos = MidiSystem.getMidiDeviceInfo();
    
void setup() {
  for (MidiDevice.Info info : infos) {
    System.out.println("Info: '" + info.toString() + "'");
    try {
      device = MidiSystem.getMidiDevice(info);
      System.out.println("Info: '" + device.toString() + "'");
    } catch (MidiUnavailableException e) {
      println("error");
    }
  }
}
