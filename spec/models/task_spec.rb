require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:due_date) }
  it { should validate_presence_of(:priority) }
  it { should validate_presence_of(:status) }

  it { should belong_to(:workspace) }
  it { should belong_to(:assignee).class_name('User') }
  it { should belong_to(:category) }
end