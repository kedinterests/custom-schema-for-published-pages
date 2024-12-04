# frozen_string_literal: true

# Plugin metadata
# name: custom-schema-for-published-pages
# about: Adds custom schema markup to specific published pages
# version: 0.1
# authors: Your Name
# url: https://github.com/yourname/custom-schema-for-published-pages

enabled_site_setting :schema_pages_enabled

Rails.logger.info("Custom Schema Plugin: Initializing...")

after_initialize do
  Rails.logger.info("Custom Schema Plugin: After initialize block started.")

  # Register custom fields
  register_topic_custom_field_type("is_published_page", :boolean)
  register_topic_custom_field_type("schema_type", :string)

  Rails.logger.info("Custom Schema Plugin: Custom fields registered.")

  # Add custom schema to TopicViewSerializer
  add_to_serializer(:topic_view, :schema_markup) do
    Rails.logger.info("Custom Schema Plugin: Adding schema markup to serializer.")
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

  Rails.logger.info("Custom Schema Plugin: Serializer customization complete.")
end

Rails.logger.info("Custom Schema Plugin: Initialization complete.")