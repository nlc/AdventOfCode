require './SimAnneal.rb'
require 'byebug'

class MinimumLocation < SimAnneal
  attr_accessor :best_state, :best_fitness

  def init_state
    @state = # TODO select random point in random range
    @curr_fitness = fitness(@state)

    @best_state = @state
    @best_fitness = @curr_fitness
  end

  def init_temperature
    @temperature = @max_temperature = 1000000
  end

  def neighbor
    # TODO: Another nearby(?) seed OR jump to another range

    new_state
  end

  def cool
    @temperature -= 1
  end

  def fitness(key)
    # TODO smolness
  end

  def acceptance(new_state)
    new_fit = fitness(new_state)
    old_fit = @curr_fitness

    if new_fit > @best_fitness
      @best_fitness = new_fit
      @best_state = new_state
    end

    if new_fit >= old_fit
      1
    else
      log_probability = new_fit - old_fit
      -(@temperature.to_f / @max_temperature) / log_probability
    end
  end

  def accepted
    @curr_fitness = fitness(@state)

    # TODO
  end

  def before
    puts
    puts
    puts
  end

  def during
    if @temperature % 1000 == 0
      barlen = 40
      progress = 1 - @temperature.to_f / @max_temperature
      filled = (progress * barlen).to_i
      unfilled = barlen - filled
      progressbar = '[%s%s] %d%%' % ['#' * filled, '-' * unfilled, (progress * 100).to_i]

      # reset cursor
      print "\r\033[2A"

      # kc = KeywordCipher.new(@best_state)
      # @best_plaintext = kc.decode(@ciphertext)
      # puts @best_plaintext

      puts progressbar
    end
  end

  def after
    puts
    puts
  end

  # def after
  #   puts @plaintext
  #   puts "KEY = #{@state}"

  #   puts "best-ever state was #{@best_state}"
  # end
end

MinimumLocation.new.anneal
