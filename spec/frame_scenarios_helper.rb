let(:frame) { double :frame, frame_num: :frame_num }

  let(:frame_with_two_rolls) {
    double :frame_with_two_rolls,
    log: {
      frame_num: :frame_num,
      first_roll: 7,
      second_roll: 2
    }
  }

  let(:frame_with_one_roll) {
    double :frame_with_one_roll,
    log: {
      frame_num: :frame_num,
      first_roll: 7,
      second_roll: nil
    },
    strike?: false,
    second_play: frame_with_two_rolls
  }