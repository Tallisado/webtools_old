require 'rake'
require 'stringio'
require 'yaml'

#TMP
require 'etc'

@uuid = ARGV[0]
@url = ARGV[1]
@username = ARGV[2]
@userpass = ARGV[3]

# puts ENV.inspect
# puts "user: "
# puts Etc.getlogin

puts "-- DOM AUDIT PARSER --"
puts " uuid: #{@uuid}"
puts " url: #{@url}"
puts " username: #{@username}"
puts " userpass: #{@userpass}"
puts "----------------------"

def silence_stdout
	orig_std_out = STDOUT.clone
  # $stdout = File.new( '/dev/null', 'w' )
	$stdout.reopen("./results/#{@uuid}_stdout.tmp", "a")
	#$stdout.sync = true
  yield
ensure
  $stdout.reopen(orig_std_out)
end

def read_yaml_file(file)
	if File.exist?(file)
		 return YAML::load(File.read(file))
	end
	raise "-- ERROR: config YAML file doesn't exist: " + file
end

puts "Reading configuration file"
@CONFIG = read_yaml_file("./config.yaml")
puts " (CONFIG) filter = " + @CONFIG['filter']
puts " (CONFIG) exclude = " + @CONFIG['exclude']


project_dir = File.expand_path('../..',File.dirname(__FILE__))
#puts 'ASDASDASD' + gem_dir

ENV['FILE'] = "#{project_dir}"+@CONFIG['dom_audit_webtester_rb']
ENV['WR_DEBUG'] = 'on'

Rake.application.init
Rake.application.load_rakefile

puts "Executing rake"
silence_stdout {
Rake.application['custom:domaudit'].invoke(@url, @username, @userpass)
#Rake.application['local:nofixtures:headed'].reenable
#Rake.application['spec:sauce'].invoke
}

puts " YOU MISSED THE FOLLOWING STATIC STRINGS"
staticid_array = []
exclude_me = false
File.open("./results/#{@uuid}_stdout.tmp").each do |line|
	if line.match("^[STATIC]*")
		@CONFIG['filter'].split(',').each do |filter_word|
			if (line.include?(filter_word))
			  puts "--- FOUND INC: " + line
				@CONFIG['exclude'].split(',').each do |exclude_word|
					if line.include?(exclude_word)
						exclude_me = true			
					end
				end
				if !exclude_me
					puts "FOUND MISSING STATIC: " + line
					staticid_array.push(line[9,line.length])
				end
				exclude_me = false
			end
		end
	end
end
#File.delete("#{@uuid}_stdout.tmp")

fileHtml = File.new("./results/#{@uuid}_dom_audit.html", "w")
fileHtml.puts "<HTML>"
fileHtml.puts "<CENTER>Audit - Missing IDs!</CENTER>"
fileHtml.puts "<BODY>"
staticid_array.each do |audited_item|
	fileHtml.puts "<p><code>#{audited_item.to_s}</code></p>" 
end

fileHtml.puts "</BODY></HTML>"
fileHtml.close()


