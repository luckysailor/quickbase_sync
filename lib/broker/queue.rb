require 'broker/payload'
require 'broker/utility'

module Broker
  class Queue
    include Broker::Utility
    
    attr_reader :processed, :pending, :failed
    
    def initialize
      @processed = 0
      @pending = []
      @failed = []
    end
    
    def push(paths)
      paths.each { |p| @pending << Broker::Payload.parse(p) }
    end
    
    def next
      @pending.pop
    end
    
    def empty?
      @pending.empty?
    end
    
    def failure(payload)
      @failed << payload
    end
    
    def success(payload)
      @processed +=1
      move payload
    end
    
    private
    
    def move(payload)
      f = "#{timestamp}_#{File.basename(payload.pkg.file)}"
      FileUtils.mv payload.pkg.file, File.join(Broker.options[:processed_path],"/", f)
    end
    
  end
end