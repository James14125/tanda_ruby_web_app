class TandaAuthController < ApplicationController
  before_action :authenticate_user!

  def me
    response = Faraday.get("https://my.tanda.co/api/v2/users/me") do |req|
      req.headers["Authorization"] = "Bearer #{ENV.fetch("TANDA_API_TOKEN")}"
    end

    render json: JSON.parse(response.body), status: response.status
  end

  def show
    response = Faraday.get("https://my.tanda.co/api/v2/users/me") do |req|
      req.headers["Authorization"] = "Bearer #{ENV.fetch("TANDA_API_TOKEN")}"
    end

    @tanda_user = JSON.parse(response.body)
  end
end