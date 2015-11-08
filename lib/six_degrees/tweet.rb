module SixDegrees
  class Tweet
    attr_reader :owner, :text
    def initialize(input)
      @owner = input[:owner]
      @text = input[:text]
    end

    def get_tweet_mentions
      mentions = @text.scan(/@\w+/)
      mentions.map{|mention| mention.gsub(/@/, "")}
    end
  end


end