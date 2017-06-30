class User < ApplicationRecord

  devise :database_authenticatable, 
        #:omniauthable,
        :registerable,
        #:timeoutable,
  	:recoverable, 
  	:rememberable, 
  	:trackable, 
  	:validatable, 
  	:lockable,
  	#:confirmable,
        :zxcvbnable
        
  has_many :projects, dependent: :destroy
  has_many :reactions, dependent: :destroy
  
end
