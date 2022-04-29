require_relative './frame'
require 'stringio'

class Game

  def self.play(frame_class = Frame)
    game = Game.new
    (1..10).each do |i|
      game.play_frame(i, frame_class)
    end
    game.scoresheet
  end

  attr_reader :scoresheet

  def initialize
    @scoresheet = []
  end

  def play_frame(frame_num, frame_class = Frame)
    frame = frame_class.new(frame_num)
    frame = frame.first_play
    update_gamesheet(frame)
    unless frame.strike?
      frame = frame.second_play
      update_gamesheet(frame)
    end
    p @scoresheet
  end

  def play_roll(frame, roll_num)
    roll = frame.roll
    frame.update_score(roll_num, roll)
    frame
  end

  def update_gamesheet(played_frame)
    p "Scoresheet length #{@scoresheet.length}"
    if @scoresheet.length >= 1
      p "Scoresheet #{@scoresheet}"
    end
    p "Played frame log frame num: #{played_frame.log}"
    if @scoresheet.length >= 1 && @scoresheet[-1][:frame_num] == played_frame.log[:frame_num]
      @scoresheet[-1][:second_roll] = played_frame.log[:second_roll]
      if played_frame.log[:bonus] == nil
        @scoresheet[-1][:score] = played_frame.log[:score]
      else
        @scoresheet[-1][:bonus] = played_frame.log[:bonus]
      end
      if @scoresheet.length > 1 && @scoresheet[-2][:bonus] == :strike
        @scoresheet[-2][:score] = played_frame.log[:first_roll] + played_frame.log[:second_roll] + @scoresheet[-2][:first_roll]
      end
      puts @scoresheet
    else
      p "entering this else statement..."
      @scoresheet << played_frame.log
      if @scoresheet.length > 1 && @scoresheet[-2][:bonus] == :spare
        @scoresheet[-2][:score] = played_frame.log[:first_roll] + @scoresheet[-2][:first_roll] + @scoresheet[-2][:second_roll]
      end
      if @scoresheet.length > 2 && @scoresheet[-3][:bonus] == :strike && @scoresheet[-2][:bonus]
        @scoresheet[-3][:score] = played_frame.log[:first_roll] + @scoresheet[-2][:first_roll] + @scoresheet[-2][:first_roll]
      end
      puts @scoresheet
    end
    p "scoresheet length #{@scoresheet.length}"
    @scoresheet
  end



end
