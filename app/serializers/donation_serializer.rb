class DonationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :beacon_id, :amount, :points, :confirmed
  belongs_to :user
  belongs_to :beacon
end
