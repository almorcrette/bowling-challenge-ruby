require './lib/game'
require 'stringio'

describe Game do

  
  let(:frame) { double :frame, frame_num: :frame_num }

  let(:frame_roll_strike) {
    double :frame_roll_strike,
    log: {
      frame_num: :frame_num,
      first_roll: 10,
      second_roll: nil
    },
    strike?: true
  }

  let(:frame_roll_not_strike) {
    double :frame_roll_not_strike,
    log: {
      frame_num: :frame_num,
      first_roll: 5,
      second_roll: nil
    },
    strike?: false
  }

  let(:frame_roll_spare) {
    double :frame_roll_spare,
    log: {
      frame_num: :frame_num,
      first_roll: 5,
      second_roll: 5
    }
  }

  let(:frame_roll_not_spare) {
    double :frame_roll_not_spare,
    log: {
      frame_num: :frame_num,
      first_roll: 5,
      second_roll: 3
    }
  }

  let(:frame_class) { double :frame_class, new: frame }

  let(:game) { described_class.new }

  describe '#play_frame' do

    describe 'when the first roll is not a strike' do
      it "records first and second rolls and add them to the frame's basic score" do
        allow(frame_class).to receive(:new_play).and_return frame_roll_not_strike
        allow(frame_roll_not_strike).to receive(:second_play).and_return frame_roll_not_spare
        expect(game.play_frame(:frame_num, frame_class)).to eq [{ frame_num: :frame_num, first_roll: 5, second_roll: 3 }]
      end
    end

    # problem with this test. It doesn't actually test that the frame is closed after a single roll.
    describe 'when the first roll is a strike' do
      it 'ends the frame after one roll' do
        allow(frame_class).to receive(:new_play).and_return frame_roll_strike
        expect(game.play_frame(:frame_num, frame_class)).to eq [{ frame_num: :frame_num, first_roll: 10, second_roll: nil }]
      end
    end

    it "prints the frame's basic score at the end of the frame" do
      allow(frame_class).to receive(:new_play).and_return frame_roll_not_strike
      allow(frame_roll_not_strike).to receive(:second_play).and_return frame_roll_not_spare
      expect(game.play_frame(:frame_num, frame_class)).to eq [{ frame_num: :frame_num, first_roll: 5, second_roll: 3 }]
    end

  end

  describe '#play_roll' do 
    it "records the roll and add it to the frame's basic score" do
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { first_roll: 6, second_roll: nil } )
      expect(game.play_roll(frame, :first_roll).log).to eq( { first_roll: 6, second_roll: nil } )
    end
  end

  describe '#play' do
    it 'plays through a full ten frames and returns a game scoresheet' do
      allow(frame_class).to receive(:new_play).and_return frame_roll_not_strike
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
      expect(game.scoresheet).to eq [{ frame_num: :frame_num, first_roll: 5, second_roll: nil }]
      
      

      
      # allow(frame).to receive(:roll).and_return(6)
      # allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: nil })
      # allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: nil } )
      # frame_log = game.play_roll(frame, :first_roll)
      # game.update_gamesheet(frame_log)
      # expect(game.scoresheet).to eq [{ frame_num: :frame_num, first_roll: 6, second_roll: nil }]
    end

    it 'adds a second roll result to the gamesheet in the current frame' do
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: nil } )
      played_frame = game.play_roll(frame, :first_roll)
      game.update_gamesheet(played_frame)
      allow(frame).to receive(:roll).and_return(3)
      allow(frame).to receive(:update_score).with(:second_roll, 3).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: 3 })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: 3 } )
      frame_log = game.play_roll(frame, :second_roll)
      game.update_gamesheet(frame_log)
      expect(game.scoresheet).to eq [{ frame_num: :frame_num, first_roll: 6, second_roll: 3 }]
    end

    it 'updates total scores of previous frames based on bonus scoring' do
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: nil } )
      played_frame = game.play_roll(frame, :first_roll)
      game.update_gamesheet(played_frame)
      allow(frame).to receive(:roll).and_return(3)
      allow(frame).to receive(:update_score).with(:second_roll, 3).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: 3 })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: 3 } )
      frame_log = game.play_roll(frame, :second_roll)
      game.update_gamesheet(frame_log)
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: nil } )
      frame_log= game.play_roll(frame, :first_roll)
      game.update_gamesheet(frame_log)
      expect(game.scoresheet).to eq [
        { frame_num: 1, first_roll: 6, second_roll: 4, score: 16 },
        { frame_num: 2, first_roll: 6, second_roll: nil }
      ]
    end
  end

end
