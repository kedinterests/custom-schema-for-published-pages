# name: schema-pages
# about: Add custom schema markup to specific published pages
# version: 0.2
# authors: ChatGPT - prompted by: Chris Malone
# url: https://github.com/yourname/schema-pages

enabled_site_setting :schema_pages_enabled

after_initialize do
  # Register a custom field for schema type
  register_topic_custom_field_type("schema_type", :string)

  # Add schema markup dynamically based on topic ID or schema_type field
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
			   else
				 "schema/default_schema"
			   end

	render_template(template, topic: object.topic)
  end

  # Add admin serializer to include schema_type field
  add_to_class(:admin_serializers_topic_view_serializer, :schema_type) do
	object.topic.custom_fields["schema_type"]
  end
end