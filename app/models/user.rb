class User < ActiveRecord::Base
  has_many :tweets
  # has_secure_password validations: false
  def slug
    self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.find_by_slug(slg)
    self.all.select {|u| u.slug == slg }[0]
  end

  def authenticate(str)
    str == self.password ? self : false
  end

end
