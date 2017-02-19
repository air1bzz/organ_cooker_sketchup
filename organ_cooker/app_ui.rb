require_relative 'BO/project'
require_relative 'BO/windchest'
require_relative 'BO/rank'
require_relative 'BO/note'
require_relative 'extensions/string_extend'

module AppUI

  def self.run
    project = AppUI.project_menu
    windchest = AppUI.windchest_menu
    rank = AppUI.rank_menu(project, windchest)
    rank.toe_holes = AppUI.set_toe_holes(rank)


    rank.draw
  end

  def self.project_menu
    prompts  = ['Nom :',
                'Température :',
                'Diapason :']
    defaults = ['St Ouen de Rouen',
                '18',
                '400']
    inputs = UI.inputbox(prompts, defaults, "Définir le projet")

    name = inputs[0]
    temp = inputs[1].to_f
    diap = inputs[2].to_f

    Project.new(name, temp, diap)
  rescue => ex
    UI.messagebox(ex.message)
    retry
  end

  def self.windchest_menu
    prompts  = ['Nom :',
                'Nombre de notes :',
                'Première note :',
                'Hauteur des pieds :']
    defaults = ['Récit',
                '56',
                'C1',
                '200']
    inputs = UI.inputbox(prompts, defaults, "Définir le sommier")

    name = inputs[0]
    nb_notes = inputs[1].to_i
    first_note = inputs[2].to_note
    foot_height = inputs[3].to_f

    WindChest.new(name, nb_notes, first_note, foot_height)
  rescue => ex
    UI.messagebox(ex.message)
    retry
  end

  def self.rank_menu(project, windchest)
    prompts  = ['Nom :',
                'Nb de pieds :',
                'Taille départ :',
                'Progression :']
    defaults = ['Montre',
                '16',
                '145',
                '8',]
    inputs = UI.inputbox(prompts, defaults, "Définir le jeu")

    name = inputs[0]
    height = inputs[1]
    size = inputs[2].to_f
    prog = inputs[3].to_f

    RankTypeFlute.new(name, height, size, prog, windchest, project)
  rescue => ex
    UI.messagebox(ex.message)
    retry
  end

  def self.set_toe_holes(rank)
    holes = []
    nb_notes = rank.notes.count
    octaves  = nb_notes.to_f / 12
    octaves  = octaves.ceil
    first    = 0
    defaults = Array.new(12, "4")
    title    = "Perces Octave 1"

    octaves.times do
      last    = first + 12
      prompts = rank.notes[first...last]
      holes_per_oct = UI.inputbox(prompts, defaults, title)
      holes << holes_per_oct
      first += 12
      title = title.next
    end

    holes.flatten.map { |i| i.to_i }
  end

  def show_pipe_menu
    prompts = ["Type :",
               "Diamètre :",
               "Hauteur du pied :",
               "Diapason :",
               "Note :",
               "Temperature :"]
    defaults = ["Flûte Ouverte",
                "145",
                "200",
                "440",
                "C1",
                "18"]
    list = ["Flûte Ouverte|Bourdon",
            "",
            "",
            "",
            "",
            ""]
    input = UI.inputbox(prompts, defaults, list, "Organ Cooker | Draw pipe")
    #TODO
  end
end
