namespace :tasks do
  desc "Send task reminder emails"
  task send_reminders: :environment do
    Task.where(status: :pending).find_each do |task|
      if task.due_date && task.due_date <= Time.now + task.notify_before.days
        TaskMailer.reminder_email(task).deliver_later
        puts "Reminder email sent for task: #{task.title}"
      end
    end
  end
end 