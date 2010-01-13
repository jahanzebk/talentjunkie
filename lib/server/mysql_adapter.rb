  class MysqlAdapter

    def initialize(connection, options)
      @connection, @options = connection, options
      connect
    end
    
    
    # Executes a SQL query and returns a MySQL::Result object. Note that you have to free the Result object after you're done using it.
    def execute(sql, name = nil) #:nodoc:
      @connection.query(sql)
    end
    
    def insert_sql(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil) #:nodoc:
      execute(sql, name)
      @connection.insert_id
    end
    
    def query(sql)
      @connection.query(sql)
    end
    
    def first(sql)
      result = query(sql)
      return nil if result.num_rows == 0
      result.each do |row|
        return row
      end
    end
  
    # CONNECTION MANAGEMENT ====================================

    def active?
      if @connection.respond_to?(:stat)
        @connection.stat
      else
        @connection.query 'select 1'
      end

      # mysql-ruby doesn't raise an exception when stat fails.
      if @connection.respond_to?(:errno)
        @connection.errno.zero?
      else
        true
      end
    rescue Mysql::Error
      false
    end

    def reconnect!
      disconnect!
      connect
    end

    def disconnect!
      @connection.close rescue nil
    end

    def reset!
      if @connection.respond_to?(:change_user)
        # See http://bugs.mysql.com/bug.php?id=33540 -- the workaround way to
        # reset the connection is to change the user to the same user.
        @connection.change_user(@config[:username], @config[:password], @config[:database])
        configure_connection
      end
    end
    
  
    private
    
    def connect
      @connection.real_connect(*@options)

      # reconnect must be set after real_connect is called, because real_connect sets it to false internally
      @connection.reconnect = true if @connection.respond_to?(:reconnect=)

      configure_connection
    end

    def configure_connection
      # By default, MySQL 'where id is null' selects the last inserted id.
      # Turn this off. http://dev.rubyonrails.org/ticket/6778
      execute("SET SQL_AUTO_IS_NULL=0")
      # execute("SET WAIT_TIMEOUT=3")
    end  

  end
  
