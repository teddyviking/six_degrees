
require_relative("../lib/six_degrees.rb")


twitter_extractor = SixDegrees::TwitterExtractor.new(SixDegrees::Tweet)
tweets = twitter_extractor.get_tweets_from_txt_file("examples/complex-input.txt")
calculator = SixDegrees::SixDegreesCalculator.new
calculator.generate_six_degrees_file(tweets, "examples/complex-output.txt")