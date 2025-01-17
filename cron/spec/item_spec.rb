require './spec/spec_helper'
require './models'

describe Item do
  describe "#compute_size" do

    before do
      @item = Item.create(product_id: 0, barcode: 'test111', size_type: 1, size: '999')
      @super_size = SuperSize.create(size_type: 1)
      @size_name = SizeName.create(super_size: @super_size, size: @item.size)
    end

    context "size system is 'ru'" do
      before do
        @item.update(size_system: "ru")
        @super_size.update(ru_size: @item.size)
      end
      it "returns a SuperSize directly by ru_size" do
        expect(@item.compute_size).to be_eql(SuperSize.where(ru_size: @item.size, size_type: @item.size_type).first)
      end
    end

    context "size system is 'int'" do
      before do
        @item.update(size_system: "int")
        @super_size.update(int_size: @item.size)
      end
      it "returns a SuperSize directly by int_size" do
        expect(@item.compute_size).to be_eql(SuperSize.where(int_size: @item.size, size_type: @item.size_type).first)
      end
    end

    context "size system is not 'ru' or 'int'" do
      before do
        @item.update(size_system: "test")
        @size_name.update(size_m_s: 'test')
      end
      it "returns a SuperSize from size_names" do
        size_name = SizeName.where(size: @item.size, size_m_s: 'test', super_size: SuperSize.where(size_type: @item.size_type)).first
        expect(@item.compute_size).to be_eql(size_name.super_size)
      end
    end

    after do
      @item.delete
      @super_size.delete
      @size_name.delete
    end
  end

  describe "#compute_size_type" do
    before do
      @category = Category.create(name: 'test', mens_size_type_id: 1, womens_size_type_id: 2)
      @product = Product.create(category: @category)
      @item = Item.create(product: @product, barcode: 'test111')
    end

    context "sex is 1 (men)" do
      before do
        @product.update(sex: 1)
      end
      it "returns the category's mens_size_type_id" do
        expect(@item.compute_size_type).to be_eql(@item.product.category.mens_size_type_id)
      end
    end

    context "sex is 0 (unisex)" do
      before do
        @product.update(sex: 0)
      end
      it "returns the category's mens_size_type_id" do
        expect(@item.compute_size_type).to be_eql(@item.product.category.mens_size_type_id)
      end
    end

    context "sex is 2 (women)" do
      before do
        @product.update(sex: 2)
      end
      it "returns the category's womens_size_type_id" do
        expect(@item.compute_size_type).to be_eql(@item.product.category.womens_size_type_id)
      end
    end

    after do
      @item.delete
      @product.delete
      @category.delete
    end
  end

  describe "#compute_size_system" do
    before do
      @item = Item.create(product_id: 0, barcode: 'test111')
    end

    # Мужская обувь
    context "size type is 1" do
      before do
        @item.size_type = 1
      end
      context "size < 20" do
        before do
          @item.size = "8"
        end
        it "returns 'Англия (UK)'" do
          expect(@item.compute_size_system).to be_eql("Англия (UK)")
        end
      end
      context "size > 20" do
        before do
          @item.size = "42"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
    end

    # Женская обувь
    context "size type is 2" do
      before do
        @item.size_type = 2
      end
      context "size < 20" do
        before do
          @item.size = "6"
        end
        it "returns 'Англия (UK)'" do
          expect(@item.compute_size_system).to be_eql("Англия (UK)")
        end
      end
      context "size > 20" do
        before do
          @item.size = "38"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
    end

    # Мужская одежда
    context "size type is 3" do
      before do
        @item.size_type = 3
      end
      context "size is 'S'" do
        before do
          @item.size = "S"
        end
        it "returns 'int'" do
          expect(@item.compute_size_system).to be_eql("int")
        end
      end
      context "size is '3XL'" do
        before do
          @item.size = "3XL"
        end
        it "returns 'int'" do
          expect(@item.compute_size_system).to be_eql("int")
        end
      end
      context "size is '46'" do
        before do
          @item.size = "46"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
    end

    # Женская одежда
    context "size type is 4" do
      before do
        @item.size_type = 4
      end
      context "size is 'S'" do
        before do
          @item.size = "S"
        end
        it "returns 'int'" do
          expect(@item.compute_size_system).to be_eql("int")
        end
      end
      context "size is '36'" do
        before do
          @item.size = "36"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
    end

    # Мужские джинсы и брюки
    context "size type is 5" do
      before do
        @item.size_type = 5
      end
      context "size is 'S'" do
        before do
          @item.size = "S"
        end
        it "returns 'int'" do
          expect(@item.compute_size_system).to be_eql("int")
        end
      end
      context "size is < 44" do
        before do
          @item.size = "32"
        end
        it "returns 'Деним'" do
          expect(@item.compute_size_system).to be_eql("Деним")
        end
      end
      context "size is = 44" do
        before do
          @item.size = "44"
          @item.update(product_id: 999999)
        end

        context "has no other sizes" do
          it "returns 'Европа (EU)'" do
            expect(@item.compute_size_system).to be_eql("Европа (EU)")
          end
        end

        context "has lower sizes" do
          before do
            @item2 = Item.create(product_id: 999999, barcode: 'test112', size: 32)
          end
          it "returns 'Деним'" do
            expect(@item.compute_size_system).to be_eql("Деним")
          end
        end

        context "has higher sizes" do
          before do
            @item2 = Item.create(product_id: 999999, barcode: 'test112', size: 54)
          end
          it "returns 'Европа (EU)'" do
            expect(@item.compute_size_system).to be_eql("Европа (EU)")
          end
        end
      end

      context "size is > 44" do
        before do
          @item.size = "50"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
    end

    # Женские джинсы и брюки
    context "size type is 6" do
      before do
        @item.size_type = 6
      end
      context "size is 'S'" do
        before do
          @item.size = "S"
        end
        it "returns 'int'" do
          expect(@item.compute_size_system).to be_eql("int")
        end
      end
      context "size is < 34" do
        before do
          @item.size = "27"
        end
        it "returns 'Деним'" do
          expect(@item.compute_size_system).to be_eql("Деним")
        end
      end
      context "size is > 34" do
        before do
          @item.size = "38"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
    end

    # Мужские рубашки (сорочки)
    context "size type is 13" do
      before do
        @item.size_type = 13
      end
      context "size is 'S'" do
        before do
          @item.size = "S"
        end
        it "returns 'int'" do
          expect(@item.compute_size_system).to be_eql("int")
        end
      end
      context "size is > 46" do
        before do
          @item.size = "54"
        end
        it "returns 'Европа (EU)'" do
          expect(@item.compute_size_system).to be_eql("Европа (EU)")
        end
      end
      context "size is <= 46" do
        before do
          @item.size = "46"
        end
        it "returns 'Размер по вороту (Обхват шеи) (см)'" do
          expect(@item.compute_size_system).to be_eql("Размер по вороту (Обхват шеи) (см)")
        end
      end
    end

    after do
      Item.where(barcode: /test11/).delete
    end
  end
end
