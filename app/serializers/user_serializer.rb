class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :password, :trans, :femme, :nonwhite
  has_one :profile
  has_many :beacons
  has_many :donations
end
