module SlackMessageServices
  class SendErrorMessage < Base
    def self.call
      content = "Hix, bị lỗi gì nên hông đặt được cơm rồi. Thử lại hoặc đặt thủ công nha!"
      send_message(content)
    end
  end
end
