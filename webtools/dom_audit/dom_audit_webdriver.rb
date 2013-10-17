require File.join(File.dirname(__FILE__), "../../webrobot/lib/helper")

url = ENV['WR_URL']
username = ENV['WR_USERNAME']
userpass = ENV['WR_USERPASS']
puts "Arguments passed to webdriver testcode"
puts "url:       " + url
puts "username:  " + username
puts "userpass:  " + userpass

login_url = String.new
if url.split('/')[0] == "http:"
	login_url = url.split('/')[0..2].join('/')
else
	login_url = 'http://' + url.split('/')[0]
end

puts 'login url: ' + login_url

# describe "Fetch all the scripts arguments", :local => true do
	# it "should have a valid url" do
		# ENV['WR_URL'].should_not == nil			
	# end
	# it "should know what it will be logged in as" do
		# ENV['WR_login'].should_not == nil			
	# end
# end

describe "Inspect the webpage to scrape the DOM object", :local => true do
	it "should find the dom object for the html node" do		
		wr_p "Logging in"
		wr_d "Opening webpage"
		@selenium.navigate.to login_url
		#@selenium.navigate.to "http://10.10.9.129"   
		#@selenium.navigate.to "http://www.google.ca"   
		
		wr_d "Finding login element"
		@selenium.find_element(:id, "loginnameid-inputEl").send_keys username
		
		wr_d "Finding password element"
		@selenium.find_element(:id, "loginpasswordid-inputEl").send_keys userpass
		
		wr_d "Finding  submit element"
		@selenium.find_element(:id, "loginbuttonid-btnIconEl").click
		sleep 5
		begin
			@selenium.navigate.to url
		rescue
			wr_p "----->    MAKE SURE URL IS CORRECT. Eg: http://10.10.9.129/LocalAdmin/index.php"
		end
		
		begin
			wr_p "Requesting DOM object"
			wait_for_it = Selenium::WebDriver::Wait.new(:timeout => 120 )
			wait_for_it.until { @selenium.find_element(:id, "logout_btn-btnIconEl") }
		rescue
			wr_p "----->   MAKE SURE YOUR USER/PASSWORD IS CORRECT"
		end
		
		wr_d "Finding html element"
		html_element = @selenium.find_element(:tag_name, "html")
		
		# wr_p "forcing window.stop() javascript call"
		# @selenium.execute_script("window.stop();")
		
		wr_d "Dumping DOM object to STDOUT"
		html_object = @selenium.execute_script("return arguments[0].innerHTML;", html_element)
		#wr_p html_object
		
		wr_p "Parsing the DOM structure for each ID"
		element_array = html_element.find_elements(:xpath, ".//*");
		
		wr_p "Found the fllowing dynamic IDs"
		#collected_attributes = element_array.collect {|e| e.attribute("id") }
		
		# collected_attributes.each do |e|
			# if e.match("[0-9]{4,4}")
				# wr_tag(e,"STATIC")
			# end
		# end
		element_array.each do |e|
			begin
				if e.attribute("id").match("[0-9]{4,4}")
					wr_tag(e.attribute("id"),"STATIC")
				end					
			rescue Timeout::Error, Selenium::WebDriver::Error::StaleElementReferenceError
				wr_p "ERROR: Retrieval of attribute object timed out."
				wr_p "The reason could be that the js is looping unexpectedly behind the scene (JS bug), or that the page changed during the search"			
				break
			end
		end
		
	end
	
end