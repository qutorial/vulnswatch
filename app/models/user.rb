class User < ApplicationRecord

  devise :database_authenticatable, 
        #:omniauthable,
        #:registerable,
        #:timeoutable,
  	:recoverable, 
  	:rememberable, 
  	:trackable, 
  	:validatable, 
  	:lockable,
  	#:confirmable,
        :zxvbnable
        
  has_many :projects, dependent: :destroy
  
end
