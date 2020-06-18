require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end

  def score
    # The word can’t be built out of the original grid
      if grid_inclusion?(params[:word], params[:grid]) == false
        @answer = "Sorry but #{params[:word]} can't be built out of #{params[:grid]}"
      elsif english_word?(params[:word]) == false
        @answer = "Sorry but #{params[:word]} does not seem to be a valid English word..."
      else
        @answer = "Congratulations! #{params[:word].capitalize} is a valid English word!"
      end
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
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json = JSON.parse(open(url).read)
    json['found']
  end
end
