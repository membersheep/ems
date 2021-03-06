# EMS - Euclidean Multitrack Sequencer
# v0.1 - 2021-02-23
# SonicPi v3.3.1 on Mac
# by membersheep
#
# :
# Use /midi:lpd8:1/program_change [1] to select track
# Use /midi:lpd8:1/control_change [1,60] to change parameter
# Parameters:
# beats
# length: length of the sequence
# accent_beats: number of accented beats spread among the beats
# offset: translation offset of the beats
# rate: ratchet/flam
# min_velocity: min velocity for non accented beats
# max_velocity: max velocity for non accented beats
# velocity_rate: velocity variation period
# velocity_pattern: random, lfo
#
# Configuration:
# beat_division: the step sequence time division
# max_steps: maximum number of steps per sequence
#
# Send midi clock to external midi source https://gist.github.com/darinwilson/7cecd47f866357192aa715975a0e080e
# Add osc connection to control visual effects

## GENERAL PARAMETERS
set :bpm, 120
set :accent_velocity, 127
set :normal_velocity, 100
set :beat_division, 4 # steps per beat
set :max_steps, 64 # max steps sequence length
set :current_track, 0 # 0 - 7

## TRACK PARAMETERS
set :track1_note, :c0
set :track1_length, 16 # 0 - 127
set :track1_beats, 4 # 0 - length
set :track1_rotate, 0 # 0 - 127
set :track1_accent_beats, 1 # 0 - beats

set :tracks_note, (ring :c2, :d2, :e2, :f2, :g2, :a2, :b2, :c3) # 0 - 127
set :tracks_length, (ring 16, 16, 16, 16, 16, 16, 16, 16) # 0 - 127
set :tracks_beats, (ring 4, 4, 4, 4, 4, 4, 4, 4) # 0 - length
set :tracks_rotate, (ring 0, 0, 0, 0, 0, 0, 0, 0) # 0 - 127
set :tracks_accent_beats, (ring 1, 1, 1, 1, 1, 1, 1, 1) # 0 - beats
set :tracks_accent_rotate, (ring 0, 0, 0, 0, 0, 0, 0, 0) # 0 - 127

## ADDITIONAL PARAMETERS - Currently not used
# set :tracks_rate, (ring 1, 1, 1, 1, 1, 1, 1, 1) # 1-8
# set :tracks_min_velocity, (ring 100, 100, 100, 100, 100, 100, 100, 100) # 0-127
# set :tracks_max_velocity, (ring 127, 127, 127, 127, 127, 127, 127, 127) # 0-127
# set :tracks_velocity_rate, (ring 100, 100, 100, 100, 100, 100, 100, 100) # 0-127

## SEQUENCE COMPTUTER

use_osc '127.0.0.1', 5000

define :computeSequence do |id|
  steps = (spread get[:tracks_beats][id], get[:tracks_length][id], rotate: get[:tracks_rotate][id]).to_a
  accents = (spread get[:track_accent_beats][id], get[:tracks_beats][id], rotate: get[:tracks_rotate][id]).to_a
  beatIndex = 0
  velocities = steps.map { |beat|
    if beat
      if accents[beatIndex]
        beatIndex = beatIndex + 1
        get[:accent_velocity]
      else
        get[:normal_velocity]
      end
    else
      0
    end
  }
  return velocities
end

## MIDI READER

live_loop :midi_reader do
  use_real_time
  index, value = sync "/midi:lpd8:1/control_change"
  currentTrackIndex = sync "/midi:lpd8:1/program_change"
  if currentTrackIndex != nil
    set :current_track, currentTrackIndex
    osc "/current", currentTrackIndex.to_s
  end
  if index != nil
    currentTrackIndex = get[:current_track]
    case index
    when 1
      maxSteps = get[:max_steps]
      scaledValue = maxSteps/128*value
      tracksLength = get[:tracks_length]
      newTracksLength = tracksLength.put(currentTrackIndex, scaledValue)
      set :tracks_length, newTracksLength
    when 2
      trackLength = get[:tracks_length][currentTrackIndex]
      scaledValue = trackLength/128*value
      tracksBeats = get[:tracks_beats]
      newTracksBeats = tracksBeats.put(currentTrackIndex, [trackLength, scaledValue].min)
      set :tracks_beats, newTracksBeats
    when 3
      trackBeats = get[:tracks_beats][currentTrackIndex]
      scaledValue = trackBeats/128*value
      tracksRotate = get[:tracks_rotate]
      newTracksRotate = tracksRotate.put(currentTrackIndex, [trackBeats, scaledValue].min)
      set :tracks_rotate, newTracksRotate
    when 4
      trackBeats = get[:tracks_beats][currentTrackIndex]
      scaledValue = trackBeats/128*value
      tracksAccents = get[:tracks_accent_beats]
      newTracksAccents = tracksAccents.put(currentTrackIndex, [trackBeats, scaledValue].min)
      set :tracks_accent_beats, newTracksAccents
    when 5
      #set :track1_rate, value
    when 6
      #set :track1_min_velocity, value
    when 7
      #set :track1_max_velocity, value
    when 8
      #set :track1_velocity_rate, value
    end
  end
  osc "/track/update", currentTrackIndex.to_s, (computeSequence currentIndex).to_s
end

## SEQUENCER

live_loop :sequencer do
  #use_real_time
  use_bpm get[:bpm]
  #sync "external/midi/clock"
  division = get[:beat_division]
  division.times do
    tick
    osc "/tick", look
    sleepTime = 1.0/division
    # test clock, to be removed
    sample :perc_snap2
    for i in 0..7
      trackGate = (spread get[:tracks_beats][i],get[:tracks_length][i], rotate: get[:tracks_rotate][i]).look
      if trackGate
        accent = (spread get[:tracks_accent_beats][i],get[:tracks_beats][i]).look
        velocity = accent ? get[:accent_velocity] : 100
        # TODO: add code to apply velocity rate effects (random or lfo)
        midi_note_on get[:tracks_note][i], velocity
      end
    end
    sleep sleepTime
  end
end
