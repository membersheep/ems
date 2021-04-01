class Sequencer implements ClockListener {
  Map<String, EMSTrack> tracks = new HashMap<String, EMSTrack>();
  LinkedList<Map.Entry<String, EMSTrack>> sortedTracks;
  
  public Sequencer() {
    tracks.put("1", new EMSTrack("1", 60, 16, 4, 0, Color.RED.getRGB()));
    tracks.put("2", new EMSTrack("2", 61, 8, 5, 0, Color.GREEN.getRGB()));
    tracks.put("3", new EMSTrack("3", 62, 8, 3, 0, Color.YELLOW.getRGB()));
    tracks.put("4", new EMSTrack("4", 63, 4, 1, 0, Color.BLUE.getRGB()));
    sortedTracks = new LinkedList<Map.Entry<String, EMSTrack>>(tracks.entrySet());
    sortTracks();
  }
  
  public void sortTracks() {
    LinkedList<Map.Entry<String, EMSTrack>> list = new LinkedList<Map.Entry<String, EMSTrack>>(tracks.entrySet());
    Collections.sort(list, new Comparator<Map.Entry<String, EMSTrack>>() {
        @Override
        public int compare(Map.Entry<String, EMSTrack> o1, Map.Entry<String, EMSTrack> o2) {
           return o1.getValue().steps - o2.getValue().steps;      
        }
    });
    sortedTracks = list;
  }

  @ Override
  void tick(int tick) {
    println(tick);
  }
}
