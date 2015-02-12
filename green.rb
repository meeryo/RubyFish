require "gosu"
require_relative 'player'

class GreenFish

  def initialize window, player
    @window = window
    @width = 256
    @height = 256
    @image = Gosu::Image.load_tiles @window, "media/green.png",
                                    @width, @height, true
    @player = player
    setNewFish
  end

  def setNewFish
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

  def setFrame
    change_interval = 5 #10 - @velosity

    if @nextFrame == change_interval
      @frame += 1
      @nextFrame = 0
    else
      @nextFrame += 1
    end
  end

  def drawFish
    r = @frame % 6 + 12
    l = @frame % 6 + 18
    image = @image
    case @direction
    when :right  then image = @image[r]
    when :left   then image = @image[l]
    end

    image.draw_rot @x, @y, 1, 0, 0.5, 0.5, @size, @size
  end

  def substitudeTheFish
    if @x >= @window.width + @width * @size or @x <= 0 - @width * @size
      setNewFish
    end
  end

  def within_range?
    (@x - @player.x).abs < @width * @size / 2 + @player.width * @player.size / 2 and 
    (@y - @player.y).abs < 0.7 * (@height * @size / 2 + @player.height * @player.size / 2)
  end

  def smaller?
    if @player.growth == :baby
      @size < @player.size * 0.6
    else 
      @size < @player.size * 1.7
    end
  end

  def eat?
    within_range? && (not smaller?)
  end

  def eaten?
    within_range? && smaller?
  end

  def eatOrBeEaten
    if eaten?
      @player.eat
      setNewFish
    end

    if eat?
      @player.dies
    end
  end

  def update 
    setFrame
    eatOrBeEaten
    move
    substitudeTheFish
  end

  def draw
    drawFish
  end
end