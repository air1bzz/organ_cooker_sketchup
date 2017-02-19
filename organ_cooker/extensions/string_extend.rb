require_relative '../BO/note'

##
# Implementation of Ruby core {http://ruby-doc.org/core-2.3.1/String.html String}
# class in order to access OrganCooker::Note objects.
class String
  ##
  # Converts string to +music note+ object
  # @return [OrganCooker::Note]
  # @api public
  # @example
  #   n = "a#1".to_note #=> A#1
  #   n.class           #=> OrganCooker::Note
  def to_note
    Note.new(self)
  end

  ##
  # Returns the next note
  # @api public
  # @return [String] a string of next note
  # @example
  #   n = OrganCooker::Note.new("g#1") #=> G#1
  #   n.next_note                      #=> "A1"
  def next_note
    Note.new(self).succ.to_s
  end

  ##
  # Returns the previous note
  # @api public
  # @return [String] a string of previous note
  # @example
  #   n = OrganCooker::Note.new("g#1") #=> G#1
  #   n.prev_note                      #=> "G1"
  def prev_note
    Note.new(self).prev.to_s
  end
end
