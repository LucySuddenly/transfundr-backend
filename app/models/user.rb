class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false }
    has_one :profile
    has_many :beacons
    has_many :donations
end
