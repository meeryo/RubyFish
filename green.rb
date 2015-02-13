require "gosu"
require_relative 'player'

class GreenFish
  attr_reader :x, :y, :height, :width, :size

  def initialize window, player
    @window = window
    @width = 256
    @height = 256
    @image = Gosu::Image.load_tiles @window, "media/green.png",
                                    @width, @height, true
    @player = player
    set_new_fish
  end

  def set_new_fish
    random = Random.new
    @size = random.rand(0.1..0.9)

    random = Random.new
    @velosity = random.rand(1..4)

    random = Random.new
    number = random.rand(0..1)
    if number == 0
      @x = 0 - @width * @size 
      @direction = :right
      #the fish apperars from left
    else
      @x = @window.width + @width * @size
      @direction = :left
      #the fish apperars from right
    end

    random = Random.new
    @y = random.rand(@window.height - @height * @size)

    @frame = 0
    @nextFrame = 0
  end

  def move
    case @direction
    when :right   then @x += @velosity
    when :left    then @x -= @velosity
    end
  end

  def set_frame
    change_interval = 5 #10 - @velosity

    if @nextFrame == change_interval
      @frame += 1
      @nextFrame = 0
    else
      @nextFrame += 1
    end
  end

  def draw_fish
    r = @frame % 6 + 12
    l = @frame % 6 + 18
    image = @image
    case @direction
    when :right  then image = @image[r]
    when :left   then image = @image[l]
    end

    image.draw_rot @x, @y, 1, 0, 0.5, 0.5, @size, @size
  end

  def eaten
    set_new_fish
  end

  def substitude_the_fish
    if @x >= @window.width + @width * @size or @x <= 0 - @width * @size
      set_new_fish
    end
  end

  def update 
    set_frame
    move
    substitude_the_fish
  end

  def draw
    draw_fish
  end
end