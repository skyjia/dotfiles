# ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__)))
# $: << File.join(ROOT_PATH, 'janus', 'ruby')

task :update do

  puts "Pulling latest changes"
  `git pull`

  puts "Synchronising submodules urls"
  `git submodule sync`

  puts "Updating the submodules"
  `git submodule update --init`
end

desc "Install or Update Dotfiles."
task :default do
  sh "rake update"
end
