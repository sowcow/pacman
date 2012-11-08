require 'spec_helper'

class Ghost < Struct.new :scared_time
  include Placeable
end
def ghost
  Ghost[0]
end

class Food
  include Placeable
end
def food
  Food.new
end

describe Placeable do
  describe '#at' do
    it 'takes 2 coordinates or array, used as setter and getter' do
      ghost.at(1,2).at.should == [1,2]
      ghost.at([2,3]).at.should == [2,3]
    end

    it 'cant place twice' do
      expect { ghost.at(1,2).at(1,2) }.to raise_error
      expect { ghost.at(1,2).at(2,3) }.to raise_error
    end    
  end
end

describe Map do
  subject { Map.new }

  describe '#all' do
    before do
      subject << ghost.at(0,0)
      subject << ghost.at(0,1)
      subject << food.at(0,1)
      subject << food.at(0,1)
      subject << food.at(2,2)
    end

    it 'has all objects given by <<' do
      subject.all.should have(5).objects
    end

    describe 'applies filter if given' do
      specify 'class filter' do
        subject.all(Ghost).should have(2).objects
        subject.all(Food).should have(3).objects
      end
      specify 'position filter' do
        subject.all([0,1]).should have(3).objects
        subject.all([0,0]).should have(1).object
        subject.all([10,10]).should have(0).objects
      end    
      specify 'range filter' do
        subject.all([0..1,0..1]).should have(4).objects
        subject.all([0..1,0]).should have(1).objects
        subject.all([0,1..1]).should have(3).objects
        subject.all([1..2,0..2]).should have(1).objects
      end          
    end

  end

end