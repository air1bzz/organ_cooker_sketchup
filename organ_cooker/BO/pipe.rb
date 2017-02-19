class Pipe

  def initialize(diameter, foot_height, toe_hole_diam, length)
    @length = length
    @diameter = diameter
    @foot_height = foot_height
    @toe_hole_diam = toe_hole_diam
  end

  def draw(center)
    model    = Sketchup.active_model
    entities = model.entities
    vector   = Geom::Vector3d.new([0,0,1]).normalize!

    rayon  = @diameter / 2.0
    edges1 = entities.add_circle(center, vector, rayon.mm)
    face1  = entities.add_face(edges1)

    rayon  = @toe_hole_diam / 2.0
    edges2 = entities.add_circle(center, vector, rayon.mm)

    transform = Geom::Transformation.new([0,0,@foot_height.mm])
    entities.transform_entities(transform, edges1)

    face2     = entities.add_face(edges1)
    face2.pushpull(@length.mm, true)
  end
end
