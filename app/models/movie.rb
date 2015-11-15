class Movie < ActiveRecord::Base
    def self.ratings
        self.uniq.pluck(:rating)
    end
end
