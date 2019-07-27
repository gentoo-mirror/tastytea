config :logger,
  backends: [{ExSyslogger, :ex_syslogger}]

config :logger, :ex_syslogger,
  level: :warn,
  ident: "pleroma",
  format: "$metadata[$level] $message",
  metadata: [:request_id]
