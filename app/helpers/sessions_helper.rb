module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
                            # find_byを使う理由（findではない）IDが無効な場合（=ユーザーが存在しない場合）にもメソッドは例外を発生せず、nilを返します。
                            #                              findだとr例外を発生させてしまう
    end
  end
end
