class VendingMachineController < ApplicationController
  ALLOWED_DEPOSIT_AMOUNT = [5, 10, 20, 50, 100].freeze

  before_action :authorize_buyer
  before_action :set_product, only: :buy

  def deposit
    if ALLOWED_DEPOSIT_AMOUNT.include?(deposit_params[:deposit_amount])
      response = if current_user.update_deposit_amount(deposit_params[:deposit_amount], 'deposit')
                   'Amount Deposited Successfully'
                 else
                   current_user.errors
                 end

      render json: response
    else
      render json: 'Invalid Amount', status: :unprocessable_entity
    end
  end

  def buy
    quantity = params[:quantity].to_i
    total_amount = @product.price * quantity
    deposit_amount = current_user.deposit_amount

    if total_amount <= deposit_amount && (deposit_amount - total_amount).negative?
      current_user.update_deposit_amount(deposit_params[:deposit_amount], 'deduct')
      @product.update_product_quantity(quantity)

      response = { total_bill: total_amount,product: @product, remaining_amount: current_user.deposit_amount }
      render json: response
    else
      render json: 'Order Amount exceeded your current Amount', status: :unprocessable_entity
    end
  end

  def reset
    if current_user.update(deposit_amount: 0)
      render json: 'Deposit Amount Reset Successfully'
    else
      render json: 'Failed to reset amount', status: :unprocessable_entity
    end
  end

  private

  def deposit_params
    params.require(:user).permit(:deposit_amount)
  end

  def authorize_buyer
    return if current_user.buyer?

    render json: { error: :unauthorized }, status: :unauthorized
  end

  def set_product
    @product = Product.find(params[:product_id])
  end
end
