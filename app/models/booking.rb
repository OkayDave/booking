class Booking < ApplicationRecord
  belongs_to :user, inverse_of: :bookings
  belongs_to :timeslot, inverse_of: :bookings

  validates :user, presence: true
  validates :timeslot, presence: true
  validate :timeslot_is_available

  has_one :facility, through: :timeslot

  enum state: {
    booked: 0,
    cancelled: 1,
    unconfirmed: 2
  }

  after_save :update_timeslot_state
  after_destroy :update_timeslot_state

  def serializable_hash(opts = {})
    opts = {
      methods: %i[error_messages notes],
      except: %i[metadata]
    }.update(opts)

    super(opts)
  end

  def notes
    metadata['notes']
  end

  def notes=(new_notes)
    metadata['notes'] = new_notes
  end

  private

  def update_timeslot_state
    timeslot.unavailable! if booked?
    timeslot.available! if cancelled? || !persisted?
  end

  def error_messages
    errors.full_messages if errors.any?
  end

  def timeslot_is_available
    return unless timeslot_id_changed?
    return if cancelled?
    return if timeslot.present? && timeslot.available?

    self.state = 2
    errors.add(:base, 'Selected timeslot is unavailable')
  end
end
