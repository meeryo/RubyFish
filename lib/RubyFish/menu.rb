require "gosu"
require 'RubyFish/menu_button'

class Menu 
  def initialize window
    @window = window
    p File.dirname(__FILE__) + "/media/start_button.png"
    image_start = Gosu::Image.new @window, File.dirname(__FILE__) + "/media/start_button.png", false
    image_exit = Gosu::Image.new @window, File.dirname(__FILE__) +
                                          "/media/exit_button.png",
                                          false
    @bubble = Gosu::Image.new @window, File.dirname(__FILE__) +
                                        "/media/bubble.png",
                                        false
    
    @start_button = MenuButton.new @window, image_start, 450, 150, 0.5
    @exit_button = MenuButton.new @window, image_exit, 520, 480, 0.2
  end

  def start? x, y
    @start_button.clicked? x, y
  end

  def exit? x, y
    @exit_button.clicked? x, y
  end

  def update
  end

  def draw
    @bubble.draw_rot @window.mouse_x, @window.mouse_y, 1, 0, 0.5, 0.5, 0.2, 0.2
    @start_button.draw 
    @exit_button.draw


    @bubble.draw_rot 500, 250, 1, 0, 0.5, 0.5, 0.5, 0.5
    @bubble.draw_rot 550, 350, 1, 0, 0.5, 0.5, 0.3, 0.3
    @bubble.draw_rot 470, 400, 1, 0, 0.5, 0.5, 0.5, 0.5
    @bubble.draw_rot 440, 350, 1, 0, 0.5, 0.5, 0.2, 0.2
    @bubble.draw_rot 500, 500, 1, 0, 0.5, 0.5, 0.2, 0.2
  end
end