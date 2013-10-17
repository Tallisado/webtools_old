require File.join(File.dirname(__FILE__), "../../webrobot/lib/helper")

url = 'http://10.10.9.129/LocalAdmin/index.php'
username = '3011'
userpass = '1234'


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

describe "test the xpath", :local => true do
	it "should return xpath text" do		
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

		@selenium.find_element(:id, "editOperatorMembership_wiz").click
		sleep 5
		#editOperatorMembership_wiz
		
		#xpath to click element
		@selenium.find_element(:xpath, "//table/tbody/tr[16]/td/div[contains(text(),'Wendy')]").click
		#@selenium.find_element(:xpath, "/html/body/div[6]/div[2]/div/div[2]/div/div/div/div/div/div/span/div/div/div/div/div/div[4]/div/table/tbody/tr[16]/td/div").click
		
		#xpath to text element
		puts "text is " + @selenium.find_element(:xpath, "//table/tbody/tr[16]/td/div[contains(text(),'Wendy')]").text
		
	end
	
end