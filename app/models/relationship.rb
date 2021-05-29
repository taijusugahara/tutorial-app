class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
             # こいつらは外部キーらしい カラム名
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

end
