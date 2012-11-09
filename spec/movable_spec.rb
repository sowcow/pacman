require 'spec_helper'

describe Movable do

  let(:directions){ %w[ left right up down ].map &:to_sym }
  let(:one){ ghost }
  let(:game){ board }


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

  describe '#move' do
    it 'moves object one step in given direction' do
      one = ghost
      board << one.at(3,3)
      sequence = {left: [2,3], right: [3,3], up: [3,2], down: [3,3]}
      sequence.each do |direction,ok|
        one.move direction
        one.at.should == ok
      end
    end

    it 'fails unless can_move?' do
      game << one.at(3,3)
      game << wall.at(4,3)
      expect { one.move(:right) }.to raise_error
    end
  end

  describe '#can_move?' do
    it 'is false when the wall is on the path' do
      game << one.at(3,3)
      directions.count { |direction| one.can_move? direction }.should == 4
      game << wall.at(3,4)
      directions.count { |direction| one.can_move? direction }.should == 3
      game << wall.at(4,3)
      directions.count { |direction| one.can_move? direction }.should == 2
      game << wall.at(2,3)
      directions.count { |direction| one.can_move? direction }.should == 1      
      game << wall.at(3,2)
      directions.count { |direction| one.can_move? direction }.should == 0      
    end
  end

  describe '#siblings' do
    it 'returns all other objects in the same cell' do
      game << ghost.at(5,5)
      game << wall.at(5,5)
      game << food.at(5,5)

      game << ghost.at(4,4)
      game << food.at(4,4)

      game[[5,5], Ghost].first.siblings.should have(2).items
      game[[4,4], Ghost].first.siblings.should have(1).item
    end
  end
end