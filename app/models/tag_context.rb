class TagContext < ActiveRecord::Base
  attr_accessible :lock_version, :name, :publish
end
