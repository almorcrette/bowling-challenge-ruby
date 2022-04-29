require_relative './frame'
require 'stringio'

class Game

  def self.play(frame_class = Frame)
    game = Game.new
    (1..10).each do |i|
      game.scoresheet << game.play_frame(i, frame_class)
    end
    game.scoresheet
  end

  attr_reader :scoresheet

  def initialize
    @scoresheet = []
  end

  def play_frame(frame_num, frame_class = Frame)
    frame = frame_class.new_play(frame_num)
    update_gamesheet(frame)
    unless frame.strike?
      frame = frame.second_play
      update_gamesheet(frame)
    end
    @scoresheet
  end

  def play_roll(frame, roll_num)
    roll = frame.roll
    frame.update_score(roll_num, roll)
    frame
  end

  def update_gamesheet(played_frame)
    @scoresheet.each do |frame_log|
      if played_frame.log[:frame_num] == frame_log[:frame_num]
        frame_log[:second_roll] = played_frame.log[:second_roll]
        if played_frame.log[:bonus] == nil
          frame_log[:score] = played_frame.log[:score]
        else
          frame_log[:bonus] = played_frame.log[:bonus]
        end
        return @scoresheet
      end
    end
    @scoresheet << played_frame.log
    if @scoresheet.length > 1 && @scoresheet[-2][:bonus] == :spare
      @scoresheet[-2][:score] = played_frame.log[:first_roll] + @scoresheet[-2][:first_roll] + @scoresheet[-2][:second_roll]
    end
    @scoresheet
  end



end
