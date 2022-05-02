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

      it 'raises an error' do
        frame.roll
        $stdin = StringIO.new("7")
        expect { frame.roll }.to raise_error("Cannot knock down more pins than are standing")
      end

    end

  end

  describe '#update_log' do 
    it "adds to the :first_roll key the first roll" do
      frame.update_log(:first_roll, 5)
      expect(frame.log[:first_roll]).to eq 5
    end

    it "adds to the :second_roll key the second roll" do
      frame.update_log(:first_roll, 5)
      frame.update_log(:second_roll, 3)
      expect(frame.log[:second_roll]).to eq 3
    end

    it "updates the score if two rolls are less than 10" do
      frame.update_log(:first_roll, 5)
      frame.update_log(:second_roll, 3)
      expect(frame.log[:score]).to be 8
    end

    it "updates the log's 'bonus' key with 'strike' if the first roll is 10" do
      frame.update_log(:first_roll, 10)
      expect(frame.log[:bonus]).to be :strike
    end

    it "updates the log's 'bonus' key with 'spare' if two rolls add up to 10" do
      frame.update_log(:first_roll, 5)
      frame.update_log(:second_roll, 5)
      expect(frame.log[:bonus]).to be :spare
    end
  end

end