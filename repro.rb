#!/usr/bin/env ruby

require 'bundler/inline'
gemfile do
    source 'https://rubygems.org'
    gem 'ffi-icu', git: 'https://github.com/KJTsanaktsidis/ffi-icu.git', ref: '8a3058f5911ba2798c8730806c065fec25f88c55'
end

require 'ffi-icu'

puts "ICU version: #{ICU::Lib.version.to_s} (from #{ICU::Lib.ffi_libraries.first.name})"
test_time = Time.at(1234567890)
puts "test_time is #{test_time.to_s} (epoch #{test_time.to_i})"

test_cases = [
    "ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'en_US')",
    "ICU::TimeFormatting.format(test_time, date: :long, time: :long, locale: 'C')",
    "ICU::TimeFormatting.format(test_time, date: :long, time: :long)",
    "ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'en_US')",
    "ICU::TimeFormatting.format(test_time, date: :long, time: :short, locale: 'C')",
    "ICU::TimeFormatting.format(test_time, date: :long, time: :short)",
    "ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyhmma')",    
    "ICU::TimeFormatting.format(test_time, skeleton: 'dMMMMyyyyHHmm')",    
]

test_cases.each do |tc|
    puts "#{tc} -> #{eval tc}"
end
