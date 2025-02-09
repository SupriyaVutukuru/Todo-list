class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.integer :notify_before
      t.integer :priority
      t.integer :category_id
      t.integer :status
      t.integer :assignee_id
      t.integer :workspace_id

      t.timestamps
    end
  end
end
