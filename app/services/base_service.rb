# frozen_string_literal: true

module BaseService
  BASE_API_URL = 'https://bravado-images-production.s3.amazonaws.com'

  MissingImplementationError = Class.new(::StandardError)
  MissingEndpointError = Class.new(::StandardError)

  def call
    raise MissingImplementationError
  end

  private

  def base_api_url
    raise MissingEndpointError unless self.class.const_defined?(:ENDPOINT)

    BASE_API_URL + self.class::ENDPOINT
  end

  def api_url
    raise MissingImplementationError
  end
end
