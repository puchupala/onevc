require 'one_helper'

class OneVCHelper < OpenNebulaHelper::OneHelper
  
  def self.rname
    "VC"
  end
  
  def self.conf_file
    "onevc.yaml"
  end
  
end