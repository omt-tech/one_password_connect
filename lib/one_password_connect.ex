defmodule OnePassword.Connect do
  @moduledoc """
  This is a library that can talk to a 1Password Connect Server
  with a single dependency, Jason.

  It uses the built in httpc from OTP to stay as lightweight as possible
  to be able to utilize the library from the runtime.exs.


  Usage is purely runtime configured.

  Construct a `OnePassword.Connect.Configuration` and feed it
  to `OnePassword.Connect.Client` and you are good to go.
  """
end
