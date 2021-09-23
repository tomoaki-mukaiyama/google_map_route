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
  route_info = driver.execute_script('''

    info_arr = [];
    if (document.getElementById("section-directions-trip-travel-mode-0")){
      var card_icon = document.getElementById("section-directions-trip-travel-mode-0")
      var route_info = card_icon.parentElement.innerText;
      var icon_info = card_icon.getAttribute("aria-label")
      info_arr.push(route_info, icon_info);
      
    } else {
      info_arr = "取得失敗"
    }
    
    return info_arr;
    ''')
    info_arr = route_info[0].split("\n")
    p "----------------------------------------"
    info_arr.each{|a|p a}
    p "----------------------------------------"
    if (route_info[1] === "  公共交通機関  ")
      time = Time.now.strftime("%H:%M")
      p "現在時刻 : #{time}"
      
      departure_time = info_arr[1].split(" ")[0].split(":")[1].to_i - time.split(":")[1].to_i
      if (departure_time.to_i < 0)
        departure_time = departure_time.to_i + 60
      end
    p "出発まで#{departure_time}分"
    p "----------------------------------------"
  end
end
get_distance(set_options, departure_station, destination_station)
