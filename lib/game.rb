require_relative './frame'
require 'stringio'

class Game

  def self.play(frame_class = Frame)
    game = Game.new
    10.times { game.scoresheet << game.play_frame(frame_class.new) }
    game.scoresheet
  end

  attr_reader :scoresheet

  def initialize
    @scoresheet = []
  end

  def play_frame(frame = Frame.new)
    first_roll = frame.roll
    frame.update_score(:first_roll, first_roll)
    unless frame.strike?
      second_roll = frame.roll
      frame.update_score(:second_roll, second_roll)
    end
    p frame.log
  end

  def play_roll(frame = Frame.new, roll_num)
    roll = frame.roll
    frame.update_score(roll_num, roll)
    frame.log
  end

  def update_gamesheet(played_frame_log)
    @scoresheet.each do |frame_log|
      if played_frame_log[:frame_num] == frame_log[:frame_num]
        frame_log[:second_roll] = played_frame_log[:second_roll]
        return @scoresheet
      end
    end
    @scoresheet << played_frame_log
    @scoresheet
  end



end
