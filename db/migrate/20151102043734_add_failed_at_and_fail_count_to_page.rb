class AddFailedAtAndFailCountToPage < ActiveRecord::Migration
  def change
    add_column :pages, :failed_at, :date
    add_column :pages, :fail_count, :integer, null: false, default: 0
  end
end
