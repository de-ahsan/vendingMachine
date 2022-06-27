module Api
  module V1
    class ProductsController < Api::V1::ApiController
      before_action :set_product, only: %i[show update destroy]
      before_action :authorize_user, except: :index

      def index
        @products = Product.all

        render json: @products
      end

      def show
        render json: @product
      end

      def create
        @product = Product.new(product_params)

        if @product.save
          render json: @product, status: :created, location: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
      end

      private


      def authorize_user
        return if current_user == @product.seller

        render json: { error: :unauthorized }, status: :unauthorized
      end

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :available_count, :seller_id, :price)
      end
    end
  end
end
