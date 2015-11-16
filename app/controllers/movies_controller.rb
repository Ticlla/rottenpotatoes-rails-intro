class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings= Movie.ratings
    @criteria_link =params[:sort]
    
    @query = params[:ratings].nil?  ?  @all_ratings : params[:ratings].keys;
    session[:ratings_filtered]= (not params[:ratings].nil?) ? params[:ratings].keys : session[:ratings_filtered] ; 
    
    
#    session[:ratings_filtered]=params[:ratings].nil? ? @ratings_filtered :;
    @ratings_filtered=@query.respond_to?(:keys)? params[:ratings].keys : @query;
    @ratings_filtered =(not session[:ratings_filtered].nil?) ? session[:ratings_filtered] : @ratings_filtered;
    
    @movies = Movie.order(@criteria_link).where(rating: @query);
    
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
