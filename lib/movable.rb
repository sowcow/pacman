module Movable
  attr_reader :board
  CANT_PLACE = "can't place object twice" # place on board or place on cell (...)

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
end