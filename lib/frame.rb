class Frame

  attr_reader :pins_standing, :log

  def initialize(frame_num)
    @pins_standing = 10
    @log  = { frame_num: frame_num, first_roll: nil, second_roll: nil, bonus: nil, score: nil}
  end

  def roll
    puts "Roll... how many did you knock down?"
    knocked_down = $stdin.gets.chomp.to_i
    raise "Cannot knock down more pins than are standing" if knocked_down > @pins_standing
    @pins_standing = @pins_standing - knocked_down
    knocked_down
  end

  def first_play
    first_roll = self.roll
    self.update_log(:first_roll, first_roll)
    self
  end

  def second_play
    second_roll = self.roll
    self.update_log(:second_roll, second_roll)
    self
  end

  def update_log(key, result)
    @log[key] = result
    log_score_and_bonuses(key, result)
  end

  private

  def log_score_and_bonuses(key, result)
    if key == :first_roll && result == 10
      @log[:bonus] = :strike
    elsif key == :second_roll
      if result + @log[:first_roll] == 10
        @log[:bonus] = :spare
      else
        @log[:score] = @log[:first_roll] + @log[:second_roll]
      end
    end
  end

end