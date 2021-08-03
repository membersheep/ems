class TrackParameter {
  public String name;
  public int lfoPeriod = 32; // period in ticks, from 0 to 127
  public int lfoAmount = 0; // -27 - +27
  // todo: add parameter to control the wave shape
  public int minValue = 0;
  public int maxValue = 127;
  public int midiCC;

    public TrackParameter(String inName, int inPeriod, int inAmount, int inMin, int inMax, int inCc) {
      name = inName;
      lfoPeriod = inPeriod;
      lfoAmount = inAmount;
      minValue = inMin;
      maxValue = inMax;
      midiCC = inCc;
    }
}

class Track {
  public String id;
  public int channel;
  public int note;
  public int[] steps;
  public int[] beats;
  public int[] rotate;
  public int[] accents;
  public color trackColor;
  public boolean isMuted = false;
  public boolean isSolo = false;
  public boolean isRolling = false;
  public int rollPeriod = 2; // when rolling, play a note every *rollPeriod* pulses
  public TrackParameter[] parameters;
  public currentParameterIndex = 0;
  public int controllerLightNote;
  
  public int currentPatternIndex = 0; // 0 or 1, the pattern currently displayed and being edited
  public int[] computedStepsA;
  public int[] computedStepsB;
  public int[] computedSteps;
  public String patternChain = "A";

  public Track(String inId, int inChannel, int inNote, int inSteps, int inBeats, int inRotate, int inAccents, TrackParameter[] params, color inColor, int inControllerLightNote) {
    id = inId;
    channel = inChannel;
    note = inNote;
    steps = new int[]{inSteps, inSteps};
    beats = new int[]{inBeats, inBeats};
    rotate = new int[]{inRotate, inRotate};
    accents = new int[]{inAccents, inAccents};
    trackColor = inColor;
    parameters = params;
    controllerLightNote = inControllerLightNote;
    computeSteps();
  }

  public int[] currentPattern() {
    return currentPatternIndex == 0 ? computedStepsA : computedStepsB;
  }

  // Returns the current step index given a tick. If the current step is not in the current pattern it returns -1.
  public int currentStepIndexFor(int tick) {
    if (computedSteps.length < 1) {
      return -1;
    }
    int stepIndex = tick % computedSteps.length;
    int currentStepIndex = -1;
    int index = 0;
    for (char character: patternChain.toCharArray()) {
      if (character == 'A') {
        if (stepIndex < index + computedStepsA.length && currentPatternIndex == 0) { // FOUND!
          currentStepIndex = stepIndex - index;
          break;
        } else {
          index = index + computedStepsA.length;
        }
      } else if (character == 'B') {
        if (stepIndex < index + computedStepsB.length && currentPatternIndex == 1) { // FOUND!
          currentStepIndex = stepIndex - index;
          break;
        } else {
          index = index + computedStepsA.length;
        }
      }
    }
    return currentStepIndex;
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
    computeStepsA();
    computeStepsB();
    int aCount = 0;
    int bCount = 0;
    for (char character: patternChain.toCharArray()) {
      if (character == 'A') {
        aCount++;
      } else if (character == 'B') {
        bCount++;
      }
    }
    int[] chain = new int[aCount * computedStepsA.length + bCount * computedStepsB.length];
    int index = 0;
    for (char character: patternChain.toCharArray()) {
      if (character == 'A') {
        System.arraycopy(computedStepsA, 0, chain, index, computedStepsA.length);
        index = index + computedStepsA.length;
      } else if (character == 'B') {
        System.arraycopy(computedStepsB, 0, chain, index, computedStepsB.length);
        index = index + computedStepsB.length;
      }
    }
    computedSteps = chain;
  }

  private void computeStepsA() {
    Vector<Boolean> sequence = computeEuclideanSequence(beats[0], steps[0]);
    Vector<Boolean> accentsSequence = computeEuclideanSequence(accents[0], beats[0]);
    int[] patternBeats = new int[sequence.size()];
    int beatIndex = 0;
    for (int i = 0; i < sequence.size(); i++) {
      if (sequence.get(i) == true) {
        if (accentsSequence.get(beatIndex) == true) {
          patternBeats[i] = accentVelocity;
        } else {
          patternBeats[i] = normalVelocity;
        }
        beatIndex++;
      } else {
        patternBeats[i] = 0;
      }
    }
    ArrayRightRotation.rotateRight(patternBeats, rotate[0], steps[0]);
    computedStepsA = patternBeats;
  }

  private void computeStepsB() {
    Vector<Boolean> sequence = computeEuclideanSequence(beats[1], steps[1]);
    Vector<Boolean> accentsSequence = computeEuclideanSequence(accents[1], beats[1]);
    int[] patternBeats = new int[sequence.size()];
    int beatIndex = 0;
    for (int i = 0; i < sequence.size(); i++) {
      if (sequence.get(i) == true) {
        if (accentsSequence.get(beatIndex) == true) {
          patternBeats[i] = accentVelocity;
        } else {
          patternBeats[i] = normalVelocity;
        }
        beatIndex++;
      } else {
        patternBeats[i] = 0;
      }
    }
    ArrayRightRotation.rotateRight(patternBeats, rotate[0], steps[0]);
    computedStepsB = patternBeats;
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
