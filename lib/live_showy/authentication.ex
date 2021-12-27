defmodule LiveShowy.Authentication do
  alias Phoenix.Token
  alias LiveShowyWeb.Endpoint
  alias LiveShowy.Protocols.User

  @salt "user id token"
  @max_age 86400

  def get_user_token(user_id) when is_binary(user_id) do
    Token.sign(Endpoint, @salt, user_id)
  end

  def get_user_token(%User{} = user) do
    get_user_token(user.id)
  end

  def get_user_token(_), do: nil

  def verify_user_token(token) do
    Token.verify(Endpoint, @salt, token, max_age: @max_age)
  end
end
