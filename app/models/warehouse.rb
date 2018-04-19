class Warehouse < ApplicationRecord
  validates :date, :status, presence: true
  resourcify
  include Authority::Abilities
  LIST_PER_PAGE = 25

  module Status
    INSERT = 0
    OUT = 1
  end

  def self.change_string_to_time(time_str)
    Time.parse("#{time_str['year']}-#{time_str['month']}-#{time_str['day']}").strftime('%Y-%m-%d')
  end

  def self.make_where_clause(params)
    return '' if  params['start_date'].blank? && params['end_date'].blank?

    where_clause = ''

    # 시간 기준 검색 where 조건 생성
    if params['start_date'].present? && params['end_date'].present?
      start_date = change_string_to_time(params['start_date'])
      end_date = change_string_to_time(params['end_date'])

      if where_clause.present?
        where_clause = where_clause + " AND date >= '#{start_date}' AND date <= '#{end_date}'"
      else
        where_clause = where_clause + "date >= '#{start_date}' AND date <= '#{end_date}'"
      end
    end
    where_clause
  end

  def self.find_warehouse_list(page, where_clause)
    Warehouse.select('
            *
          ')
        .where(where_clause)
        .order(date: :desc).page(page).per(LIST_PER_PAGE)
  end
end
