require "sexp_processor"
require "ruby19_parser"

class UbyInterpreter < SexpInterpreter
  class Environment
    def [] k
      self.all[k]
    end

    def []= k, v
      @env.last[k] = v
    end

    def all
      @env.inject(&:merge)
    end

    def scope
      @env.push({})

      yield
    ensure
      @env.pop
    end

    def initialize
      @env = [{}]
    end
  end
  VERSION = "1.0.0"

  attr_accessor :parser

  attr_accessor :env

  def initialize
    super

    self.parser = Ruby19Parser.new
    self.env = Environment.new
  end

  def eval src
    process parse src
  end

  def parse src
    self.parser.process src
  end

  def process_lit s
    s.last
  end

  def process_if s
    _, c, t, f = s

    c = process c

    if c then
      process t
    else
      process f
    end
  end

  def process_nil s
    nil
  end

  def process_true s
    true
  end

  def process_false s
    false
  end

  def process_call s
    _, recv, msg, *args = s

    recv = process recv
    args.map! {|sub| process sub}

    if recv then
      recv.send(msg, *args)
    else
      self.env.scope do
        decls, body = self.env[msg]

        decls.rest.zip(args).each do |name, val|
          self.env[name] = val
        end

        process_block s(:block, *body)
      end
    end
  end

  def process_block s
    result = nil
    s.rest.each do |sub|
      result = process sub
    end
    result
  end

  def process_lasgn s
    _, n, v = s

    self.env[n] = process v
  end

  def process_lvar s
    _, n = s
    self.env[n]
  end

  def process_defn s
    _, name, args, *body = s

    self.env[name] = [args, body]

    nil
  end

  def process_while s
    _, cond, *body = s
    body.pop

    while process cond
      process_block s(:block, *body)
    end
  end
end
