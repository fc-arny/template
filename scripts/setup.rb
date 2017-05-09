# frozen_string_literal: true
require 'open3'
require 'pathname'
require 'fileutils'
include FileUtils

# path to your application root.
APP_ROOT = Pathname.new File.expand_path('../../', __FILE__)

def colorize(str, color_code = 32)
  "\e[#{color_code}m#{str}\e[0m"
end

def system!(*args)
  puts colorize("  • #{args.join(' ')} ", 34)

  Open3.popen3(*args) do |_, stdout, stderr, wait_thr|
    while line = stdout.gets
      other_output line
    end

    exit_status = wait_thr.value

    unless exit_status.success?
      print "\r"
      abort(colorize("  ✖ #{args.first}\n  #{stderr.readlines.join('  ')}", 31))
    end
  end
end

def title(str, wrap: '➔ ', timeout: 0)
  puts "\e[1m#{colorize(wrap + str)}\e[22m"
  sleep timeout
end

def infoblock(str, timeout = 3)
  line = '-' * 70

  puts colorize(line, 35)
  str.each_line do |l|
    print colorize("* #{l}", 35)
  end
  puts colorize(line, 35)
  sleep timeout
end

def other_output(str)
  print "    #{colorize(str, 37)}"
end

def subtitle(str)
  puts " #{colorize(' ' + str, 36)}"
end
