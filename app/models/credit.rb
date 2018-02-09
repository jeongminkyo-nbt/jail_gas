class Credit < ApplicationRecord
  validates :name, :date, :cost,  presence: true
  resourcify
  include Authority::Abilities

  LIST_PER_PAGE = 25

  def self.change_string_to_time(time_str)
    Time.parse("#{time_str['year']}-#{time_str['month']}-#{time_str['day']}").strftime('%Y-%m-%d')
  end

  def self.make_where_clause(params)
    if params[:search_value].blank? && params['start_date'].blank? && params['end_date'].blank?
      if params[:value] == 1
        return 'status is null'
      else
        return 'status = 1'
      end
    end

    search_value = params[:search_value].blank? ? nil : params[:search_value]
    where_clause = ''

    # key, value 기준 검색 where 조건 생성
    if search_value.present?
      if params[:value] == 1
        where_clause = "name like '%#{search_value}%' and status is null"
      else
        where_clause = "name like '%#{search_value}%' and status = 1"
      end
    end


    # 시간 기준 검색 where 조건 생성
    if params['start_date'].present? && params['end_date'].present?
      start_date = change_string_to_time(params['start_date'])
      end_date = change_string_to_time(params['end_date'])
      if where_clause.present?
        if params[:value] == 1
          where_clause = where_clause + " AND date >= '#{start_date}' AND date <= '#{end_date}' AND status is null"
        else
          where_clause = where_clause + " AND date >= '#{start_date}' AND date <= '#{end_date}' AND status = 1"
        end
      else
        if params[:value] == 1
          where_clause = where_clause + "date >= '#{start_date}' AND date <= '#{end_date}' AND status is null"
        else
          where_clause = where_clause + "date >= '#{start_date}' AND date <= '#{end_date}' AND status = 1"
        end
      end
    end
    where_clause
  end


  def self.find_credit_list(page, where_clause)
    Credit.select('
            *
          ')
        .where(where_clause)
        .order(date: :desc).page(page).per(LIST_PER_PAGE)
  end


end