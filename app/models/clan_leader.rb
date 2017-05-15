class ClanLeader < ApplicationRecord
  belongs_to :clan
  belongs_to :player
end
