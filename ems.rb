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

set :bpm, 120
set :accent_velocity, 127
set :normal_velocity, 100
set :beat_division, 4 # steps per beat
set :max_steps, 64 # max steps sequence length
set :track1_note, :c0

set :current_track, 0 # 0 - 7
set :track1_length, 16 # 0 - 127
set :track1_beats, 4 # 0 - length
set :track1_rotate, 0 # 0 - 127
set :track1_accent_beats, 1 # 0 - beats
set :track1_accent_tick, 0
set :track1_rate, 1 # 1-8
set :track1_min_velocity, 90 # 0-127
set :track1_max_velocity, 110 # 0-127
set :track1_velocity_rate, 100 # 0-127

use_osc '127.0.0.1', 5000

define :computeSequence do |id|
  case id
  when "1"
    steps = (spread get[:track1_beats], get[:track1_length], rotate: get[:track1_rotate]).to_a
    accents = (spread get[:track1_accent_beats], get[:track1_beats], rotate: get[:track1_rotate]).to_a
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
end

live_loop :midi_reader do
  use_real_time
  index, value = sync "/midi:lpd8:1/control_change"
  currentTrackIndex = sync "/midi:lpd8:1/program_change"
  if currentTrackIndex != nil
    set :current_track, currentTrackIndex
    osc "/current", currentTrackIndex.to_s
  end
  if index != nil
    case index
    when 1
      maxSteps = get[:max_steps]
      scaledValue = maxSteps/128*value
      set :track1_length, scaledValue
    when 2
      length = get[:track1_length]
      scaledValue = length/128*value
      set :track1_beats, [length, scaledValue].min
    when 3
      beats = get[:track1_beats]
      set :track1_rotate, [beats, value].min
    when 4
      beats = get[:track1_beats]
      set :track1_accent_beats, [beats, value].min
    when 5
      set :track1_rate, value
    when 6
      set :track1_min_velocity, value
    when 7
      set :track1_max_velocity, value
    when 8
      set :track1_velocity_rate, value
    end
  end
  osc "/track/update", "1", (computeSequence "1").to_s
end

live_loop :sequencer do
  #use_real_time
  use_bpm get[:bpm]
  #sync "external/midi/clock"
  division = get[:beat_division]
  division.times do
    tick
    osc "/tick", look
    sleepTime = 1.0/division
    sample :drum_cymbal_closed # test clock
    track1Gate = (spread get[:track1_beats],get[:track1_length], rotate: get[:track1_rotate]).look
    if track1Gate
      accent = (spread get[:track1_accent_beats],get[:track1_beats]).tick(:track1_accent_tick)
      velocity = accent ? get[:accent_velocity] : 100
      # add code to apply velocity rate effects (random or lfo)
      midi_note_on get[:track1_note], velocity
    end
    sleep sleepTime
  end
end
