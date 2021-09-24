require "selenium-webdriver"
require "webdrivers"
require "byebug"

# from
def departure_station
  ARGV[0]
end
# to
def destination_station
  ARGV[1]
end

def set_options
  ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36"
  user_profile_path = "/Users/tomoakimukaiyama/Library/Application Support/Google/Chrome/Default"
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions" => {
          "args" => [
              "--user-agent=#{ua}",
              "--headless"
          ]
      }
  )
  capabilities
end

def get_distance(options, departure_station, destination_station)
  url =  "https://www.google.co.jp/maps/dir/#{departure_station}/#{destination_station}"
  driver = Selenium::WebDriver.for(:chrome, desired_capabilities: options)
  driver.manage.timeouts.implicit_wait = 5
  driver.get(url)
  sleep 1
  p "----------------------------------------"
  p "Google Map: #{driver.current_url}"
  info_arr = driver.execute_script('''
    info_arr = [];
    if (document.getElementById("section-directions-trip-travel-mode-0")){
      var card_icons = document.querySelectorAll("[id|=section-directions-trip-travel-mode]")
      card_icons.forEach(icon=>
        info_arr.push([icon.parentElement.innerText, icon.getAttribute("aria-label")])
        )
    } else {
      info_arr = "取得失敗"
    }
    
    return info_arr;
    ''')
    # byebug
    p "----------------------------------------"
  info_arr.each do |info|
    p info[1]
    info[0].split("\n").each {|a|p a}
    p "----------------------------------------"
  end
end
get_distance(set_options, departure_station, destination_station)
