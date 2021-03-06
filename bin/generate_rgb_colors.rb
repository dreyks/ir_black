#!/usr/bin/env ruby

rgb_txt = '/usr/share/vim/vim74/rgb.txt'
rgb_colors_file = File.join(File.expand_path('../../colors', __FILE__),
                            'rgb_colors')

rgb_colors = {}
File.readlines(rgb_txt).each do |line|
  next unless match = line.match(/\A \s*
                                 (?'red'\d+) \s+
                                 (?'green'\d+) \s+
                                 (?'blue'\d+) \s+
                                 (?'name'\S+) \s* # Exclude color names with space
                                 \Z/x)
  rgb_colors[match[:name].downcase] = '%0.2x%0.2x%0.2x' %
    [match[:red], match[:green], match[:blue]]
end


File.open(rgb_colors_file, 'w') do |file|
  file.puts <<-VIM
" Generated from `rgb.txt` by `bin/generate_rgb_colors` script, don't manually
" modify this file.
"
" This file is intentioned to not have `.vim` extension so it can't be used as
" a regular color scheme.

let g:rgb_colors = {}
  VIM

  Hash[rgb_colors.sort].each do |name, hex|
    file.puts %{let g:rgb_colors.#{name} = '#{hex}'}
  end

  file.puts <<-VIM

" vim: set ft=vim:
  VIM
end


# vim: set ft=ruby:
