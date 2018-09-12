class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin_str, checkout_str)
    checkin = Date.parse(checkin_str)
    checkout = Date.parse(checkout_str)

    listings.select do |listing|

      listing.open?(checkin, checkout)

    end

  end

  def num_reservations
    i = 0
    listings.each do |listing|
      i += listing.reservations.length
    end
    i
  end

  def fullness
    if listings.any?
      res = num_reservations.to_f / listings.count.to_f
    else
      res = 0.0
    end

    res
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by(&:fullness)
  end

  def self.most_res
    Neighborhood.all.max_by(&:num_reservations)
  end

end
