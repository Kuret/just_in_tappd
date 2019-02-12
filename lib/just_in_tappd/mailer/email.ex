defmodule JustInTappd.Mailer.Email do
  import Bamboo.Email

  alias JustInTappd.Accounts.User

  def login_email(%User{email: email, first_name: name}, url) do
    new_email()
    |> to(email)
    |> from("accounts@justinbeer.nl")
    |> subject("Login to Just in Tappd")
    |> html_body("""
    <strong>Hello #{name}</strong><br />
    <span><a href='#{url}'>Click here to login to Just in Tappd</a></span>
    """)
  end
end
