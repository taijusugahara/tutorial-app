module LoggedIn
  def is_login?
    !session[:user_id].nil?
  end

  def log_in(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    check 'Remember me on this compute'
    find('input[name="commit"]').click
    # expect(current_path).to eq(user_path(user))
    
  end

  # def log_in_no_remember(user)
  #   visit login_path
  #   fill_in 'Email', with: user.email
  #   fill_in 'Password', with: user.password
  #   uncheck 'Remember me on this compute'
  #   find('input[name="commit"]').click
  #   expect(current_path).to eq(user_path(@user))
    
  # end

  # request
  def log_in_as(user, remember:'1')
    post login_path, params:{session:{email: user.email,password: user.password,remember_me: remember}}
  end

end