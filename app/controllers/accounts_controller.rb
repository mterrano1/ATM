class AccountsController < ApplicationController
  before_action :set_account, only: [:show]
  
  def show
    # Ensure the current user can only view their own account
    unless @account && @account.user == @current_user
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def create
    # Ensure the current user doesn't already have an account
    if @current_user.account.nil?
      account = @current_user.build_account(balance: 1000000)

      if account.save
        render json: account, status: :created
      else
        render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["User already has an account"] }, status: :unprocessable_entity
    end
  end

  def update
    # Ensure the current user can only update their own account balance
    if @account && @account.user == @current_user
      amount = params[:amount].to_i
      withdrawal = withdraw(amount)

      if withdrawal.nil?
        render json: { errors: ["Invalid withdrawal amount"] }, status: :unprocessable_entity
      else
        # Update account balance
        @account.balance -= amount
        if @account.save
          render json: { hundreds: withdrawal[0], fifties: withdrawal[1], twenties: withdrawal[2] }, status: :ok
        else
          render json: { errors: ["Invalid withdrawal amount"] }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_account
    @account = @current_user.account
  end

  def withdraw(amount)
    hundreds = 0
    fifties = 0
    twenties = 0
    remainder = amount

    if amount < 100 && amount % 20 == 0
      twenties = amount / 20
      return [hundreds, fifties, twenties]
    end

    if amount >= 100
      hundreds = amount / 100
      remainder %= 100 
    end

    if remainder == 10 || remainder == 30
      hundreds -= 1
      remainder += 100
      fifties = remainder / 50
      remainder %= 50
    else
      fifties = remainder / 50
      remainder %= 50
    end

    if remainder % 20 != 0
      fifties -= 1
      remainder += 50
      twenties = remainder / 20
    end

    [hundreds, fifties, twenties]
  end
end