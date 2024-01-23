require 'json'
require 'net/http'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    @result = word_checker(@word, @letters)
  end

  private

  def word_checker(word, letters)
    api_url = "https://wagon-dictionary.herokuapp.com/#{word}"
    uri = URI(api_url)
    response = Net::HTTP.get(uri)
    user_response = JSON.parse(response)
    if user_response['found'] && word.chars.all? { |letter| letters.include?(letter.upcase) }
      return "Congratulations! '#{word.upcase}' is a valid English word."
    elsif user_response['found']
      return "Sorry, but '#{word.upcase}' can't be built out of '#{letters}'."
    else
      return "Sorry, but '#{word.upcase}' does not seem to be a valid English word."
    end
  end
end
