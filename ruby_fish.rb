require "gosu"

class GameWindow < Gosu::Window
  def initialize 
    super width = 960, height = 720, false
    self.caption = "Ruby Fish Game"

    @background_image = Gosu::Image.new(self, "media/underwater-background.jpg", true)
    @player = Player.new self
    @green_fish_array = Array.new(10) { |i| Green.new self, @player }
    @jellyfish = Jellyfish.new self
  end

  def update
    @player.goLeft if button_down? Gosu::KbLeft
    @player.goRight if button_down? Gosu::KbRight
    @player.goUp if button_down? Gosu::KbUp
    @player.goDown if button_down? Gosu::KbDown 

    close if button_down? Gosu::KbEscape

    @player.stayInside
    @green_fish_array.each { |fish| fish.update }
    @jellyfish.update
  end

  def draw 
    @background_image.draw(0, 0, 0)
    @player.draw
    @green_fish_array.each { |fish| fish.draw }
    @jellyfish.draw
  end
end

class Player
  def initialize window
    @window = window
    @image = Gosu::Image.new(@window, "media/Ruby-Fish-Adult.png", false)
    @x = @window.width / 2
    @y = @window.height / 2
    @angle = 0
    @lookLeft = false
    @size = 0.12
    @velosity = 4

    @score = 0
  end

  def x 
    @x
  end

  def y
    @y
  end

  def size
    @size
  end

  def ate
    @score += 1
    if @score % 5 == 0
      @size += 0.01
    end
  end

  def halfWidth
    @image.width * @size / 2
  end

  def halfHeight
    @image.height * @size / 5
  end

  def goRight
    @lookLeft = false
    @x += @velosity
    @angle -= 0.52 if @angle > 0
    @angle += 0.52 if @angle < 0 
  end

  def goUp
    @y -= @velosity
    if !@lookLeft and @angle > -87 and @angle <= 90 
      @angle -= 0.5
    end
    if @lookLeft and @angle >= -90  and @angle < 87
      @angle += 0.5
    end
  end

  def goDown
    @y += @velosity
    if !@lookLeft and @angle >= -90 and @angle < 87 
      @angle += 0.5
    end
    if @lookLeft and @angle > -87 and @angle <= 90
      @angle -= 0.5
    end
  end

  def goLeft
    @lookLeft = true
    @x -= @velosity
    @angle -= 0.52 if @angle > 0
    @angle += 0.52 if @angle < 0 
  end

  def stayInside
    @x %= @window.width
    @y %= @window.height
  end

  def toDraw
    if !@lookLeft
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, @size, @size)
    end
    if @lookLeft
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, -@size, @size)
    end
  end

  def draw
    toDraw
  end
end

class Green
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
    elsif number == 1
      @x = @window.width + @width * @size
      @direction = :left
      #the fish apperars from right
    end

    random = Random.new
    @y = random.rand(@window.height - @height * @size)

    @frame = 0
    @nextFrame = 0
  end

  def substitudeTheFish
    setNewFish if @x >= @window.width + @width * @size or @x <= 0 - @width * @size
  end

  def eaten
    if (@x - @player.x).abs < (@width - 10) * @size / 2 + @player.halfWidth and
       (@y - @player.y).abs < (@height - 40) * @size / 3 + @player.halfHeight and
       @size <= @player.size * 1.6
      @player.ate
      setNewFish  
    end  
  end

  def update 
    eaten
    howFast = 10 - @velosity
    @frame += 1 if @nextFrame == howFast
    if @nextFrame < howFast
      @nextFrame += 1
    elsif @nextFrame == howFast
      @nextFrame = 0
    end
        
    case @direction
      when :right   then @x += @velosity
      when :left    then @x -= @velosity
    end
    substitudeTheFish
  end

  def draw
    r = @frame % 6 + 12
    l = @frame % 6 + 18
    image = @image
    case @direction
      when :right  then image = @image[r]
      when :left   then image = @image[l]
    end
    image.draw_rot @x, @y, 1, 0, 0.5, 0.5, @size, @size
  end
end

class Jellyfish
  def initialize window
    @window = window
    @x = 400
    @y = 500
    @width = 115
    @height = 125
    @image = Gosu::Image.load_tiles @window, "media/jellyfish.png",
                                    @width, @height, true
    @frame = 0
    @nextFrame = 0                               
  end

  def update
    @x += 1
    @y -= 0.5
    @x %= @window.width
    @y %= @window.height

    @frame += 1 if @nextFrame == 4
    if @nextFrame < 4
      @nextFrame += 1
    elsif @nextFrame == 4
      @nextFrame = 0
    end
    @frame %= 20 

  end

  def draw
    @image[@frame].draw @x, @y, 1
  end
end
GameWindow.new.show