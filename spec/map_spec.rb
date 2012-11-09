require 'spec_helper'

describe Map do
  subject { Map.new }

  describe '#<<' do
    it 'remember given object' do
      subject << ghost.at(0,0)
      subject.all.should have(1).object
    end
    it 'sets object.board' do
      one = ghost.at(0,0)
      one.board.should be_nil
      subject << one
      one.board.should == subject
    end    
  end

  describe '#[]' do
    let(:map){ board }
    let(:all){ '1,2,3' }

    specify 'alias to #all' do
      map.should_receive(:all).once { all }
      map[].should == all
    end
  end
  describe '#all' do
    before do
      subject << ghost.at(0,0)
      subject << ghost.at(0,1)
      subject << food.at(0,1)
      subject << food.at(0,1)
      subject << food.at(2,2)
    end

    it 'returns all objects given by <<' do
      subject.all.should have(5).objects
    end

    describe 'applies filter if given' do
      specify 'empty filter' do
        subject.all(Ghost).should have(2).objects #########
        subject.all(Food).should have(3).objects
      end      
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
      specify 'combined filters' do
        subject.all(Ghost, [0,0]).should have(1).objects
        subject.all(Ghost, [1,1]).should have(0).objects
      end
    end

  end

  describe '.blank' do
    it 'generates walled map with rectangle area of given size filled with food' do
      game = Map.blank(2,1)
      game.all.should =~ game.all(Wall) + game.all(Food)
      game.all(Wall).map(&:at).should =~ [[0,0],[0,1],[0,2],[1,2],[2,2],[3,2],[3,1],[3,0],[2,0],[1,0]]
      game.all(Food).map(&:at).should =~ [[1,1],[2,1]]
    end
  end

  describe '.random' do
    it 'generates random map' do
      Labyrinth.should_receive(:[]).once { Labyrinth.new width:5 }
      Map.random 5,5
    end
    specify 'on top of blank map' do
      Map.should_receive(:blank).once { mock(all: mock(empty?: false)) }
      Map.random 5,5
    end    
    specify 'so it has more walls than blank map' do
      Map.random(5,5)[Wall].count.should > Map.blank(5,5)[Wall].count
    end
  end

  describe '#delete' do
    it 'deletes object from map' do
      subject << food.at(5,5)
      subject[Food].should have(1).elements
      subject.delete(subject[Food].first)
      subject[Food].should have(0).elements
    end
  end  

  describe '#normalize' do
    before do
      subject << food.at(5,5)
      subject << food.at(5,5)
      subject << food.at(4,4)
      subject << food.at(4,4)
      
      subject << food.at(3,3)

      subject << wall.at(5,5)
      subject << wall.at(4,4)
    end

    it 'removes food that is situated under the wall' do
      subject.normalize
      subject[Food].should have(1).item
    end
    # it 'removes unreachable food' do
    #   pending
    # end
  end

end