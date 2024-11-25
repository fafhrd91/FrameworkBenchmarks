# frozen_string_literal: true

class JsonController < ApplicationControllerMetal
  def index
    add_headers
    self.content_type = 'application/json'
    self.response_body = { 'message' => 'Hello, World!' }.to_json
  end
end
