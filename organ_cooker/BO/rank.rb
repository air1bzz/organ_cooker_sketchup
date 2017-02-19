require_relative 'pipe'

class RankTypeFlute
    ##
    # The +toe holes+ of the rank
    # @overload toe_holes
    #   Gets the current toe holes
    #   @api public
    # @overload toe_holes=(value)
    #   Sets the new toe holes
    #   @api public
    #   @param value [Array<Integer>, Nil] the new toe holes
    # @return [Array<Integer>, Nil] the toe holes
    attr_accessor :toe_holes

    ##
    # The +windchest+ the rank belongs to
    # @overload windchest
    #   Gets the current windchest
    #   @api public
    # @overload windchest=(value)
    #   Sets the new windchest
    #   @api public
    #   @param value [OrganCooker::Windchest] the new windchest
    # @return [OrganCooker::Windchest] the windchest
    attr_accessor :windchest

    ##
    # The +project+ the rank belongs to
    # @overload project
    #   Gets the current project
    #   @api public
    # @overload project=(value)
    #   Sets the new project
    #   @api public
    #   @param value [OrganCooker::project] the new project
    # @return [OrganCooker::project] the project
    attr_accessor :project

    ##
    # Sets the new +name+ of the rank
    # @api public
    # @param value [String] the new name
    # @return [string]
    attr_writer :name

    ##
    # Sets the new height
    # @api public
    # @param value [String] the new height
    # @return [String] the height
    attr_writer :height

    ##
    # Sets the new diameter
    # @api public
    # @param value [Integer] the new diameter
    # @return [Integer] the diameter
    attr_writer :size

    ##
    # Sets the new progression
    # @api public
    # @param value [Float] the new progression
    # @return [Float] the progression
    attr_writer :prog

    ##
    # Sets the new first note
    # @api public
    # @param value [Float] the new first note
    # @return [Float] the first note
    attr_writer :first_note

    ##
    # The current harmonic +progression+ changes
    # @param value [Hash{note: OrganCooker::Note, prog: Float, size: Integer}, Nil] the new progression changes
    # @return [Hash{note: OrganCooker::Note, prog: Float, size: Integer}, Nil] the progression changes
    # @api public
    attr_writer :prog_change

    ##
    # Initialize a +flute-type rank+ object
    # @param name [String] a name (ex: "montre")
    # @param height [String] the height (in feet) for the lowest pipe (ex: "4", "2 2/3")
    # @param size [Integer] the size (internal diameter) for the lowest pipe
    #   (ex: 145)
    # @param progression [Numeric] the progression
    # @param windchest_object [OrganCooker::WindChest] the windchest object that
    #   the rank belongs to
    # @param project_object [OrganCooker::Project] the project object that the
    #   rank belongs to
    # @param first_note [OrganCooker::Note] (optional) the lowest note (if different than
    #   the windchest's one)
    # @param prog_change [Hash{note: OrganCooker::Note, prog: Float, size: Integer}, Nil] (optional) the note where progression is changing
    # @example
    #   w = OrganCooker::WindChest.new("grand-orgue", 56, OrganCooker::Note.new("c0"))
    #   p = OrganCooker::Project.new("mantes-la-jolie", 15, 435)
    #   r = OrganCooker::RankTypeFlute.new("montre", "8", 145, 6, w, p, first_note: OrganCooker::Note.new("c2"))
    def initialize(name, height, size, progression, windchest_object, project_object, first_note: windchest_object.first_note, prog_change: nil)
      @name        = name
      @height      = height
      @size        = size
      @prog        = progression
      @windchest   = windchest_object
      @project     = project_object
      @first_note  = first_note
      @prog_change = prog_change
    end

    ##
    # Returns rank +name+ with +height+
    # @api public
    # @return [String] the name of the rank
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", r, p, first_note: "C2")
    #   r.full_name #=> "Grosse Tierce 1' 3/5"
    def full_name
      name = @name.gsub(/[[:alpha:]]+/, &:capitalize)

      if @height.include? '/'
        numbers = digits_scan(@height).map(&:to_i)
        "#{name} #{numbers[0]}'#{numbers[1]}/#{numbers[2]}"
      else
        "#{name} #{@height}'"
      end
    end

    ##
    # Returns an array of notes +frequencies+
    # @api public
    # @return [Array<Float>] the frequency of each note
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, first_note: "C2")
    #   r.frequencies #=> [654.06, 692.96, 734.16, 777.82, 824.07, 873.07, 924.99...]
    def frequencies
      notes_range.to_a.map { |note| note.frequency(diapason: @project.diapason, height: @height).round(2) }
    end

    ##
    # Returns an array of +lengths+ for each pipes
    # @api public
    # @return [Array<Integer>] the length of each note
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, first_note: "C2")
    #   r.lengths #=> [654.06, 692.96, 734.16, 777.82, 824.07, 873.07, 924.99...]
    def lengths
      frequencies.map { |frequency| (@project.speed_of_sound / (frequency * 2) * 1000).round(0) }
    end

    ##
    # Returns an array of +sizes+ (internal diameters).
    # @api public
    # @return [Array<Integer>] the length of each note
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, first_note: "C2")
    #   r.sizes #=> [50, 48, 47, 45, 44, 42, 41, 40, 38, 37, 36, 35...]
    def sizes
      h_sizes   = [@size]
      prog      = @prog
      add_sizes = proc { h_sizes << h_sizes.last / prog.to_f**(1.0 / 48) }
      nb_notes  = notes_range.to_a.size

      if @prog_change.nil?
        (nb_notes - 1).times(&add_sizes)
      elsif !@prog_change[:note].nil?
        nb_notes = (notes_range.min.succ..@prog_change[:note]).to_a.size
        nb_notes.times(&add_sizes)

        prog = @prog_change[:prog].to_f
        unless @prog_change[:size].nil?
          h_sizes.pop
          h_sizes << @prog_change[:size]
        end
        nb_notes = (@prog_change[:note].succ..notes_range.max).to_a.size
        nb_notes.times(&add_sizes)
      end
      h_sizes.map { |size| size.round(0) }
    end

    ##
    # Returns an array of rank's +notes+
    # @api public
    # @return [Array<String>] the music notes
    # @example will return notes from A1 (rank) to C2 (windchest's 13th note)
    #   w = OrganCooker::WindChest.new("grand-orgue", "13", "C1")
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   f = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, "A1")
    #   f.notes #=> ["A1", "A#1", "B1", "C2"]
    def notes
      notes_range.to_a.map(&:to_s)
    end

    def draw
      center = Geom::Point3d.new([0,0,0])
      sizes = self.sizes
      height = @windchest.foot_height
      toe_holes = self.toe_holes
      lengths = self.lengths

      @windchest.nb_notes.times do |i|
        pipe = Pipe.new(sizes[i], height, toe_holes[i], lengths[i])
        pipe.draw(center)
        center.x += (sizes[i] + 5).mm
      end
    end

    private

    ##
    # Returns a +Range+ object from first rank note to last windchest note
    # @api private
    # @return [Range] the music notes range
    # @example
    #   r = OrganCooker::Note.new("c3")..OrganCooker::Note.new("G#6") #=> C3..G#6
    #   r.class #=> Range
    #   r.to_a.size #=> 45
    def notes_range
      (@first_note..@windchest.last_note)
    end

    ##
    # Returns an array of numbers
    # @api private
    # @param [String]
    # @return [Array] an array of numbers
    # @example
    #   string = "4 5 78 7.5 54 12"
    #   digits_scan(string) #=> ["4", "5", "78", "7.5", "54", "12"]
    def digits_scan(string)
      string.scan(/[[:digit:]]+\.?[[:digit:]]*/)
    end
  end
