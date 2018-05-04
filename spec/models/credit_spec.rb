require 'rails_helper'
RSpec.describe Credit, :type => :model do
  describe '검색 조건 테스트' do
    before(:each) do
      # FactoryBot.create(:Credit, date: '2018-04-01')
      # FactoryBot.create(:Credit, date: '2018-04-02')
      # FactoryBot.create(:Credit, date: '2018-04-03')
      # FactoryBot.create(:Credit, date: '2018-04-04')
    end

    context '시간 기준 검색 조건' do
      it '시간 기준으로 검색을 했을 경우, 시간 범위 안에 있는 값만 리턴한다' do
        get :index
        where_clause = Credit.make_where_clause(params)
        credit = Credit.find_credit_list(1, where_clause)

        expect(credit.size).to eq(2)
      end
    end

  end
end