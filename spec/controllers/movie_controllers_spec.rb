require 'spec_helper'    

describe MoviesController do
  describe 'find movie with same director' do
    before :each do
      @fake_results = [mock('Movie'), mock('Movie')]
      
    end
    it 'should call the model method that finds all movies with the same director' do
      Movie.stub(:find_by_id).and_return(mock('Movie', :director => 'MovieDirector'))
      Movie.should_receive(:get_similar_movies).with('MovieDirector').and_return(@fake_results)
      get :similar_movies, {:id => '0'}
    end
    
    describe 'there was a director and movies are returned' do  
      before :each do
        Movie.stub(:find_by_id).and_return(mock('Movie', :director => 'MovieDirector'))
        Movie.stub(:get_similar_movies).and_return(@fake_results)
        get :similar_movies, {:id => '0'}
      end
      
      it 'should select the Similar Movies template for rendering' do
        response.should render_template('similar_movies')
      end
    
     it 'should make the same director movie results available to the template' do
        assigns(:movies).should == @fake_results
      end
    end
    
    describe 'director was null and movies cannot be returned' do
      before :each do
        Movie.stub(:find_by_id).and_return(mock('Movie', :director => nil, :title => 'Alien'))
        Movie.stub(:get_similar_movies).and_return(nil)
        get :similar_movies, {:id => '0'}
      end
      
      it 'should have director as nil so we know the if statement goes to this case' do
        assigns(:dir).should == nil
      end
      
      it 'should not select the Similar Movies template but rather redirect to the HomePage' do
        response.should redirect_to movies_path
      end
      
      it 'should produce a flash message stating a warning that no director was available' do
        flash[:notice].should == "'Alien' has no director info"
      end 
    end
  end
end
