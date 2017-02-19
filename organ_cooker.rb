require 'sketchup.rb'
require 'extensions.rb'

module Air1bzz
  module OrganCooker
    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Organ Cooker', 'organ_cooker/main')
      ex.description = 'Tools for drawing organ pipes.'
      ex.version     = '1.0.0'
      ex.copyright   = 'Erwan MORVAN © 2016'
      ex.creator     = 'Erwan MORVAN'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end
  end
end
