class AddClientTypeToClientApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :client_applications, :client_type, :string
  end
end
