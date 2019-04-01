require 'puma/plugin/yabeda'

workers 2
threads 1, 1
activate_control_app
plugin 'yabeda'
