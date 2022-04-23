require '.lib/roll'

describe Roll do

  let(:frame) { double(:frame) }

  let(:roll) { described_class.new(frame) }
  let(:another_roll) { described_class.new(frame, standing_pins = 4) }

  describe '::new' do
    it 'initializes with a given number of standing pins before the roll' do
      expect(roll.standing_pins).to eq 10
      expect(another_roll.standing_pins).to eq 4
    end

    it 'initializes within a given frame' do
      expect(roll.frame).to eq :frame
    end
  end

  describe '#get_roll' do

    let(:valid_user_input) { "3" }
    let(:invalid_user_input_for_another_roll) { "7" }

    # it 'receives user input of number of pins knocked down' do
    #   expect(another_roll.get_roll(valid_user_input))


    # end

    it 'generates a roll score based on number of pins knocked over' do
      roll.get_roll(valid_user_input)
      expect(roll.roll_score).to eq valid_user_input
    end

    it 'generates a number of pins standing at the end of the roll' do
      roll.get_roll(valid_user_input).to change { roll.standing_pins }.from(10).to(7)
    end

    it 'prevents user input of more pins knocked down than standing before the roll' do
      expect(another_roll.get_roll(invalid_user_input_for_another_roll)).not_to change { roll.standing_pins }
      expect(another_roll.get_roll(invalid_user_input_for_another_roll)).to eq "Invalid input: You cannot know over more pins than were standing in the first place!"
    end

  end

end