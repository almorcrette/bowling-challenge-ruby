require './lib/game'
require 'stringio'

describe Game do
 
  let(:frame) { double :frame, frame_num: :frame_num }

  let(:frame_roll_strike) {
    double :frame_roll_strike,
    log: {
      frame_num: 1,
      first_roll: 10,
      second_roll: nil,
      bonus: :strike
    },
    strike?: true
  }

  let(:frame_roll_not_strike) {
    double :frame_roll_not_strike,
    log: {
      frame_num: 1,
      first_roll: 5,
      second_roll: nil,
      bonus: nil
    },
    strike?: false
  }

  let(:frame_roll_spare) {
    double :frame_roll_spare,
    log: {
      frame_num: 1,
      first_roll: 5,
      second_roll: 5,
      bonus: :spare
    }
  }

  let(:frame_roll_not_spare) {
    double :frame_roll_not_spare,
    log: {
      frame_num: 1,
      first_roll: 5,
      second_roll: 3,
      bonus: nil,
      score: 8
    }
  }

  # let(:subs_frame_roll_not_strike) {
  #   double :subsequent_frame_not_strike,
  #   log: {
  #     frame_num: 2,
  #     first_roll: 5,
  #     second_roll: nil,
  #     bonus: nil,
  #     score: nil
  #   }
  # }

  let(:next_frame_roll_not_strike) {
    double :next_frame_roll_not_strike,
    log: {
      frame_num: 2,
      first_roll: 5,
      second_roll: nil,
      bonus: nil,
      score: nil
    }
  }

  let(:next_frame_roll_not_spare) {
    double :next_frame_roll_not_spare,
    log: {
      frame_num: 2,
      first_roll: 5,
      second_roll: 3,
      bonus: nil,
      score: nil
    }
  }

  let(:next_frame_roll_strike) {
    double :next_frame_roll_strike,
    log: {
      frame_num: 2,
      first_roll: 10,
      second_roll: nil,
      bonus: :strike,
      score: nil

    }
  }

  let(:third_frame_roll) {
    double :third_frame_roll,
    log: {
      frame_num: 3,
      first_roll: 5,
      second_roll: nil,
      bonus: nil,
      score: nil
    }
  }

  let(:frame_class) { double :frame_class, new: frame }

  let(:game) { described_class.new }

  describe '#play_frame' do

    describe 'when the first roll is not a strike' do
      it "records first and second rolls and add them to the frame's basic score" do
        allow(frame).to receive(:first_play).and_return frame_roll_not_strike
        allow(frame_roll_not_strike).to receive(:second_play).and_return frame_roll_not_spare
        expect(game.play_frame(:frame_num, frame_class)).to eq [{ frame_num: 1, first_roll: 5, second_roll: 3, bonus: nil, score: 8 }]
      end
    end

    describe 'when the first roll is a strike' do
      it 'ends the frame after one roll' do
        allow(frame).to receive(:first_play).and_return frame_roll_strike
        expect(game.play_frame(:frame_num, frame_class)).to eq [{ frame_num: 1, first_roll: 10, second_roll: nil, bonus: :strike }]
      end
    end

    it "prints the frame's basic score at the end of the frame" do
      allow(frame).to receive(:first_play).and_return frame_roll_not_strike
      allow(frame_roll_not_strike).to receive(:second_play).and_return frame_roll_not_spare
      expect(game.play_frame(:frame_num, frame_class)).to eq [{ frame_num: 1, first_roll: 5, second_roll: 3, bonus: nil, score: 8 }]
    end

  end

  describe '#play' do
    it 'plays through a full ten frames and returns a game scoresheet' do
      allow(frame).to receive(:first_play).and_return frame_roll_not_strike
      allow(frame_roll_not_strike).to receive(:second_play).and_return frame_roll_not_spare
      gamesheet = []
      (1..10).each do |i|
        gamesheet << game.play_frame(i, frame_class)
      end
      # expect(Game.play(frame_class)).to eq gamesheet
    end
  end

  describe '#update_gamesheet' do
    it 'adds a first roll result to the gamesheet in a new frame' do
      game.update_gamesheet(frame_roll_not_strike)
      expect(game.scoresheet).to eq [{ frame_num: 1, first_roll: 5, second_roll: nil, bonus: nil }]
    end

    it 'adds a second roll result to the gamesheet in the current frame' do
      game.update_gamesheet(frame_roll_not_strike)
      game.update_gamesheet(frame_roll_not_spare)
      expect(game.scoresheet).to eq [{ frame_num: 1, first_roll: 5, second_roll: 3, bonus: nil, score: 8 }]
    end

    it 'updates total score of a previous spare frame based on first roll of the next frame' do
      game.update_gamesheet(frame_roll_not_strike)
      game.update_gamesheet(frame_roll_spare)
      game.update_gamesheet(next_frame_roll_not_strike)
      expect(game.scoresheet).to eq [
        { frame_num: 1, first_roll: 5, second_roll: 5, bonus: :spare, score: 15 },
        { frame_num: 2, first_roll: 5, second_roll: nil, bonus: nil, score: nil },
       ]
    end

    it 'updates total score of a previous strike frame based on the rolls of the next frame' do
      game.update_gamesheet(frame_roll_strike)
      game.update_gamesheet(next_frame_roll_not_strike)
      game.update_gamesheet(next_frame_roll_not_spare)
      expect(game.scoresheet).to eq [
        { frame_num: 1, first_roll: 10, second_roll: nil, bonus: :strike, score: 18 },
        { frame_num: 2, first_roll: 5, second_roll: 3, bonus: nil, score: nil },
       ]
    end

    it 'updates total score a previous strike frame with strike roll and first roll of the next frame' do
      game.update_gamesheet(frame_roll_strike)
      game.update_gamesheet(next_frame_roll_strike)
      game.update_gamesheet(third_frame_roll)
      expect(game.scoresheet).to eq [
      { frame_num: 1, first_roll: 10, second_roll: nil, bonus: :strike, score: 25 },
      { frame_num: 2, first_roll: 10, second_roll: nil, bonus: :strike, score: nil },
      { frame_num: 3, first_roll: 5, second_roll: nil, bonus: nil, score: nil }
      ]
    end

  end

end
