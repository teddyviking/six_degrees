module SixDegrees
  class Tweet
    attr_reader :owner, :text
    def initialize(input)
      @owner = input[:owner]
      @text = input[:text]
    end

    def get_tweet_mentions
      #takes the mentions in the text of the tweet
    end
  end


end