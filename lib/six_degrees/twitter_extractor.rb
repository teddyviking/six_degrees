module SixDegrees
  class TwitterExtractor

    def initialize(twitter_class)
      @twitter_class = twitter_class
    end
    
    def get_tweets_from_txt_file(file)
      txt_tweets = IO.readlines(file).map{|tweet| tweet.chomp}
      tweets = txt_tweets.map{|txt_tweet| create_tweet(txt_tweet)}
    end

    def create_tweet(txt_tweet)
      @twitter_class.new(parse_txt_tweet(txt_tweet))

    end

    def parse_txt_tweet(txt_tweet)
      tweet = {}
      divided_text_tweet = txt_tweet.partition(":")
      tweet[:owner] = divided_text_tweet.first
      tweet[:text] = divided_text_tweet.last
      tweet
    end
  end
end