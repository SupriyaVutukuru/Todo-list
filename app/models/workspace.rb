class Workspace < ApplicationRecord
  has_many :workspace_memberships
  has_many :users, through: :workspace_memberships
  has_many :tasks

  validates :name, presence: true
  validates :description, presence: true

end
