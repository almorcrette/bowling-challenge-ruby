require './lib/game'
require 'stringio'

describe Game do

  
  let(:frame) { double :frame }
  let(:frame_class) { double :frame_class, new: frame }

  let(:game) { described_class.new }

  describe '#play_frame' do

    describe 'when the first roll is not a strike' do
      it "records first and second rolls and add them to the frame's basic score" do
        allow(frame).to receive(:roll).and_return(6, 3)
        allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ first_roll: 6, second_roll: nil })
        allow(frame).to receive(:strike?).and_return(false)
        allow(frame).to receive(:update_score).with(:second_roll, 3).and_return({ first_roll: 6, second_roll: 3 })
        allow(frame).to receive(:log).and_return( { first_roll: 6, second_roll: 3 } )
        expect(game.play_frame(frame)).to eq( { first_roll: 6, second_roll: 3 } )
      end
    end

    # problem with this test. It doesn't actually test that the frame is closed after a single roll.
    describe 'when the first roll is a strike' do
      it 'ends the frame after one roll' do
        allow(frame).to receive(:roll).and_return(10)
        allow(frame).to receive(:update_score).with(:first_roll, 10).and_return({ first_roll: 10, second_roll: nil })
        allow(frame).to receive(:strike?).and_return(true)
        allow(frame).to receive(:log).and_return( { first_roll: 10, second_roll: nil } )
        expect(game.play_frame(frame)).to eq( { first_roll: 10, second_roll: nil } )
      end
    end

    it "prints the frame's basic score at the end of the frame" do
      allow(frame).to receive(:roll).and_return(6, 3)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ first_roll: 6, second_roll: nil })
      allow(frame).to receive(:strike?).and_return(false)
      allow(frame).to receive(:update_score).with(:second_roll, 3).and_return({ first_roll: 6, second_roll: 3 })
      allow(frame).to receive(:log).and_return( { first_roll: 6, second_roll: 3 } )
      expect { game.play_frame(frame) }.to output("{:first_roll=>6, :second_roll=>3}\n").to_stdout
    end

  end

  describe '#play_roll' do 
    it "records the roll and add it to the frame's basic score" do
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { first_roll: 6, second_roll: nil } )
      expect(game.play_roll(frame, :first_roll)).to eq( { first_roll: 6, second_roll: nil } )
    end
  end

  describe '#play' do
    it 'plays through a full ten frames and returns a game scoresheet' do
      allow(frame).to receive(:roll)
      allow(frame).to receive(:update_score)
      allow(frame).to receive(:strike?)
      allow(frame).to receive(:update_score)
      allow(frame).to receive(:log).and_return(:log)
      gamesheet = []
      10.times { gamesheet << game.play_frame(frame) }
      expect(Game.play(frame_class)).to eq gamesheet
    end
  end

  describe '#update_gamesheet' do
    it 'adds a first roll result to the gamesheet in a new frame' do
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: nil } )
      frame_log = game.play_roll(frame, :first_roll)
      game.update_gamesheet(frame_log)
      expect(game.scoresheet).to eq [{ frame_num: :frame_num, first_roll: 6, second_roll: nil }]
    end

    it 'adds a second roll result to the gamesheet in the current frame' do
      allow(frame).to receive(:roll).and_return(6)
      allow(frame).to receive(:update_score).with(:first_roll, 6).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: nil })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: nil } )
      frame_log= game.play_roll(frame, :first_roll)
      game.update_gamesheet(frame_log)
      allow(frame).to receive(:roll).and_return(3)
      allow(frame).to receive(:update_score).with(:second_roll, 3).and_return({ frame_num: :frame_num, first_roll: 6, second_roll: 3 })
      allow(frame).to receive(:log).and_return( { frame_num: :frame_num, first_roll: 6, second_roll: 3 } )
      frame_log = game.play_roll(frame, :second_roll)
      game.update_gamesheet(frame_log)
      expect(game.scoresheet).to eq [{ frame_num: :frame_num, first_roll: 6, second_roll: 3 }]
    end
  end

end
