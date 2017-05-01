class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable

  validates :player_name, :presence => true
  validate :player_name_should_be_available

  before_create :register_player

  def player_name_should_be_available
    unless Player.name_available?(self.player_name)
      errors.add(:player_name, "This player name is already in use")
    end
  end

  def register_player
    Player.register(self.player_name, self.player_clan)
  end

end
