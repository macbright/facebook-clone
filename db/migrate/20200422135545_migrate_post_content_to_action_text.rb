class MigratePostContentToActionText < ActiveRecord::Migration[6.0]
  include ActionView::Helpers::TextHelper
  def change
    remove_column :posts, :content
  end
end
