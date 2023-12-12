class CreateClientApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :client_applications do |t|
      t.string :name
      t.string :client_id
      t.string :client_secret
      t.string :authorization_code
      t.string :access_token
      t.string :refresh_token
      t.string :redirect_uris, array: true
      t.datetime :expires_in
      t.string :scopes, array: true
      t.string :grant_type

      t.timestamps
    end
  end
end
