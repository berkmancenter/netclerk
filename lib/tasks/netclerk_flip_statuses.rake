require 'terminal-table'

# See Redmine #12269 regarding flipping the meaning of status values

namespace :netclerk do
  desc 'Flip values and deltas of statuses'
  task flip_statuses: :environment do
    STATUS_VALUES = Status.pluck(:value).uniq.compact.sort
    STATUS_DELTAS = Status.pluck(:delta).uniq.compact.sort

    value_rows = STATUS_VALUES.map { |v| ['Value', v, Status.where(value: v).count] }
    delta_rows = STATUS_DELTAS.map { |d| ['Delta', d, Status.where(delta: d).count] }
    print_table(value_rows, delta_rows, 'Pre-Flip Statuses')

    ActiveRecord::Base.transaction do
      flip_values(STATUS_VALUES)
      flip_deltas(STATUS_DELTAS)
    end

    value_rows = STATUS_VALUES.map { |v| ['Value', v, Status.where(value: v).count] }
    delta_rows = STATUS_DELTAS.map { |d| ['Delta', d, Status.where(delta: d).count] }
    print_table(value_rows, delta_rows, 'Post-Flip Statuses')
  end
end

def flip_values(values)
  intermediate_values = values.map { |v| v + 999 }
  reversed_values = values.reverse

  values.each_with_index do |v, i|
    Status.where(value: v).update_all(value: intermediate_values[i])
  end

  intermediate_values.each_with_index do |v, i|
    Status.where(value: v).update_all(value: reversed_values[i])
  end
end

def flip_deltas(deltas)
  intermediate_deltas = deltas.map { |d| d + 999 }
  reversed_deltas = deltas.reverse

  deltas.each_with_index do |d, i|
    Status.where(delta: d).update_all(delta: intermediate_deltas[i])
  end

  intermediate_deltas.each_with_index do |d, i|
    Status.where(delta: d).update_all(delta: reversed_deltas[i])
  end
end

def print_table(value_rows, delta_rows, title = nil)
  table = Terminal::Table.new do |t|
    value_rows.each { |vr| t.add_row(vr) }
    t.add_separator
    delta_rows.each { |dr| t.add_row(dr) }
  end

  table.title = title
  table.headings = %w(Type Item Count)
  table.align_column(2, :right)
  table.align_column(3, :right)

  puts table
end
