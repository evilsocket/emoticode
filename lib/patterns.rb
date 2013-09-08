module Patterns
  extend ActiveSupport::Concern

  SPECIAL_CHARACTERS         = ".-_"
  ALLOWED_CHARACTERS         = "[A-Za-z0-9#{Regexp.escape(SPECIAL_CHARACTERS)}]+"
  ROUTE_PATTERN              = /#{ALLOWED_CHARACTERS}/
  USERNAME_PATTERN           = "[A-Za-z0-9\s#{Regexp.escape('.-_%')}]+"
  ID_PATTERN                 = /[0-9]+/
  CONFIRMATION_TOKEN_PATTERN = /[A-Fa-f0-9]{32}/
end

