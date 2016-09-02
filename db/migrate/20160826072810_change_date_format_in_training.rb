class ChangeDateFormatInTraining < ActiveRecord::Migration[5.0]
  def up
    change_column :trainings, :training_date, :datetime
  end

  def down
    change_column :trainings, :training_date, :date
  end
end
