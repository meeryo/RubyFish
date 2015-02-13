require "gosu"
require 'RubyFish/player'
require 'RubyFish/green'
require 'RubyFish/jellyfish'
require 'RubyFish/menu'

class GameWindow < Gosu::Window
  def initialize 
    super width = 960, height = 720, false
    self.caption = "Ruby Fish Game"
    @mode = :menu

    @background_image = Gosu::Image.new self, File.dirname(__FILE__) + 
                                              "/media/underwater-background.jpg", 
                                              true

    @menu_screan = Menu.new self
    @jellyfish = Jellyfish.new self
    @player = Player.new self
    @green_fish_array = Array.new(10) { |i| GreenFish.new self }
  end

  def start_new_game
    @player = Player.new self
    @green_fish_array.each { |fish| fish.set_new_fish }
  end

  def play
    @jellyfish.update
    @green_fish_array.each { |fish| @player.interact_with_fish fish }
    @green_fish_array.each { |fish| fish.update }
    @player.stinged_by @jellyfish
    @player.update 

    if @mode == :play and button_down? Gosu::KbP
      @mode = :menu 
    end

    if @mode == :play and button_down? Gosu::KbEscape
      @mode = :menu
      start_new_game 
    end
  end

  def update
    @menu_screan if @mode == :menu
    @mode = :play if @menu_screan.start? mouse_x, mouse_y
    play if @mode == :play
    close if @menu_screan.exit? mouse_x, mouse_y
  end

  def draw 
    @background_image.draw(0, 0, 0)
    case @mode 
    when :play
      @player.draw
      @green_fish_array.each { |fish| fish.draw }
      @jellyfish.draw
    when :menu
      @menu_screan.draw
    end
  end
end

GameWindow.new.show