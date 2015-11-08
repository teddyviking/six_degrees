module SixDegrees

  class SixDegreesCalculator
    def initialize
      @active_users = []  
    end

    def generate_six_degrees_file(tweets, ouput_name)
      set_active_users(tweets)
      set_users_tweets(tweets)
      set_users_first_connections


      output = give_format_file
      IO.write(ouput_name, output)
    end


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

    def set_users_first_connections
      @active_users.each do |active_user|
        user_names = active_user.get_mentioned_users
        possible_users = generate_array_of_users_from_names(user_names)
        possible_users.each do|possible_user| 
          add_first_connection_to_user(active_user, possible_user)
        end 
      end
    end

    def add_first_connection_to_user(user, possible_user)
      mentioned_users = possible_user.get_mentioned_users
      if mentioned_users.include?(user.name)
        user.first_connections << possible_user.name 
      end
    end


    def generate_array_of_users_from_names(names)
      names.map{|name| find_active_user_by_name(name) }
    end

    def find_active_user_by_name(name)
      @active_users.find {|u| u.name == name}
    end

    def give_format_file
      output = ""
      @active_users.each do |user|
        output << "#{user.name}\n"
        output << (user.first_connections.join(", ") + "\n")
        output << "\n"
      end
      output
    end
  end
end