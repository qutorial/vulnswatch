class Tag < ApplicationRecord
  belongs_to :vulnerability
  belongs_to :user
  validates :user_id, presence: true
  validates :vulnerability_id, presence: true
  validates_uniqueness_of :component, scope: :vulnerability_id
  validates :component, presence: true, allow_blank: false
end
