class Theme < ActiveRecord::Base
  attr_accessible :lock_version, :themed_id, :themed_type, :theme_name, :theme_name_id

  belongs_to :theme_name
  belongs_to :themed, :polymorphic => :true
  
  before_destroy :update_timestamp
  after_save  :update_timestamp
  
  protected

  # update the timestamp of the themed item  
  def update_timestamp
      themed.touch
      themed.save
  end

end
