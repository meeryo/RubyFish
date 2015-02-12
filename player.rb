require "gosu"
require_relative 'jellyfish'

class Player
  attr_accessor :x, :y, :size, :width, :height, :growth

  def initialize window, jellyfish
    @window = window
    @jellyfish = jellyfish
    @image = Gosu::Image.new(@window, "media/Ruby-Fish-Baby.png", false)
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    @x = @window.width / 2
    @y = @window.height / 2

    @angle = 0
    @directon = :right
    @size = 0.4
    @velosity = 4
    @growth = :baby

    @width = @image.width * @size 
    @height = @image.height * @size

    @score = 0
    @alive = true
    @stingedFor = 0
  end

  def grow 
    if @score % 5 == 0
      @size += 0.1
    end

    if @score >= 10
      @size = 0.2
      @growth = :adult
      @image = Gosu::Image.new(@window, "media/Ruby-Fish-Adult.png", false)
    end

    # update collision dimentions
    @width = @image.width * @size 
    @height = @image.height * @size
  end

  def eat
    @score += 1
    grow
  end

  def dies
    @alive = false
  end

  def go_right
    @lookLeft = false
    @x += @velosity
    @angle -= 0.52 if @angle > 0
    @angle += 0.52 if @angle < 0 
  end

  def go_up
    @y -= @velosity
    if !@lookLeft and @angle > -45 and @angle <= 45 
      @angle -= 0.5
    end
    if @lookLeft and @angle >= -45  and @angle < 45
      @angle += 0.5
    end
  end

  def go_down
    @y += @velosity
    if !@lookLeft and @angle >= -45 and @angle < 45 
      @angle += 0.5
    end
    if @lookLeft and @angle > -45 and @angle <= 45
      @angle -= 0.5
    end
  end

  def go_left
    @lookLeft = true
    @x -= @velosity
    @angle -= 0.52 if @angle > 0
    @angle += 0.52 if @angle < 0 
  end

  def stay_inside
    @x %= @window.width
    @y %= @window.height
  end

  def move 
    go_left if @window.button_down? Gosu::KbLeft
    go_right if @window.button_down? Gosu::KbRight
    go_up if @window.button_down? Gosu::KbUp
    go_down if @window.button_down? Gosu::KbDown 
  end

  def jelly_within_range?
    (@x - @jellyfish.x).abs < @width * @size / 2 + @jellyfish.width / 2 and 
    (@y - @jellyfish.y).abs < @height * @size / 2 + @jellyfish.height / 2
  end

  def stinged
    if jelly_within_range?
      @stingedFor = 300
    end
  end

  def stinged_move
    go_right if @window.button_down? Gosu::KbLeft
    go_left if @window.button_down? Gosu::KbRight
    go_down if @window.button_down? Gosu::KbUp
    go_up if @window.button_down? Gosu::KbDown 
    @stingedFor -= 1
  end

  def update
    if @alive
      stinged
      if @stingedFor == 0
        move
      else
        stinged_move
     end
      stay_inside
    end
  end

  def to_draw
    if @alive
      if @lookLeft
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, -@size, @size)
      else
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, @size, @size)
      end
      @font.draw("#{@score} eaten", 900, 10, 1)
    else
      @font.draw("You ate #{@score} fishes and then you were eaten.", 300, 350, 1)
    end
  end

  def draw
    to_draw
  end
end