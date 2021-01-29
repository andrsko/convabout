defmodule Convabout.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :convabout,
    error_handler: Convabout.Accounts.ErrorHandler,
    module: Convabout.Accounts.Guardian

  # If there is an authorization header validate it
  plug(Guardian.Plug.VerifyHeader)
  # Load the user if either of the verifications worked
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
