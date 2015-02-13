require "gosu"
require_relative 'jellyfish'
require_relative 'green'

class Player
  attr_accessor :x, :y, :size, :width, :height

  def initialize window
    @window = window
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

  def normal_move 
    go_left if @window.button_down? Gosu::KbLeft
    go_right if @window.button_down? Gosu::KbRight
    go_up if @window.button_down? Gosu::KbUp
    go_down if @window.button_down? Gosu::KbDown 
  end

  def stinged_move
    go_right if @window.button_down? Gosu::KbLeft
    go_left if @window.button_down? Gosu::KbRight
    go_down if @window.button_down? Gosu::KbUp
    go_up if @window.button_down? Gosu::KbDown 
    @stingedFor -= 1
  end

  def move 
    if @stingedFor == 0
      normal_move
    else
      stinged_move
    end
    stay_inside
  end

  def within_range? something
    case something
    when Jellyfish then
      (@x - something.x).abs < @width * @size / 2 + something.width / 2 and 
      (@y - something.y).abs < @height * @size / 2 + something.height / 2
    when GreenFish then 
      (@x - something.x).abs < @width * @size / 2 + something.width * something.size / 2 and 
      (@y - something.y).abs < 0.7 * (@height * @size / 2 + something.height * something.size / 2)
    end
  end

  def smaller_than? fish
    if @growth == :baby
      fish.size > size * 0.6
    else 
      fish.size > size * 1.7
    end 
  end

  def eat fish
    if fish.instance_of? GreenFish and within_range? fish and not smaller_than? fish
      @score += 1
      grow
      fish.eaten
    end
  end

  def eaten_by? fish
    fish.instance_of? GreenFish and within_range? fish and smaller_than? fish
  end

  def stinged_by jellyfish
    if jellyfish.instance_of? Jellyfish and within_range? jellyfish
      @stingedFor = 300
    end
  end

  def interact_with_fish fish
    if eaten_by? fish
      @alive = false
    else
      eat fish
    end
  end

  def new_life
    @alive = true
  end

  def update
    if @alive
      move
    end
  end

  def to_draw
    if @alive
      if @lookLeft
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, -@size, @size)
      else
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, @size, @size)
      end
      @font.draw("#{@score} eaten", 890, 10, 1)

      case @stingedFor 
      when (240..300)
        @font.draw("5", 400, 350, 1)
      when (180..239)
        @font.draw("4", 400, 350, 1)
      when (120..179)
        @font.draw("3", 400, 350, 1)
      when (60..111)
        @font.draw("2", 400, 350, 1)
      when (2..59)
        @font.draw("1", 400, 350, 1)
      when 1
        @font.draw("0", 400, 350, 1)
      end

    else
      @font.draw("You ate #{@score} fish and then you were eaten.", 300, 350, 1)
    end
  end

  def draw
    to_draw
  end
end