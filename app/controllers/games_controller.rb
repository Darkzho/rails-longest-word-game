require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end
  
  def score
    @attempt = params[:attempt].upcase
    @letters = params[:letters]
    @prueba_1 = @attempt.chars.all? { |letter| @attempt.count(letter) <= @letters.count(letter) } 

    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}")
    json = JSON.parse(response.read)
    @prueba_2 = json['found']
  end
  
  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
  
end
