class SimAnneal
  attr_accessor :state, :temperature

  def anneal()
    init_state
    init_temperature

    before
    while @temperature > 0
      cool

      nbr_state = neighbor
      if rand < acceptance(nbr_state)
        @state = nbr_state
        accepted
      end

      during
    end
    after

    @state
  end


  protected

  def init_state
    abstract_error
  end

  def init_temperature
    abstract_error
  end

  # Generate a random neighbor
  def neighbor
    abstract_error
  end

  # Lower the temperature
  def cool
    abstract_error
  end

  # How willing am I to accept this new state over my current state?
  def acceptance()
    abstract_error
  end

  # do some custom action before annealing
  def before
  end

  # do some custom action each round during annealing
  def during
  end

  # do some custom action if and when a new state is accepted
  def accepted
  end

  # do some custom action after annealing
  def after
  end


  private

  def abstract_error
    raise 'Inheriting classes must define this method!'
  end
end
