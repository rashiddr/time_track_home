class AddDurationToTraining < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :duration, :float
  end
end
