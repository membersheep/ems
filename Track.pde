
class Track {
  public String id;
  public int note;
  public int steps;
  public int beats;
  public int rotate;
  public color trackColor;

  public int[] computedSteps;

  public Track(String inId, int inNote, int inSteps, int inBeats, int inRotate, color inColor) {
    id = inId;
    note = inNote;
    steps = inSteps;
    beats = inBeats;
    rotate = inRotate;
    trackColor = inColor;
    computeSteps();
  }

  public void computeSteps() {
    Vector<Boolean> sequence = euclideanSequence();

    int[] beats = new int[sequence.capacity()];
    for (int i = 0; i < sequence.size(); i++) {
      if (sequence.get(i) == true) {
        beats[i] = 127;
      } else {
        beats[i] = 0;
      }
    }
    ArrayRightRotation.rotateRight(beats, rotate, steps);
    computedSteps = beats;
  }

  private Vector<Boolean> euclideanSequence() {
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
