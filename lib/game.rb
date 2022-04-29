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
    unless frame.log[:bonus] == :strike
      frame = frame.second_play
      update_gamesheet(frame)
    end
    puts @scoresheet[-1]
    @scoresheet
  end

  def update_gamesheet(played_frame)
    if frame_open?(played_frame)
      post_second_roll(played_frame)
      basic_score(played_frame)
      if strike_previous?
        score_previous_strike(played_frame)
      end
    else
      post_first_roll(played_frame)
      if spare_previous?
        score_previous_spare(played_frame)
      end
      if strike_previous_two?
        score_lastbutone_strike(played_frame)
      end
    end
    @scoresheet
  end

  private

  def post_first_roll(played_frame)
    @scoresheet << played_frame.log
  end

  def frame_open?(played_frame)
    @scoresheet.length >= 1 && @scoresheet[-1][:frame_num] == played_frame.log[:frame_num]
  end

  def post_second_roll(played_frame)
    @scoresheet[-1][:second_roll] = played_frame.log[:second_roll]
  end

  def basic_score(played_frame)
    if played_frame.log[:bonus] == nil
      @scoresheet[-1][:score] = played_frame.log[:score]
    else
      @scoresheet[-1][:bonus] = played_frame.log[:bonus]
    end
  end

  def spare_previous?
    @scoresheet.length > 1 && @scoresheet[-2][:bonus] == :spare
  end

  def score_previous_spare(played_frame)
    @scoresheet[-2][:score] = played_frame.log[:first_roll] + @scoresheet[-2][:first_roll] + @scoresheet[-2][:second_roll]
  end

  def strike_previous?
    @scoresheet.length > 1 && @scoresheet[-2][:bonus] == :strike
  end

  def score_previous_strike(played_frame)
    @scoresheet[-2][:score] = played_frame.log[:first_roll] + played_frame.log[:second_roll] + @scoresheet[-2][:first_roll]
  end

  def strike_previous_two?
    @scoresheet.length > 2 && @scoresheet[-3][:bonus] == :strike && @scoresheet[-2][:bonus] == :strike
  end

  def score_lastbutone_strike(played_frame)
    @scoresheet[-3][:score] = played_frame.log[:first_roll] + @scoresheet[-2][:first_roll] + @scoresheet[-2][:first_roll]
  end

end
