class User < ActiveRecord::Base
  has_many :tweets

  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end
  def authenticate(string)
    if self.password == string
      self
    else
      false
    end 
  end
  #
  # def authenticate(check_password)
  #   password == check_password ? self : false
  # end
  # private
  #
  # # some_user.password == "bunnies" => true
  # def password
  #   BCrypt::Password.new(password_digest)
  # end
  #
  # # User.create(username: 'Tim', password: 'bunnies')
  # def password=(new_password)
  #   password = BCrypt::Password.create(new_password)
  #   self.password_digest = password
  # end

end
