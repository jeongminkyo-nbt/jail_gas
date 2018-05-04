require 'rails_helper'

RSpec.describe CreditsController, :type => :controller do
  describe '#duplicate_item' do

    context '성공 케이스' do
      before(:each) do
        @store_item = FactoryBot.create(:store_item, :product_id => 'M00001232')
      end

      it 'product_id가 nil값이고, 상품 상태가 off상태이다' do
        post :duplicate_item, ref_item_id: @store_item.id

        duplicate_item = StoreItem.last
        expect(duplicate_item.enable).to eq(0)
        expect(duplicate_item.product_id).to eq(nil)
      end

      it '상품이 복사된다' do
        post :duplicate_item, ref_item_id: @store_item.id
        expect(StoreItem.all.size).to eq(2)
      end
    end
  end
end