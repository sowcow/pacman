# encoding: utf-8
require 'theseus'

class Labyrinth
  attr_reader :maze

  def initialize options={width: 10}  
    @maze = Theseus::OrthogonalMaze.generate options
    @walls = extract_walls
  end

  def self.[] width=nil, height=nil, options={}
    new({width: width, height: height}.merge(options))
  end

  def [] *point
    @walls.include? point.flatten
  end

  def width
    @walls.max { |x| x[0] }[0] + 1
  end

  def height
    @walls.max { |x| x[1] }[1] + 1
  end

  def to_s(wall='▒', free=' ')
    height.times.map do |y|
      width.times.map do |x|
        self[x,y] ? wall : free
      end.join
    end.join "\n"
  end

  def scaled(by_x, by_y)
    scale(to_s, by_x, by_y)
  end

  private  

  def scale text, by_x, by_y
    text.lines.map do |line|
      [ line.chomp.chars.map { |c| c * by_x }.join ] * by_y
    end.join "\n"
  end

  def extract_walls
    require 'set'
    walls = Set[]

    maze.height.times do |y|
      maze.row_length(y).times.map do |x|
        here = maze[x,y]
        dx = x*2 + 1
        dy = y*2 + 1
        walls << [dx-1,dy-1] if nw(here)
        walls << [dx,  dy-1] if n(here)
        walls << [dx+1,dy-1] if ne(here)
        walls << [dx-1,  dy] if w(here)
        walls << [dx+1,  dy] if e(here)
        walls << [dx-1,dy+1] if sw(here)
        walls << [dx,  dy+1] if s(here)
        walls << [dx+1,dy+1] if se(here)
      end
    end

    walls
  end

  def nw there, wall=Theseus::Maze::NW
    wall & there == 0
  end
  def n there, wall=Theseus::Maze::N
    wall & there == 0
  end
  def w there, wall=Theseus::Maze::W
    wall & there == 0
  end
  def e there, wall=Theseus::Maze::E
    wall & there == 0
  end
  def ne there, wall=Theseus::Maze::NE
    wall & there == 0
  end
  def s there, wall=Theseus::Maze::S
    wall & there == 0
  end
  def se there, wall=Theseus::Maze::SE
    wall & there == 0
  end
  def sw there, wall=Theseus::Maze::SW
    wall & there == 0
  end

end


if __FILE__ == $0
  width = 15
  braid = 100
  options = {entrance: [1,1], exit: [1,1], random: 100}
  # options = {weave: 100} 
  # options = {symmetry: :radial, height: width} 
  # options = {randomness: 100, wrap: :xy} 

  maze = Labyrinth.new({width: width, height: (width*2/3).to_i, braid: braid}.merge(options))

  #, maze.scaled(3,2)
  puts [ maze.maze.to(:ascii, mode: :unicode), maze, maze.scaled(2,1) ] * ("\n" * 3)
end