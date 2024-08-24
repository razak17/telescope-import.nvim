local regex = {
  c = [[^(?:#include [\"<].*[\">])\s*]],
  go = [[^\t(\".*\")|^import (\".*\")]],
  java = [[^import\s+((static\s+)?[\w.]+\*?);\s*$]],
  javascript = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
  lua = [[^local (\w+) = require\([\"'](.*?)[\"']\)]],
  php = [[^\s*use\s+([\w\\]+)(?:\s*;)?]],
  python = [[(?m)^(?:from[ ]+(\S+)[ ]+)?import[ ]+(\S+)[ ]*$]],
  shell = [[^(?:source\s+)]],
  swift = [[^import\s+(\w+)\s*$]],
}

return regex
