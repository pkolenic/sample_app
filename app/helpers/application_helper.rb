module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Fear The Fallen - Elder Scrolls Online"
    if page_title.empty?
    base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def random_image
    files = Dir.glob("app/assets/images/backgrounds/*")
    "#{ image_url files.shuffle.first.gsub('app/assets/images/', '')}"
  end
end
