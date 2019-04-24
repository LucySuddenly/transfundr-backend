class User < ApplicationRecord
    has_one :profile
    has_many :beacons
    has_many :donations
end
