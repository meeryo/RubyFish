require "gosu"

class GameWindow < Gosu::Window
	def initialize 
		super width = 960, height = 720, false
		self.caption = "Ruby Fish Game"

		@background_image = Gosu::Image.new(self, "media/underwater-background.jpg", true)
	end

	def update
	end

	def draw 
		@background_image.draw(0, 0, 0)
	end
end

GameWindow.new.show