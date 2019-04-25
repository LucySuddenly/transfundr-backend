class User < ApplicationRecord
    validates :username, uniqueness: { case_sensitive: false }
    has_one :profile
    has_many :beacons
    has_many :donations
end
