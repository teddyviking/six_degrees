module SixDegrees

  class SixDegreesCalculator
    def initialize
      @active_users = []  
    end

    def generate_six_degrees_file(tweets, ouput_name)
      set_active_users(tweets)
      set_users_tweets(tweets)
      set_users_connections(@active_users)

      output_file(ouput_name, give_format_file)
    end

    private

    def set_active_users(tweets)
      tweets.each do |tweet|
        names_array = @active_users.map {|active_user| active_user.name}
        @active_users << User.new(tweet.owner) unless names_array.include?(tweet.owner)
      end
      @active_users
    end

    def set_users_tweets(tweets)
      @active_users.each {|user| user.get_user_tweets(tweets)}
    end

    def set_users_connections(users)
      n_connection = 0
      while n_connection <= users.first.connections.size
        users.each do |user|
          set_user_connections(user, n_connection, users)
        end
        n_connection += 1
      end
    end

    def set_user_connections(user, index, users)
      if index == 0
        set_user_first_connections(user)
      else
        set_user_left_connections(user, index, users)
      end
    end

    def set_user_left_connections(user, index, users)
      users_left = get_connections_left(user, users)
      users_left.each do |possible_user|
        add_n_connection(user, possible_user, index)
      end
    end

    def get_connections_left(user, users)
      connection_names = user.connections.flatten
      connections = generate_array_of_users_from_names(connection_names)
      users_left = users - connections.push(user)
    end

    def add_n_connection(user, possible_user, index)
      user.connections[index] << possible_user.name if user_is_n_connection?(user, possible_user, index)
    end

    def user_is_n_connection?(original_user, possible_user, index)
      output = false
      original_user_connections = generate_array_of_users_from_names(original_user.connections[index-1])
      original_user_connections.each do |connection|
        output = true if connection.connections[0].include?(possible_user.name)
      end
      output
    end

    def set_user_first_connections(user)
        user_names = user.get_mentioned_users
        possible_users = generate_array_of_users_from_names(user_names)
        possible_users.each do|possible_user| 
          add_first_connection_to_user(user, possible_user)
        end 
    end

    def add_first_connection_to_user(user, possible_user)
      mentioned_users = possible_user.get_mentioned_users
      if mentioned_users.include?(user.name)
        user.connections[0] << possible_user.name unless user.connections[0].include?(possible_user.name)
      end
    end


    def generate_array_of_users_from_names(names)
      names.map{|name| find_active_user_by_name(name) }.compact
    end

    def find_active_user_by_name(name)
      @active_users.find {|u| u.name == name}
    end

    def give_format_file
      output = ""
      @active_users.each do |user|
        output << "#{user.name}\n"
        user.connections.each do |n_connections|
          (output << (n_connections.sort.join(", ") + "\n")) unless n_connections.empty?
        end
        output << "\n"
      end
      output
    end

    def output_file(ouput_name, output)
      IO.write(ouput_name, output)
    end
  end
end