module StatusesHelper
  def status_context_class( status )
    %w{success info warning danger}[ status.value ]
  end
end
