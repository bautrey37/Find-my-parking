defmodule Findmyparking.ApiAuthPipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :findmyparking,
      error_handler: Findmyparking.ApiErrorHandler,
      module: Findmyparking.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
