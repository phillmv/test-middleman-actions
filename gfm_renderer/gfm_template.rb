require_relative 'pipeline_filter'

class GFMTemplate < ::Tilt::Template
  def prepare
    @engine = nil
    @output = nil
  end

  def evaluate(scope, locals, &block)
     PipelineFilter::ENTRY_PIPELINE.to_html(data, {})
  end
end
