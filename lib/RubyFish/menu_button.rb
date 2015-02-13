require "gosu"

class MenuButton
  def initialize window, button_image, x, y, size
    @window = window
    @button_image = button_image
    
    @x = x
    @y = y
    @size = size
  end 

  def marked? x, y
    (@x - x) * (@x - x) + (@y - y) * (@y - y) <= @button_image.width / 2 * @button_image.width / 2
  end

  def clicked? x, y
    (marked? x, y) && (@window.button_down? Gosu::MsLeft)
  end

  def update
    
  end

  def draw 
    if marked? @window.mouse_x, @window.mouse_y
      @button_image.draw_rot @x, @y, 1, 0, 0.5, 0.5, 1.5 * @size, 1.5 * @size
    else
      @button_image.draw_rot @x, @y, 1, 0, 0.5, 0.5, @size, @size
    end
  end
end