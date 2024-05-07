class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  after_validation :set_uuid, on: :create

  def set_uuid
    self.id ||= SecureRandom.uuid
  end
end
