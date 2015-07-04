module Common
  def Common.find_or_start_browser(title, url)
    begin
      browser = Watir::IE.attach(:title, title)
      browser.goto(url)
    rescue Watir::Exception::NoMatchingWindowFoundException
      browser = Common.start_new_browser(url)
    end
    return browser
  end

  def Common.start_new_browser(url)
    browser = Watir::IE.start(url)
    browser.speed = :fast
    return browser
  end

  def Common.close_browsers(titles)
    for title in titles
      Common.close_browser(title)
    end
    return true
  end

  def Common.close_browser(title)
    begin
      browser = Watir::IE.attach(:title, title)
      browser.close
    rescue Watir::Exception::NoMatchingWindowFoundException
    end
    return true
  end

end