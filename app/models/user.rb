class User < ApplicationRecord

  after_create do 
    SinchService.send_message(self, "Your first message")
  end
end
