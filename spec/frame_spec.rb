require './lib/frame'

describe Frame do

  let(:frame) { described_class.new(:frame_num) }

  describe '#initialize' do

    it 'includes the frame number in the frame score for reference' do
      another_frame = Frame.new(5)
      expect(another_frame.log[:frame_num]).to eq 5
    end
  end

  describe '#roll' do

    before do
      $stdin = StringIO.new("6")
    end
    
    after do
      $stdin = STDIN
    end

    it 'reduces the number of standing pins by pins knocked down' do
      frame.roll
      expect(frame.pins_standing).to eq 4
    end

    it 'outputs the score from the roll' do
      expect(frame.roll).to eq 6
    end

    describe 'when attempting to knock down more pins than are standing' do

      before do
        $stdin = StringIO.new("5")
      end
  
      after do
        $stdin = STDIN
      end

      it 'raises an error' do
        frame.roll
        $stdin = StringIO.new("7")
        expect { frame.roll }.to raise_error("Cannot knock down more pins than are standing")
      end

    end

  end

  describe '#update_score' do 
    it "adds to the relevant key a roll result to the frame's score" do
      frame.update_score(:first_roll, 5)
      frame.update_score(:second_roll, 3)
      expect(frame.log).to eq( { frame_num: :frame_num, first_roll: 5, second_roll: 3 })
    end
  end

  describe '#strike?' do

    describe 'when first roll does not knock ten pins down' do
      it 'returns false' do
        frame.update_score(:first_roll, 5)
        frame.update_score(:second_roll, 3)
        expect(frame.strike?).to be false
      end
    end

    describe 'when first roll knocks ten pins down' do
      it 'returns true' do
        frame.update_score(:first_roll, 10)
        expect(frame.strike?).to be true
      end
    end

  end
end