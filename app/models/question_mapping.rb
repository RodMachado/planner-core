class QuestionMapping < Enum
  acts_as_enumerated

  attr_accessible :name
end