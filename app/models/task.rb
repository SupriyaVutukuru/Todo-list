class Task < ApplicationRecord
    belongs_to :workspace
    belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'
    belongs_to :category

    # enum priority: { low: 0, medium: 1, high: 2 }, _prefix: :priority
    # enum status: { pending: 0, in_progress: 1, completed: 2 }, _prefix: :status
    # enum status: [ :pending, :in_progress,  :completed]
    enum :priority, low: 0, medium: 1, high: 2
    enum :status, pending: 0, in_progress: 1, completed: 2

    validates :title, presence: true
    validates :due_date, presence: true
    validates :priority, presence: true
    validates :status, presence: true

    after_update :send_reminder_email, if: :due_date_or_notify_before_changed?

    private

    def due_date_or_notify_before_changed?
        saved_change_to_due_date? || saved_change_to_notify_before?
    end

    def send_reminder_email
        # Assuming you have a mailer set up
        TaskMailer.reminder_email(self).deliver_later
    end
end