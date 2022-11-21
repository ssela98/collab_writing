# frozen_string_literal: true

module RecordHelper
  def dom_id_for_records(*records)
    records.map do |record|
      dom_id(record)
    end.join('_')
  end
end
