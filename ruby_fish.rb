require "gosu"

class GameWindow < Gosu::Window
  def initialize 
    super width = 960, height = 720, false
    self.caption = "Ruby Fish Game"

    @background_image = Gosu::Image.new(self, "media/underwater-background.jpg", true)
    @player = Player.new self
  end

  def update
    @player.goBack if button_down? Gosu::KbLeft
    @player.goStraight if button_down? Gosu::KbRight
    @player.goUp if button_down? Gosu::KbUp
    @player.goDown if button_down? Gosu::KbDown 

    close if button_down? Gosu::KbEscape

    @player.stayInside
  end

  def draw 
    @background_image.draw(0, 0, 0)
    @player.draw
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
  end

  def goStraight
    @lookLeft = false
    @x += 1
    @angle -= 0.52 if @angle > 0
    @angle += 0.52 if @angle < 0 
  end

  def goUp
    @y -= 0.5
    if !@lookLeft and @angle > -87 and @angle <= 90 
      @angle -= 0.5
    end
    if @lookLeft and @angle >= -90  and @angle < 87
      @angle += 0.5
    end
  end

  def goDown
    @y += 0.5
    if !@lookLeft and @angle >= -90 and @angle < 87 
      @angle += 0.5
    end
    if @lookLeft and @angle > -87 and @angle <= 90
      @angle -= 0.5
    end
  end

  def goBack
    @lookLeft = true
    @x -= 1
    @angle -= 0.52 if @angle > 0
    @angle += 0.52 if @angle < 0 
  end

  def stayInside
    @x %= @window.width
    @y %= @window.height
  end

  def toDraw
    if !@lookLeft
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.2, 0.2)
    end
    if @lookLeft
      @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, -0.2, 0.2)
    end
  end

  def draw
    toDraw
  end
end

GameWindow.new.show