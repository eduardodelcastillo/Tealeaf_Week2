# Blackjack using OOP
# 20131121
# 1. Have detailed requirements or specifications in written form.
# 2. Extract major nouns -> classes
  # Deck, Cards, Suits, Numbers, Players, Dealer
# 3. Extract major verbs -> instance methods
  # Deal, Count, Shuffle
# 4. Group instance methods into classes

class Card
  attr_accessor :suit, :face_value

  def initialize(suit, face_value)
    @suit = suit
    @face_value = face_value
  end

  def declare_card
    "Card: #{face_value} of #{suit}"
  end

  def to_s
    declare_card
  end
end

class Deck
  attr_accessor :cards 

  def initialize
    @cards = []
    ['Hearts', 'Diamonds', 'Spades', 'Clubs'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    card_shuffle
  end

  def card_shuffle
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.count 
  end

end

module Hand

  attr_accessor :total

  def show_hand
    puts "----- #{name}'s cards: -----"
    cards.each do |x|
      puts "=> #{x}"
    end
    calculate_total
    puts "Total: #{@total}"
  end

  def calculate_total
    @total = 0
    card_value = cards.map{ |card| card.face_value} #Need to transfer card value to an array
    card_value.each { |x| 
      case x
        when 'Jack'  
          @total += 10
        when 'Queen' 
          @total += 10
        when 'King'  
          @total += 10
        when 'Ace'
          if @total < 11
            @total += 11
          else
            @total += 1
          end
        else
          @total += x.to_i
        end
    }
    @total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted? # returns True if @total is over 21
    @total > 21
  end

  def is_blackjack?
    @total == 21
  end

  def dealer_min_reached?
    @total >= 17
  end

end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize
    get_name
    @cards = []
    puts 'Welcome to Blackjack!'
  end

  def get_name
    puts 'What is your name?'
    @name = gets.chomp
  end

end


class Dealer
  include Hand 

  attr_accessor :name, :cards 

  def initialize
    @name = 'Dealer'
    @cards = []
  end

end

class Blackjack

  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start_game
    # Deal 1 to player, deal 1 to dealer
    # Deal another 1 to player and show all dealt cards
    # Show the cards
    # Ask player to hit or stay
    # Once stay, dealer deals 2nd card for himself and deal more according to rule 17
    # Compare, declare winner
    deal_initial_cards
    show_cards
    check_blackjack
    player_hit_or_stay
    dealers_turn
    declare_winner
    new_game
  end

  def deal_initial_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
  end

  def show_cards
    player.show_hand
    dealer.show_hand
  end

  def player_hit_or_stay
    while !player.is_busted?
      puts 'Do you want to 1 Hit or 2 Stay?'
      hit_or_stay = gets.chomp
      if hit_or_stay == '1'
        player.add_card(deck.deal_one)
        player.show_hand
        if player.is_busted?
          puts 'Sorry, you busted. You lost.'
          new_game
        end
      elsif hit_or_stay == '2'
        puts 'You chose to stay.'
        break
      else
        puts 'Your choice is invalid. Please press 1 for Hit or 2 for Stay.'
      end
    end
  end

  def check_blackjack
    if player.is_blackjack?
      puts 'You have Blackjack! You win!'
      new_game
    end
    if dealer.is_blackjack?
      puts 'Dealer has Blackjack! You lost.'
      new_game
    end
  end

  def dealers_turn
    puts 'Dealing the other card for the dealer... '
    dealer.add_card(deck.deal_one)
    dealer.show_hand
    check_blackjack
    while !dealer.dealer_min_reached?
      dealer.add_card(deck.deal_one)
      dealer.show_hand
      if dealer.is_busted?
        puts 'Dealer busted. You win!'
        new_game
      end
    end
  end

  def declare_winner
    if player.total > dealer.total
      puts "#{player.name} won! Congratulations!"
    elsif player.total == dealer.total
      puts 'It\'s a draw!'
    else
      puts 'Dealer wins!'
    end
  end

  def new_game
    puts 'Do you want to play another game? (Y for new game or N to exit)'
    answer = gets.chomp.upcase
    if answer == 'Y'
      @deck = Deck.new
      @player.cards = []
      @dealer.cards = []
      start_game
    elsif answer == 'N'
      puts 'Goodbye!'
      exit
    else
      puts 'Your choice is invalid. Please enter Y or N'
    end
  end

end

game = Blackjack.new
game.start_game


