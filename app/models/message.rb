class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

 
  def as_json(options)
    super(options).merge(avatar: user.avatar.url(:thumb), name: user.name)
  end
end
