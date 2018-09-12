class Reservation < ActiveRecord::Base
  validates :checkin,
    presence: true
  validates :checkout,
    presence: true
  validate :check_guest, :check_listing

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, :through => :listing

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

    def check_guest
      errors.add(:guest, "can't be the same as host") if guest == listing.host
    end

    def check_listing
      if checkin
        listing.reservations.each do |reservation|
          if checkin >= reservation.checkin && checkin <= reservation.checkout
             errors.add(:listing, "is not available")
           end
         end
       end

       if checkout
         listing.reservations.each do |reservation|
           if checkout >= reservation.checkin && checkout <= reservation.checkout
              errors.add(:listing, "is not available")
            end
          end
       end

       if checkin && checkout
         if checkout <= checkin
           errors.add(:listing, "These times make nooo sense")
         end
       end
    end

end
