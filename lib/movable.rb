module Movable
  attr_reader :board
  CANT_PLACE = "can't place object twice" # place on board or place on cell (...)
  CANT_MOVE  = "can't move in that direction"

  # setter/getter, set once
  def at *given
    point = given.flatten(1)

    raise CANT_PLACE if @point && point.any?

    if point.any?
      @point = point
      self
    else
      @point
    end
  end

  def board= given
    raise CANT_PLACE if @board
    @board = given
  end

  DIERCTIONS = {left: [-1,0], right: [+1,0], up: [0,-1], down: [0,+1]}

  def move direction
    raise CANT_MOVE unless can_move? direction
    @point = target direction
  end

  def can_move? direction
    @board.all(target(direction), Wall).none?
  end

  def siblings
    @board[@point] - [self]
  end

  private
  def target direction
    @point.zip(DIERCTIONS[direction]).map { |x,y| x + y }
  end
end