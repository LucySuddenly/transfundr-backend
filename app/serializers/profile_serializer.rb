class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :bio, :cover_img, :profile_img, :venmo, :cash, :paypal, :zelle, :user_id
  belongs_to :user
end
