class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.get_similar_movies(dirName)
    if !dirName.nil? or dirName != ""
      find_all_by_director(dirName)
    end
  end
end
