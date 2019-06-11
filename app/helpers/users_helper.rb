module UsersHelper
  def gravatar_for user, size: Settings.size_gravatar
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "#{Settings.link.gavatar}#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def build_active_relation_build
    current_user.active_relationships.build
  end

  def find_by_id_active_relation_build id
    current_user.active_relationships.find_by(followed_id: id)
  end
end
