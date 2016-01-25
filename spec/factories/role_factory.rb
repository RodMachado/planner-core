FactoryGirl.define do
  factory :admin_role, class: Role do
    title 'Admin'
  end

  factory :planner_role, class: Role do
    title 'Planner'
  end

  factory :super_planner_role, class: Role do
    title 'SuperPlanner'
  end
end
