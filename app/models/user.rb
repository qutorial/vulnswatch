class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  	:recoverable, :rememberable, :trackable, :validatable, :lockable, :zxcvbnable #,
        #:confirmable
  has_many :projects, dependent: :destroy
end
