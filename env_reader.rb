module EnvReader
  def self.read
    open(File.dirname(__FILE__) + '/.env', 'r') do |f|
      f.each_line do |line|
        tokens = line.split('=')
        next if tokens.length < 2
        key = tokens[0]
        value = tokens[1..-1].join('=')
        ENV[key] = value
      end
    end
  end
end
