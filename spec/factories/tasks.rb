FactoryBot.define do
  factory :task do
    title { "Test Task" }
    due_date { Date.today }
    priority { :medium }
    status { :pending }
    association :workspace
    association :assignee, factory: :user
    association :category
  end
end 