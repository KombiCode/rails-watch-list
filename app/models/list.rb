class List < ApplicationRecord
  has_many :bookmarks
  has_many :movies, through: :bookmarks, :dependent => :destroy
  
  validates :name, presence: true
  validates :name, uniqueness: true

  after_create_commit { broadcast_append_to "lists" }
  after_update_commit { broadcast_replace_to "lists" }
  after_destroy_commit { broadcast_remove_to "lists" }
end
