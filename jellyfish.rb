require "gosu"

class Jellyfish
  attr_reader :x, :y, :width, :height

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

  def move 
    @x += 1
    @y -= 0.5
    @x %= @window.width
    @y %= @window.height
  end

  def set_frame
    if @nextFrame < 4
      @nextFrame += 1
    elsif @nextFrame == 4
      @nextFrame = 0
      @frame += 1
    end

    @frame %= 20 
  end

  def update
    move
    set_frame
  end

  def draw
    @image[@frame].draw_rot @x, @y, 1, 0
  end
end