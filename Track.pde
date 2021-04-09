
class Track {
  public String id;
  public int channel;
  public int note;
  public int steps;
  public int beats;
  public int rotate;
  public int accents;
  public color trackColor;
  public boolean isMuted = false;
  public boolean isRolling = false;

  int normalVelocity = 100;
  int accentVelocity = 127;
  
  public int[] computedSteps;
  public int[] computedAccents;

  public Track(String inId, int inChannel, int inNote, int inSteps, int inBeats, int inRotate, int inAccents, color inColor) {
    id = inId;
    channel = inChannel;
    note = inNote;
    steps = inSteps;
    beats = inBeats;
    rotate = inRotate;
    accents = inAccents;
    trackColor = inColor;
    computeSteps();
  }

  public void computeSteps() {
    Vector<Boolean> sequence = computeEuclideanSequence(beats, steps);
    Vector<Boolean> accentsSequence = computeEuclideanSequence(accents, beats);
    
    int[] beats = new int[sequence.capacity()];
    int beatIndex = 0;
    for (int i = 0; i < sequence.size(); i++) {
      if (sequence.get(i) == true) {
        if (accentsSequence.get(beatIndex) == true) {
          beats[i] = accentVelocity;
        } else {
          beats[i] = normalVelocity;
        }
        beatIndex++;
      } else {
        beats[i] = 0;
      }
    }
    ArrayRightRotation.rotateRight(beats, rotate, steps);
    computedSteps = beats;
  }
  
  private Vector<Boolean> computeEuclideanSequence(int beats, int steps) {
    Vector<Boolean> pattern = new Vector<Boolean> ( );
    if ( beats >= steps ) {
      /** Fill every steps with a pulse. */
      for ( int i = 0; i < steps; i++ ) {
        pattern.add ( true );
      }
    } else if ( steps == 1 ) {
      pattern.add ( beats == 1 );
    } else if ( beats == 0 ) {
      /** Fill every steps with a silence. */
      for ( int i = 0; i < steps; i++ ) {
        pattern.add ( false );
      }
    } else {
      // SANE INPUT
      int pauses = steps - beats;
      if ( pauses >= beats ) { 
        // first case more pauses than pulses
        int per_pulse = ( int ) Math.floor ( pauses / beats );
        int remainder = pauses % beats;
        for ( int i = 0; i < beats; i++ )
        {
          pattern.add ( true );
          for ( int j = 0; j < per_pulse; j++ )
          {
            pattern.add ( false );
          }
          if ( i < remainder )
          {
            pattern.add ( false );
          }
        }
      } else { 
        // second case more pulses than pauses
        int per_pause = ( int ) Math.floor ( ( beats - pauses ) / pauses );
        int remainder = ( beats - pauses ) % pauses;
        for ( int i = 0; i < pauses; i++ )
        {
          pattern.add ( true );
          pattern.add ( false );
          for ( int j = 0; j < per_pause; j++ )
          {
            pattern.add ( true );
          }
          if ( i < remainder )
          {
            pattern.add ( true );
          }
        }
      }
    }
    return pattern;
  }
}
