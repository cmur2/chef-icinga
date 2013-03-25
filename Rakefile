
# try to use foodcritic
begin
  require 'foodcritic'

  FoodCritic::Rake::LintTask.new do |task|
    task.options = { :fail_tags => [ 'any' ], :tags => [ '~FC005' ] }
  end

  task :default => [ :foodcritic ]
rescue LoadError
  task :default => []
end
