require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    create_grid
  end

  def score
    create_answer
  end

  private

  def grid_inclusion?(word, grid)
    grid_array = grid.split(//)
    word.upcase.chars.all? do |letter|
      if grid_array.include?(letter)
        grid_array.delete_at(grid_array.index(letter))
      end
    end
  end

  def english_word?(word)
    # check notes to see alternative without open(url)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json = JSON.parse(open(url).read)
    json['found']
  end

  def create_grid
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
    # instead I could do @letters = ('A'..'Z').to_a.sample(10)
  end

  def create_answer
    # It might be better to do that in the score.html.erb because it contains a lot of strings (which should be part of the view)
    @answer =
      if grid_inclusion?(params[:word], params[:grid]) == false
        "Sorry but #{params[:word]} can't be built out of #{params[:grid]}"
      elsif english_word?(params[:word]) == false
        "Sorry but #{params[:word]} does not seem to be a valid English word..."
      else
        add_points
        "Congratulations! #{params[:word].capitalize} is a valid English word!"
      end
  end

  def add_points
    if session.key?(:score)
      session[:score] += params[:word].length
    else
      session[:score] = params[:word].length
    end
  end

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end
end
