module Facility
  class Base < ApplicationRecord
    VALID_TYPES = %w[
      ::Facility::Tennis
      ::Facility::Volleyball
      ::Facility::Football
      ::Facility::Basketball
    ].freeze

    validates :type, presence: true, inclusion: { in: VALID_TYPES }
    validates :name, presence: true, length: { minimum: 1, maximum: 255 }

    def serializable_hash(opts = {})
      opts = {
        methods: %i[type]
      }.update(opts)

      super(opts)
    end
  end
end
