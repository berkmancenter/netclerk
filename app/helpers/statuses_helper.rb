module StatusesHelper
  def status_context_class( status )
    %w(danger warning info success)[status.value]
  end
end
