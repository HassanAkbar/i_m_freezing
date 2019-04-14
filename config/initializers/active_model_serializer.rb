ActiveSupport.on_load(:action_controller) do
  ActiveModelSerializers.config.adapter = :json_api
  ActiveModelSerializers.config.serializer_lookup_enabled = false
end
