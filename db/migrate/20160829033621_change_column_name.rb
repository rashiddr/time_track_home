class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :trainings, :training_date, :training_datetime
  end
end
