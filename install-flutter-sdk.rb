require 'optparse'
require 'etc'

options = {}
OptionParser.new do |opt|
  opt.on('--channel CHANNEL') { |o| options[:channel] = o }
end.parse!

channel = options[:channel] || 'stable'

flutter_path = File.join(ENV['GITHUB_ACTION_PATH'], flutter)
flutter_repo_address = "https://github.com/flutter/flutter.git"

`git clone -b #{channel} #{flutter_repo_address} #{flutter_path}`

flutter_bin_path = File.join(flutter_path, 'bin')
dart_bin_path = File.join(flutter_path, 'bin', 'cache', 'dart-sdk', 'bin')
pub_cache_path = File.join(ENV['HOME'], '.pub-cache', 'bin')

pub_cache_path = File.join(ENV['LOCALAPPDATA'], 'Pub', 'Cache', 'bin') if Etc.uname[:sysname] == 'Windows_NT'

ENV['GITHUB_PATH'] += "#{flutter_bin_path}\n"
ENV['GITHUB_PATH'] += "#{dart_bin_path}\n"
ENV['GITHUB_PATH'] += "#{pub_cache_path}\n"
