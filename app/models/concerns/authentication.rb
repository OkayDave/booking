module Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password

    def api_token
      return attributes['api_token'] if attributes['api_token'].present?

      new_token = Digest::SHA1.hexdigest(name.to_s + email.to_s + Time.zone.now.to_s)
      update(api_token: new_token)

      new_token
    end
  end

  class_methods do
    def find_by_api_token(token)
      return nil if token.blank?

      User.find_by(api_token: token) || nil
    end

    def find_by_credentials(address, pass)
      User.find_by(email: address)&.authenticate(pass) || nil
    end
  end
end
