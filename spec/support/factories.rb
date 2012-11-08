class Ghost < Struct.new :scared_till
  include Movable
end
def ghost
  Ghost[0]
end

class Food
  include Movable
end
def food
  Food.new
end

def board
  Map.new
end

class Wall
  include Movable
end
def wall
  Wall.new
end