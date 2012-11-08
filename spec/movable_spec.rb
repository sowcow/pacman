require 'spec_helper'

describe Movable do
  
  describe '#at' do
    it 'takes 2 coordinates or array, used as setter and getter' do
      ghost.at(1,2).at.should == [1,2]
      ghost.at([2,3]).at.should == [2,3]
    end

    it 'can be used to set coordinates only once per object' do
      expect { ghost.at(1,2).at(1,2) }.to raise_error
      expect { ghost.at(1,2).at(2,3) }.to raise_error
    end    
  end

  describe '#board=' do
    it 'can not be assigned twice' do
      one = ghost
      one.board = 'some'
      expect { one.board = 'some' }.to raise_error
    end
  end
end