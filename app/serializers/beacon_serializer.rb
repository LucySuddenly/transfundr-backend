class BeaconSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :target, :user_id
  belongs_to :user
  has_many :donations
  has_one :profile, through: :user
end
