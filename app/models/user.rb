class User < ApplicationRecord
  has_secure_password
  # mount_uploader :avatar, AvatarUploader
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  has_many :workspace_memberships
  has_many :workspaces, through: :workspace_memberships
  has_many :tasks

  protected

  def generate_jwt
    JWT.encode({ user_id: id }, ENV['SECRET_KEY'])
  end
end