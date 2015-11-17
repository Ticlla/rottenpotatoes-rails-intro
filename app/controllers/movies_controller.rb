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
    redirect=false;
    @all_ratings= Movie.ratings
    @sort =session[:sort].nil? ? params[:sort] : session[:sort];
    @sort =params[:sort].nil? ? @sort : params[:sort];
    params[:sort]=@sort
    @ratings = session[:ratings].nil?  ?  params[:ratings] : session[:ratings]   ;
    @ratings = params[:ratings].nil? ? @ratings : params[:ratings] ;
  #  @ratings = @ratings.nil? ? @all_ratings : @ratings;
    if @ratings.nil? and @sort.nil? then
      @ratings={};
      @all_ratings.each{|x| @ratings[x]=1}
      redirect = true
    end
    
    redirect_to(sort: @sort, ratings: @ratings) if redirect
    @movies = Movie.order(@sort).where(rating: @ratings.keys);
    session[:sort]=@sort
    session[:ratings]=@ratings
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
