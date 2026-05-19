class TandaAuthController < ApplicationController
    before_action :authenticate_user!

    def connect
        scopes = "me user timesheet"

        query = {
            scope: scopes.tr(" ", "+"),
            client_id: ENV["TANDA_CLIENT_ID"],
            redirect_uri: ENV["TANDA_REDIRECT_URI"],
            response_type: "code"
        }.to_query

        redirect_to(
            "https://my.tanda.co/api/oauth/authorize?#{query}",
            allow_other_host: true
        )
    end

    def callback
        code = params[:code]

        response = Faraday.post("https://my.tanda.co/api/oauth/token") do |req|
            req.body = {
                client_id: ENV["TANDA_CLIENT_ID"],
                client_secret: ENV["TANDA_CLIENT_SECRET"],
                code: code,
                redirect_uri: ENV["TANDA_REDIRECT_URI"],
                grant_type: "authorization_code"
        }
        end

        token_data = JSON.parse(response.body)

        session[:tanda_access_token] = token_data["access_token"]
        session[:tanda_refresh_token] = token_data["refresh_token"]

        redirect_to "/tanda/me"
    end

    def me
        response = Faraday.get("https://my.tanda.co/api/v2/users/me") do |req|
            req.headers["Authorization"] = "bearer #{session[:tanda_access_token]}"
        end

        @tanda_user = JSON.parse(response.body)
    end
end
