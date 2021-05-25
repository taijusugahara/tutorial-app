class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # 元々はこう　user && user.authenticate(params[:session][:password])
      # このauthenticateはhas_secure_passwordが持つ特性なので定義しなくても使える。
      # 一方remember_tokenとかはhas_secure_passwordとは関係ないのでauthenticateメソッドを定義する必要がある
      log_in user
      redirect_to user
      
    else
      
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end

end
