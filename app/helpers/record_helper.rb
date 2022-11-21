# frozen_string_literal: true

module RecordHelper
  def dom_id_for_records(*records, prefix: nil)
    records.map do |record|
      record.new_record? ? "new_#{record.class.name.underscore}" : dom_id(record, prefix)
    end.join('_')
  end
end
