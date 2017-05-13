class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable

  has_one :player
  accepts_nested_attributes_for :player

  validate :player_name_should_be_available
  before_create :register_player

  def player_name_should_be_available
    unless Player.name_available?(player)
      errors.add(:player, "This player name is already in use")
    end
  end

  def register_player
    Player.register(player)
  end

  def with_empty_player
    self.player = Player.new
    self
  end

end
