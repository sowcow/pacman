class Map
  attr_reader :width, :height
  BUSY = 'Can''t overwrite busy point'

  def initialize width, height=nil
    width, height = *width if width.is_a? Array
    
    @width, @height = width, height
    @map = {}
  end

  def [] *point
    @map[point]
  end

  def []= *point, value
    raise BUSY if @map[point]
    @map[point] = value if valid? point
  end

  def positions pattern
    @map.select { |k,v| pattern === v }.map { |k,v| k }
  end
  alias coordinates positions

  def find who
    @map.find { |k,v| v == who }[0]
  end

  def delete who
    @map.delete find(who)
  end

  def move who, delta
    old = find(who)
    new = old.zip(delta).map{|a,b| a+b}
    
    delete who
    self[*new] = who
  end

  private
  def valid? point
    point.size == 2 &&
    (0...@width).include?(point[0]) &&
    (0...@height).include?(point[1])
  end
end




























__END__
  def check x, y

  end

  def valid?
    any? { |element| wrong? element }
  end
  
  protected
  def wrong? element
    return true unless (0...width).include? element.x
    return true unless (0...height).include? element.y
    false # all is ok
  end
end