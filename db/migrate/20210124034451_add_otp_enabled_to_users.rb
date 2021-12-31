class AddOtpEnabledToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :use_otp, :bool, default: false
  end
end
