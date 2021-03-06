require 'ripper'
require_relative 'outlaw/law_parser'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'
require_relative 'outlaw/rule_methods'



module Outlaw
  extend self
  attr_accessor :ignore_types, :param_types

  def outlaw(pattern, message=nil)
    if pattern.kind_of?(String)
      rule = Rule.new(pattern, message)
      Outlaw::Enforcement.add(rule)
    else
      Outlaw::Enforcement.add(self.send(pattern))
    end
  end

  def enforce(dir=".")
    Outlaw::Enforcement.process_directory(dir)
  end
  #these come from ripper's Lexer
  self.param_types    = [:on_const, :on_ident, :on_ivar, :on_cvar]
  self.ignore_types   = [:on_sp, :on_nl, :on_ignored_nl, :on_rparen, :on_lparen]
  WHITESPACE          = [:on_sp, :on_nl, :on_ignored_nl]
  VERTICAL_WHITESPACE = [:on_nl, :on_ignored_nl]
  SPECIAL_CASES       = [:whitespace_sensitive, :vertical_whitespace_sensitive]

  CORE_CLASSES_FILE   = File.expand_path("../../data/core_classes.txt", __FILE__)
  CORE_CLASS          = File.readlines(CORE_CLASSES_FILE).map &:chomp
end
