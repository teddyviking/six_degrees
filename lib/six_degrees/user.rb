module SixDegrees
  class User
    attr_accessor :first_connections, :second_connections
    attr_reader :tweets, :name

    def initialize(name)
      @name = name
      @first_connections = []
      @second_connections = []
    end

    def get_user_tweets(tweets)
      @tweets = tweets.select{|tweet| tweet.owner == @name}
    end

    def get_mentioned_users
      @mentioned_users = []
      if @mentioned_users.empty?
        tweets.each do |tweet| 
          mentions = tweet.get_tweet_mentions
          mentions.each {|mention|(@mentioned_users << mention) unless @mentioned_users.include?(mention)}
        end
      end
      @mentioned_users
    end
  end
end