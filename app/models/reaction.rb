class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :vulnerability
  validates :user_id, presence: true
  validates :vulnerability_id, presence: true
  validates :status, numericality: true, presence: true
  validates_inclusion_of :status, :in => 1..4
  validates :vulnerability_id, uniqueness: { scope: :user_id }
end
