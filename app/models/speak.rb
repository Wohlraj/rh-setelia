class Speak < ActiveRecord::Base
	belongs_to :user
	belongs_to :language

	validates :user_id, presence: true
  validates :language_id, presence: true
  validates :level, presence: true

  LEVELS=["Courant", "Débutant"]
end