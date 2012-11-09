class Map

  def initialize
    @all = []
  end

  def << what
    @all << what
    what.board = self
  end

  def all *filters
    if filters.any?
      result = @all
      filters.each do |filter|
        result = Filter[filter].apply result
      end
      return result
    else
      @all
    end
  end

  def [] *a
    all *a
  end

  def delete object
    @all.delete object
  end

  def normalize
    self[Wall].each do |wall|
      wall.siblings.select{|x|Food===x}.each do |odd|
        delete odd
      end
    end
    nil
  end

  def self.blank width, height
    max_x = width+1
    max_y = height+1
    (0..max_x).each_with_object(new) do |x,map|
      (0..max_y).each do |y|
        if x == 0 || x == max_x || y == 0 || y == max_y
          map << Wall.new.at(x,y)
        else
          map << Food.new.at(x,y)
        end
      end
    end
  end

  def self.random width, height
    maze = Labyrinth[width, height]

    (1..maze.width).each_with_object(blank(width,height)) do |x,map|
      (1..maze.height).each do |y|
        map << Wall.new.at(x,y) if maze[x,y] && map.all([x,y],Wall).empty?
      end
    end
  end


  class Filter
    attr_reader :pattern

    def initialize pattern
      @pattern = pattern
    end
    def self.[] pattern
      new pattern
    end

    def apply data
      if pattern.is_a? Class
        data.select { |x| pattern === x }

      elsif pattern.is_a? Array
        data.select { |x| pattern[0] === x.at[0] && pattern[1] === x.at[1] }
      end
    end
  end

end