# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.string :username, unique: true
      t.string :name
      t.string :slug
      t.boolean :admin, default: false

      t.boolean :superadmin_role, default: false
      t.boolean :supervisor_role, default: false
      t.boolean :user_role, default: true

      t.timestamps null: false
    end

    # Create a default user
    User.create!(username: 'admin', name: 'Admin User', 
      email: 'admin@example.com', password: 'testPwd996', password_confirmation: 'testPwd996',
      superadmin_role: true, supervisor_role: true)

    add_index :users, :email,                unique: true
    add_index :users, :username,             unique: true
    add_index :users, :slug,                 unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end
end
