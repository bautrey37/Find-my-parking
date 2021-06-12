defmodule FindmyparkingWeb.Router do
  use FindmyparkingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug FindmyparkingWeb.Authentication
  end

  pipeline :browser_auth do
    plug Findmyparking.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", FindmyparkingWeb do
    pipe_through [:browser]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", FindmyparkingWeb do
    pipe_through [:browser, :browser_auth]
    get "/", PageController, :index
  end

  scope "/", FindmyparkingWeb do
    pipe_through [:browser, :browser_auth, :ensure_auth]
    resources "/reservation", ReservationController
    resources "/user", UserController
    resources "/monthlypayment", MonthlyPaymentController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

#  pipeline :auth_api do
#    plug Findmyparking.ApiAuthPipeline
#  end

#  scope "/api", FindmyparkingWeb do
#    pipe_through :api
#    post "/sessions", SessionAPIController, :create
#  end

  scope "/api", FindmyparkingWeb do
#    pipe_through [:api, :auth_api]
    pipe_through [:api]
#    delete "/sessions/:id", SessionAPIController, :delete
    get "/reservation", ReservationAPIController, :retrieve_nearby_parking_lots
    patch "/reservation", ReservationAPIController, :book_space
    patch "/params", SearchParamsController, :storeParams
    get "/params", SearchParamsController, :getPaymentType
    get "/user", UserAPIController, :fetchDetails
    patch "/user", UserAPIController, :changePaymentStatus
    get "/paymonthly", MonthlyPaymentAPIController, :fetchMonthlyDetails
    patch "/paymonthly", MonthlyPaymentAPIController, :changePaymentStatus
  end
end
