class Map

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
end