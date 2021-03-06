class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] 
    @movie = Movie.find(id) 
  end
  
  def index
    if params[:ratings].nil? and params[:commit] 
        session.delete(:checks)
    end

    @sort = params[:sort] || session[:sort]
    @all_ratings = Movie.all_ratings
    @checks = params[:ratings] || session[:checks] || {'PG' => '1', 'G' => '1','R' => '1', 'PG-13' => '1'}

    session[:checks] = @checks
    session[:sort] = @sort

    if @checks.nil?
        @movies = Movie.all
    else
        @movies = Movie.where(rating: @checks.keys)
    end  
    @movies = @movies.order(@sort) if @sort   
end
        
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
