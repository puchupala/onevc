require 'one_helper'
require 'VirtualCluster'

class OneVCHelper < OpenNebulaHelper::OneHelper
  
  def self.rname
    "VC"
  end
  
  def self.conf_file
    "onevc.yaml"
  end
  
  def factory(id=nil)
      VirtualCluster.new
  end
  
end