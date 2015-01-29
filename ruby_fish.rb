require "gosu"

class GameWindow < Gosu::Window
  def initialize 
    super width = 960, height = 720, false
    self.caption = "Ruby Fish Game"

    @background_image = Gosu::Image.new(self, "media/underwater-background.jpg", true)
    @player = Player.new self
    @green_fish = Green.new self
  end

  def update
    @player.goLeft if button_down? Gosu::KbLeft
    @player.goRight if button_down? Gosu::KbRight
    @player.goUp if button_down? Gosu::KbUp
    @player.goDown if button_down? Gosu::KbDown 

    close if button_down? Gosu::KbEscape

    @player.stayInside
    @green_fish.update
  end

  def draw 
    @background_image.draw(0, 0, 0)
    @player.draw
    @green_fish.draw
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
    @size = 0.2
    @velosity = 4
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
  def initialize(window)
    @window = window
    @width = 256
    @height = 256
    @image = Gosu::Image.load_tiles @window, "media/green.png", 
                                    @width, @height, true
    @x = 0
    @y = 0
    @nextFrame = 0
    @size = 0.6
    @direction = :right
    @frame = 0
  end

  def update
    @frame += 1 if @nextFrame == 5
    if @nextFrame < 5
      @nextFrame += 1
    elsif @nextFrame == 5
      @nextFrame = 0
    end
        
    case @direction
      when :right   then @x += 3
      when :left    then @x -= 3
    end

    @direction = :left if @x >= (@window.width - @width * @size) 
    @direction = :right if @x <= 0
  end

  def draw
    r = @frame % 6 + 12
    l = @frame % 6 + 18
    image = @image
    case @direction
      when :right  then image = @image[r]
      when :left   then image = @image[l]
    end
    image.draw @x, @y, 1, @size, @size
  end
end

GameWindow.new.show