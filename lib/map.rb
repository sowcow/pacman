class Map
  def initialize
    @all = []
  end

  def << what
    @all << what
    what.board = self
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