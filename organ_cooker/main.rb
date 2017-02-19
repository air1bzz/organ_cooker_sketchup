# Copyright 2016 Trimble Navigation Limited
# Licensed under the MIT license

require 'sketchup.rb'
require_relative 'app_ui'

module Air1bzz
  module OrganCooker
    include AppUI

    unless file_loaded?(__FILE__)
      menu = UI.menu
      menu.add_item('Organ Cooker') {
        SKETCHUP_CONSOLE.show
        AppUI.run
        UI.messagebox('BYE')
      }
      file_loaded(__FILE__)
    end
  end
end
