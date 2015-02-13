require "gosu"
require_relative 'player'
require_relative 'green'
require_relative 'jellyfish'

class GameWindow < Gosu::Window
  def initialize 
    super width = 960, height = 720, false
    self.caption = "Ruby Fish Game"

    @background_image = Gosu::Image.new(self, "media/underwater-background.jpg", true)
    @jellyfish = Jellyfish.new self
    @player = Player.new self, @jellyfish
    @green_fish_array = Array.new(10) { |i| GreenFish.new self, @player }
  end

  def update
    @jellyfish.update
    @green_fish_array.each { |fish| @player.interact_with_fish fish }
    @green_fish_array.each { |fish| fish.update }
    @player.update @jellyfish

    close if button_down? Gosu::KbEscape
  end

  def draw 
    @background_image.draw(0, 0, 0)
    @player.draw
    @green_fish_array.each { |fish| fish.draw }
    @jellyfish.draw
  end
end

GameWindow.new.show