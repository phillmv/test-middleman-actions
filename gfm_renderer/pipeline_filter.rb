require_relative 'pipeline_filter/markdown_filter'
require_relative 'pipeline_filter/hashtag_filter'
require_relative 'pipeline_filter/mention_filter'
require 'task_list/filter'

module PipelineFilter
  # we just want to tweak the default whitelist a little bit
  # and allow the data-sourcepos attribute to go thru
  # without this change the data-sourcepos gets stripped
  ENTRY_SANITIZATION_WHITELIST = HTML::Pipeline::SanitizationFilter::WHITELIST.dup
  ESW = ENTRY_SANITIZATION_WHITELIST
  ESW[:attributes] = ESW[:attributes].dup
  ESW[:attributes][:all] = ESW[:attributes][:all].dup
  ESW[:attributes][:all].push("data-sourcepos")

  # nota bene:
  # must use MarkdownFilter with unsafe
  # which means must use SanitizationFilter
  # which means must not have CommonMarker insert TaskLists and
  # instead must have a filter transform AFTER sanitization

  ENTRY_PIPELINE = HTML::Pipeline.new [
    PipelineFilter::MarkdownFilter, # convert to HTML
    HTML::Pipeline::SanitizationFilter, # strip scary tags
    TaskList::Filter,
    PipelineFilter::HashtagFilter, # link hashtags
    PipelineFilter::MentionFilter, # link mentions
    HTML::Pipeline::TableOfContentsFilter, # add ids to headers
    HTML::Pipeline::ImageMaxWidthFilter, # max 100% for imgs
  ], { unsafe: true,
       commonmarker_render_options: [:SOURCEPOS],
       whitelist: ENTRY_SANITIZATION_WHITELIST
  }

end
