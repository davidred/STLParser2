require 'byebug'

class STLParser

  attr_reader :file, :f, :vertices, :num_faces, :num_vertices, :triangle

  HANDLERS = {
    facet_handler: true,
    vertex_handler: true,
    endloop_handler: true,
  }

  def initialize(file)
    @file = file
    @f = File.open(file)
    @vertices = Hash.new(false) #keeps track of 'already seen' vertices
    @triangle = [] #stores vertices of current triangle
    @num_vertices = 0
    @num_faces = 0
  end

  def print_file_contents
    #prints entire stl file to console (for testing)
    while true do
      line = @f.gets
      break if line.nil?
      puts line.chomp
    end
    @f.close
    @f = File.open(file)
  end

  def parse(end_of_file = false)
    #parse file and calculate results
    until end_of_file
      end_of_file = parse_handler(@f.gets.chomp.strip)
    end

    return [@num_faces, @num_vertices]
  end

  private

  def parse_handler(line)
    #determine which callback to use based on first word
    return true if line.split()[0] == "endsolid"
    handler = (line.split()[0] + "_handler").to_sym #generate handler method name
    send(handler, line) if HANDLERS.include?(handler) #call appropriate callback
    false #return false, indicating end of file was not reached
  end

  def vertex_handler(line)
    line = line.split('vertex ')[1] #extract xyz coords of vertex
    vertex = parse_vertex(line)
    triangle << vertex #store vertex in triangle instance variable
  end

  def facet_handler(line)
    #each facet is a new face
    cur_normal = parse_vertex(line.split('normal ')[1])
    @num_faces += 1
  end

  def endloop_handler(line)
    #store unique vertices to the vertices hash
    triangle.each do |vertex|
      unless vertices[vertex]
        vertices[vertex] = true
        @num_vertices += 1
      end
    end

    @triangle = [] #reset current triangle to empty array
  end

  def parse_vertex(line)
    #return a slightly more compressed vertex. Ignore "-0.0".
    vertex = line.split().map(&:to_f).map{|el| el == -0.0 ?  0.0 : el }
    vertex.join(" ")
  end

  def readline #reads one line at a time
    line = @f.gets
    line.nil? ? reopen : line.chomp.strip
  end

  def reopen #close and reopen file. Start from the beginning
    @f.close
    @f = File.open(file)
    readline
  end

end
