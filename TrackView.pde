class TrackView {
  public String id;
  public int[] steps;
  public color trackColor;
  
  public float getAngle() {
    return 0.0;
  }
  
  public TrackView(String inId, int[] inSteps, color inColor) {
    id = inId;
    steps = inSteps;
    trackColor = inColor;
  }
}
