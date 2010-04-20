class Community < ActiveRecord::Base
  belongs_to :theme
  has_and_belongs_to_many :openings
  has_and_belongs_to_many :users
  has_and_belongs_to_many :organizations

  def feed(limit = nil)

    limit_clause = "LIMIT #{limit}" unless limit.nil?

    sql =<<SQL
                SELECT
                  events.*
                FROM
                  events
                WHERE
                  events.object_id = #{self.id}
                  AND events.object_type = "Community"
              ORDER BY
                created_at DESC
              #{limit_clause}
SQL

    Events::Event.find_by_sql(sql)    
  end

  def ___feed(limit = nil)

    limit_clause = "LIMIT #{limit}" unless limit.nil?

    sql =<<SQL
        (SELECT  
          events.*
        FROM
          communities_users LEFT JOIN events ON (communities_users.user_id = events.subject_id AND events.subject_type = 'User')
        WHERE
          communities_users.community_id = #{self.id})
        UNION
        (
          SELECT
            events.*
          FROM
            events
          WHERE
            events.object_id = #{self.id}
            AND events.object_type = "Community"
        )
        ORDER BY
          created_at DESC
        #{limit_clause}
SQL

    Events::Event.find_by_sql(sql)
  end
end