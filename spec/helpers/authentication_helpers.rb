# spec/support/authentication_helpers.rb

module AuthenticationHelpers
  def sign_in(user)
    session = Session.create(user: user)
    cookies.signed[:session_token] = session.id
  end
end
