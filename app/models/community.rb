class Community < ActiveRecord::Base
  belongs_to :theme
  has_and_belongs_to_many :openings
  has_and_belongs_to_many :users

  def feed(limit = nil)

    limit_clause = "LIMIT #{limit}" unless limit.nil?

    sql =<<SQL
        SELECT  
          events.*
        FROM
          communities_users LEFT JOIN events ON (communities_users.user_id = events.subject_id)
        WHERE
          communities_users.community_id = #{self.id}
        #{limit_clause}
SQL

    Events::Event.find_by_sql(sql)
  end
end