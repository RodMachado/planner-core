#
#
#
module FeatureService
  
  #
  #
  #
  def self.has?(feature)
    
    Feature.pluck(:name).include? feature
    
  end
  
  #
  # Place holder for feature enablement
  #
  def self.enabled?(feature)
    
    true
    
  end

end
