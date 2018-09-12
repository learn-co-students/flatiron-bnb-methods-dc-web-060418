class Review < ActiveRecord::Base
  validates :rating,
    presence: true
  validates :description,
    presence: true
  validates :reservation,
    presence: true

  validate :check_day

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  private
    def check_day
      if reservation
        if Date.today <= reservation.checkout
          errors.add(:reservation, "must have passed")
        end
      end
    end
end
