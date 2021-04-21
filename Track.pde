
class Track {
  public String id;
  public int channel;
  public int note;
  public int currentPatternIndex = 0;
  public int[] steps;
  public int[] beats;
  public int[] rotate;
  public int[] accents;
  public color trackColor;
  public boolean isMuted = false;
  public boolean isSolo = false;
  public boolean isRolling = false;
  public int rollPeriod = 2; // when rolling, play a note every *rollPeriod* pulses
  public int lfoPeriod = 32; // period in ticks, from 0 to 127
  public int lfoAmount = 0; // -27 - +27
  public int controllerLightNote;

  int normalVelocity = 100;
  int accentVelocity = 127;
  
  public int[] computedSteps;

  public Track(String inId, int inChannel, int inNote, int inSteps, int inBeats, int inRotate, int inAccents, color inColor, int inControllerLightNote) {
    id = inId;
    channel = inChannel;
    note = inNote;
    steps = new int[]{inSteps, inSteps};
    beats = new int[]{inBeats, inBeats};
    rotate = new int[]{inRotate, inRotate};
    accents = new int[]{inAccents, inAccents};
    trackColor = inColor;
    controllerLightNote = inControllerLightNote;
    computeSteps();
  }
  
  public int steps() {
    return steps[currentPatternIndex];
  }
  
  public void setSteps(int count) {
    steps[currentPatternIndex] = count;
  }
  
  public int beats() {
    return beats[currentPatternIndex];
  }
  
  public void setBeats(int count) {
    beats[currentPatternIndex] = count;
  }
  
  public int rotate() {
    return rotate[currentPatternIndex];
  }
  
  public void setRotate(int count) {
    rotate[currentPatternIndex] = count;
  }
  
  public int accents() {
    return accents[currentPatternIndex];
  }
  
  public void setAccents(int count) {
    accents[currentPatternIndex] = count;
  }
  
  public void copyAtoB() {
    steps[1] = steps[0];
    beats[1] = beats[0];
    rotate[1] = rotate[0];
    accents[1] = accents[0];
  }
  
  public void copyBtoA() {
    steps[0] = steps[1];
    beats[0] = beats[1];
    rotate[0] = rotate[1];
    accents[0] = accents[1];
  }

  public void computeSteps() {
    Vector<Boolean> sequence = computeEuclideanSequence(beats[currentPatternIndex], steps[currentPatternIndex]);
    Vector<Boolean> accentsSequence = computeEuclideanSequence(accents[currentPatternIndex], beats[currentPatternIndex]);
    
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
    ArrayRightRotation.rotateRight(beats, rotate[currentPatternIndex], steps[currentPatternIndex]);
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
