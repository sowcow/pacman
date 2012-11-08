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