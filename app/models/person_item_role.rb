class PersonItemRole < Enum
  acts_as_enumerated

  attr_accessible :name, :position
end
