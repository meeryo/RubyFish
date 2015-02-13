require "gosu"

class Menu
  def initialize window
    @window = window
    @startImage = Gosu::Image.new(@window, "media/start_button.png", false)
    @bubble = Gosu::Image.new(@window, "media/bubble.png", false)
    @x = 450
    @y = 150
    @size = 0.5
  end 

  def marked? x, y
    (@x - x) * (@x - x) + (@y - y) * (@y - y) <= @startImage.width / 2 * @startImage.width / 2
  end

  def clicked? x, y
    (marked? x, y) && (@window.button_down? Gosu::MsLeft)
  end

  def update
    
  end

  def draw
    @bubble.draw_rot @window.mouse_x, @window.mouse_y, 1, 0, 0.5, 0.5, 0.2, 0.2

    if marked? @window.mouse_x, @window.mouse_y
      @startImage.draw_rot @x, @y, 1, 0, 0.5, 0.5, 1.5 * @size, 1.5 * @size
    else
      @startImage.draw_rot @x, @y, 1, 0, 0.5, 0.5, @size, @size
    end

    @bubble.draw_rot 500, 250, 1, 0, 0.5, 0.5, 0.5, 0.5
    @bubble.draw_rot 550, 350, 1, 0, 0.5, 0.5, 0.3, 0.3
    @bubble.draw_rot 470, 400, 1, 0, 0.5, 0.5, 0.5, 0.5
    @bubble.draw_rot 440, 350, 1, 0, 0.5, 0.5, 0.2, 0.2
    @bubble.draw_rot 500, 500, 1, 0, 0.5, 0.5, 0.2, 0.2
  end
end