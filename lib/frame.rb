class Frame

  def self.new_play(frame_num)
    frame = Frame.new(frame_num)
    first_roll = frame.roll
    frame.update_score(:first_roll, first_roll)
    frame
  end

  attr_reader :pins_standing, :log

  def initialize(frame_num)
    @pins_standing = 10
    @log  = { frame_num: frame_num, first_roll: nil, second_roll: nil}
  end

  def second_play
    second_roll = self.roll
    self.update_score(:second_roll, second_roll)
    self
  end


  def roll
    puts "Roll... how many did you knock down?"
    knocked_down = $stdin.gets.chomp.to_i
    raise "Cannot knock down more pins than are standing" if knocked_down > @pins_standing
    @pins_standing = @pins_standing - knocked_down
    knocked_down
  end

  def update_score(key, result)
    @log[key] = result
  end

  def strike?
    @log[:first_roll] == 10
  end

end