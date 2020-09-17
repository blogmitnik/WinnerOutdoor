module CustomTokenErrorResponse
  def body
    {
      status_code: 401,
      response_message: "Authentication Failed",
      error_message: I18n.t('devise.failure.invalid', authentication_keys: User.authentication_keys.join('/')),
      result: []
    }
    # or merge with existing values by
    # super.merge({key: value})
  end
end