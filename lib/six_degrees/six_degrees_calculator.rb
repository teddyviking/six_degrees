module SixDegrees

  class SixDegreesCalculator
    def initialize
      @active_users = []  
    end

    def generate_six_degrees_file(tweets, ouput_name)
      active_users = get_active_users(tweets)
      first_connections = active_users.map{|user| get_first_connections(user, tweets)}
      output = give_format_file(active_users, first_connections)
      IO.write(ouput_name, output)
    end


    def get_active_users(tweets)
      tweets.map{|tweet| (@active_users << tweet.owner) unless @active_users.include?(tweet.owner)}
      @active_users
    end

    def get_first_connections(user, tweets)
      first_connections = []

      get_mentioned_users(user, tweets).each do |mentioned_user|
        mentioned_users = get_mentioned_users(mentioned_user, tweets)
        first_connections << mentioned_user if mentioned_users.include?(user)
      end
      first_connections
    end

    def get_mentioned_users(user, tweets)
      user_tweets = tweets.select{|tweet| tweet.owner == user}
      mentioned_users = []
      user_tweets.each do |tweet| 
        mentions = tweet.get_tweet_mentions
        mentions.each {|mention|(mentioned_users << mention) unless mentioned_users.include?(mention)}
      end
      mentioned_users
    end

    def give_format_file(active_users, first_connections)
      output = ""
      active_users.each_with_index do |user, index|
        output << "#{user}\n"
        output << (first_connections[index].join(", ") + "\n")
        output << "\n"
      end
      output
    end
  end
end