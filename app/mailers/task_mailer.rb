class TaskMailer < ApplicationMailer
  def reminder_email(task)
    @task = task
    @user = task.assignee
    mail(to: @user.email, subject: 'Task Reminder')
  end
end
