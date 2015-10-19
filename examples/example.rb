require_relative("../lib/six_degrees.rb")


twitter_extractor = SixDegrees::TwitterExtractor.new
tweets = twitter_extractor.get_tweets_from_file("examples/sample_input.txt")
calculator = SixDegrees::SixDegreesCalculator.new
calculator.generate_six_degrees_file(tweets, "output.txt")