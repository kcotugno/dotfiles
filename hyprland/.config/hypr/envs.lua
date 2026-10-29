local home = os.getenv("HOME")

local function xdg(name, default)
  local value = os.getenv(name)
  if value == nil or value == "" then return home .. default end
  return value
end

local function find_executable(names)
  for _, name in ipairs(names) do
    for dir in (os.getenv("PATH") or "/usr/local/bin:/usr/bin"):gmatch("[^:]+") do
      local path = dir .. "/" .. name
      local f = io.open(path, "r")
      if f then
        f:close()
        return path
      end
    end
  end
end

local chrome = find_executable({ "brave-origin", "brave" })
if chrome then hl.env("CHROME_PATH", chrome) end

hl.env("DEVPATH", home .. "/devel")
hl.env("RIPGREP_CONFIG_PATH", home .. "/.config/ripgreprc")

hl.env("GOPATH", xdg("XDG_DATA_HOME", "/.local/share") .. "/go")
hl.env("GOMODCACHE", xdg("XDG_CACHE_HOME", "/.cache") .. "/go/mod")
hl.env("GOBIN", xdg("XDG_BIN_HOME", "/.local/bin"))
