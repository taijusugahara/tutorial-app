module LoggedIn
  def is_logged_in?
    session = session[:user_id]
    # 左側はただの変数。なんでもいい
    # session[:user_id]だけだとテストコードではsessionが定義されていないためエラーが起きる。
    # そのため変数で定義している
    !session.nil?
    
  end

end