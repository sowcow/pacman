require 'spec_helper'

# TODO:
#   place(obj)
#   raise on duplicats?
#   include WithWalls / can_move?

describe Map do
  subject { Map.new 10,10 }

  it 'has width and height' do
    Map.new(10,20).width == 10
    Map.new(10,20).height == 20
  end
  it 'can be constructed using array' do
    Map.new([10,20]).width == 10
    Map.new([10,20]).height == 20
  end

  explain :valid?, %w[
    9,9   +
    0,0   +
    00,0  +
    0000  -
    0,0,0 -
    -1,0  -
    0,-1  -
    10,9  -
    9,10  -
  ].map_respectively( '[%s]',  'x == "+"' )

  it 'assigns values only to valid coordinates' do
    subject[0,0] = 1
    subject[0,0].should == 1

    subject[-1,-1] = 1
    subject[-1,-1].should be_nil
  end

  it 'assigns values only to empty positions' do
    subject[0,0] = 1
    subject[0,0].should == 1
    expect { subject[0,0] = 1 }.to raise_error
  end

  describe '#find' do
    it 'finds given object or raise error' do
      subject[0,1] = :a
      subject[0,2] = :b
      subject.find(:a).should == [0,1]
      subject.find(:b).should == [0,2]
      expect { subject.find(3) }.to raise_error
    end
  end

  describe '#delete' do
    it 'deletes given object' do
      subject[0,1] = 1
      subject[0,2] = 2

      subject.find(1).should_not be_nil
      subject.delete(1)
      expect { subject.find(1) }.to raise_error

      subject.find(2).should_not be_nil
      subject.delete(2)
      expect { subject.find(2) }.to raise_error
    end
  end  

  describe '#move' do
    let(:object){ Object.new }
    let(:x){5}
    let(:y){5}
    let(:delta){ [ [1,1], [0,1], [1,0], [-1,-1], [-1,0], [1,-1] ].sample }
    before do
      subject[x,y] = object
    end

    it 'moves given object by delta' do
      subject.move(object, delta)
      subject.find(object).should == [x + delta[0], y + delta[1]]
    end

    # it 'raises if target position is busy' do
    #   obj1 = Object.new
    #   obj2 = Object.new
    #   subject[0,0] = obj1
    #   subject[1,1] = obj2
    #   expect { subject.move(obj1, [1,1]) }.to raise_error
    #   expect { subject.move(obj2, [-2,0]) }.to raise_error
    # end
  end

  describe '#positions' do
    before do
      stub_const 'Fruit', Class.new
      stub_const 'Apple', Class.new(Fruit)
      stub_const 'Orange', Class.new(Fruit)
      stub_const 'Other', Class.new

      subject[0,0] = Other.new
      subject[1,1] = Other.new
      subject[3,2] = Other.new

      subject[4,0] = Fruit.new
      subject[4,4] = Fruit.new
      subject[1,4] = Apple.new
      subject[3,4] = Apple.new
      subject[4,2] = Orange.new
    end

    it 'returns positions of appropriate values' do
      subject.positions(Orange).should == [[4,2]]
      subject.positions(Orange).count.should == 1
      subject.positions(Apple).count.should == 2
      subject.positions(Fruit).count.should == 5
      subject.positions(Other).count.should == 3
    end

    it 'is aliased as #coordinates' do
      [Orange,Apple,Fruit,Other].each { |kind| subject.coordinates(kind).should == subject.positions(kind) }
    end
  end
end
























__END__
class Walls < Array
  def random
  end

  def initialize
    replace []
  end
end

class Map < Array
  def self.random width, height, wall_percent=.1
    new.instance_eval do
      @walls = Walls.random width * height * wall_percent
      self
    end
  end

  def initialize width, height
    one = Array.new()
    replace []
  end
end

class Game
  def initialize map
    @map = map
  end
end

describe Game do

  explain :x2, [1,2,  2,4,  3,6,  10,20]
end
