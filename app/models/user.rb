# frozen_string_literal: true

class User < ApplicationRecord
  include Gravtastic
  gravtastic
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :room
  has_many :messages

 has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  has_many :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates :name, presence: true, length: { minimum: 5 }

  after_create :create_chatroom

  def self.search(query)
    where("name like ? OR email like ?", "%#{query}%", "%#{query}%")
  end

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ').last
  end

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.compact
  end

  def remove_friends(user)
    friends.delete(user)
  end

  # Users who are yet to confirm ur friend request
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  def cancel_friend_request(user)
    friendship = friendships.find { |f| f.friend_id == user.id }
    friendship.destroy
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def mutual_friends(user)
    friends & user.friends unless user.id == id
  end

  def mutual_friends?(user)
    !mutual_friends(user).nil?
  end

  def friend?(user)
    friends.include?(user)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      data = session['devise.facebook_data']
      if data && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  private 

  def create_chatroom
    hyphenated_username = self.name.split.join('-')
    Room.create(name: hyphenated_username, user_id: self.id)
  end 
end
