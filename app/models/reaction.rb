class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :vulnerability
  validates :user_id, presence: true
  validates :vulnerability_id, presence: true
  validates :status, numericality: true, presence: true
  validates_inclusion_of :status, :in => 1..4
  validates :title, presence: true
  validates :text, presence: true
  validates :title, length: { minimum: 15}
  validates :title, length: { maximum: 60 }
  validates :text, length: {minimum: 70}
end
