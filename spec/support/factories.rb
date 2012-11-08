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