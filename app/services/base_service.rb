# frozen_string_literal: true

module BaseService
  BASE_API_URL = 'https://bravado-images-production.s3.amazonaws.com'

  def call
    raise 'Must be implemented.'
  end
end
