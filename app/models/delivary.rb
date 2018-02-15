class Delivary < ApplicationRecord
  validates :name, :date, presence: true
  resourcify
  include Authority::Abilities
  
  LIST_PER_PAGE = 25

  def self.change_string_to_time(time_str)
    Time.parse("#{time_str['year']}-#{time_str['month']}-#{time_str['day']}").strftime('%Y-%m-%d')
  end

  def self.make_where_clause(params)
    return '' if params[:search_by].blank? && params[:search_value].blank? && params['start_date'].blank? && params['end_date'].blank?

    search_value = params[:search_value].blank? ? nil : params[:search_value]
    where_clause = ''

    # key, value 기준 검색 where 조건 생성
    if search_value.present?
        where_clause = "name like '%#{search_value}%' "
    end


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

  def self.find_delivary_list(page, where_clause)
    Delivary.select('
            *
          ')
        .where(where_clause)
        .order(date: :desc).page(page).per(LIST_PER_PAGE)
  end


end
