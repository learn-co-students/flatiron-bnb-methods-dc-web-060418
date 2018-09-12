class Listing < ActiveRecord::Base
  validates :address,
    presence: true
  validates :listing_type,
    presence: true
  validates :title,
    presence: true
  validates :description,
    presence: true
  validates :price,
    presence: true
  validates :neighborhood,
    presence: true

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :update_host
  before_destroy :unupdate_host

  def open?(checkin, checkout)
    reservations.each do |reservation|
      if (checkin >= reservation.checkin && checkin <= reservation.checkout) ||
         (checkout >= reservation.checkin && checkout <= reservation.checkout)
        return false
      end
    end

    true
  end

  def average_review_rating
    sum = 0
    reviews.each { |review| sum += review.rating }
    sum.to_f / reviews.count.to_f
  end

  private

    def update_host
      host.update(host: true)
    end

    def unupdate_host
      if host.listings.length == 1
        host.update(host: false)
      end
    end

end
