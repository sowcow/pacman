module Placeable
  CANT_PLACE = "can't place object twice"

  # setter/getter, set once
  def at *given
    point = given.flatten

    raise CANT_PLACE if @point && point.any?
    
    if point.any?
      @point = point
      self
    else
      @point
    end
  end
end

class Map
  def initialize
    @all = []
  end

  def << what
    @all << what
  end

  def all filter=nil
    if filter
      if filter.is_a? Class
        @all.select { |x| filter === x }

      elsif filter.is_a? Array
        @all.select { |x| filter[0] === x.at[0] && filter[1] === x.at[1] }
      end
    else
      @all
    end
  end
end