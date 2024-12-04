# frozen_string_literal: true

# Plugin metadata
# name: custom-schema-for-published-pages
# about: Adds custom schema markup to specific published pages
# version: 0.1
# authors: Your Name
# url: https://github.com/yourname/custom-schema-for-published-pages

enabled_site_setting :schema_pages_enabled

after_initialize do
  # Register custom fields
  register_topic_custom_field_type("is_published_page", :boolean)
  register_topic_custom_field_type("schema_type", :string)

  # Add custom schema to TopicViewSerializer
  add_to_serializer(:topic_view, :schema_markup) do
	next unless object.topic.custom_fields["is_published_page"]

	schema_type = object.topic.custom_fields["schema_type"]
	template = case schema_type
			   when "Article"
				 "schema/article_schema"
			   when "FAQPage"
				 "schema/faq_schema"
			   when "Event"
				 "schema/event_schema"
			   when "Directory"
				 "schema/directory_schema"
			   else
				 "schema/default_schema"
			   end

	# Render the appropriate schema template
	render_template(template, topic: object.topic)
  end

  # Extend TopicViewSerializer to expose `schema_type` field for admin UI
  add_to_serializer(:topic_view, :schema_type) do
	object.topic.custom_fields["schema_type"]
  end

  # Extend TopicViewSerializer to expose `is_published_page` field for admin UI
  add_to_serializer(:topic_view, :is_published_page) do
	object.topic.custom_fields["is_published_page"]
  end
end