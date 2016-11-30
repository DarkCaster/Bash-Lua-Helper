#!/usr/bin/lua

-- helper script basic logic:

-- get temporary dir
-- get workdir
-- ???
-- sequentially, execute lua scripts from remaining args (include?)
-- recursively iterate through global params, saving valid value contents to text files inside temp dir for later reuse inside bash scripts
-- profit!

-- storage for loader params
loader={}
loader["export"]={}

-- show usage
function LoaderShowUsage()
 print("usage: loader.lua <params>")
 print("")
 print("mandatory params:")
 print("-t <dir> : Temporary directory, where resulted global variables will be exported as text. It must exist.")
 print("-w <dir> : Work directory, may be reffered in used scripts as \"loader.workdir\"")
 print("-c <condif script path> : Main config script file.")
 print("-e <variable name> : Name of global variable, to be exported after script is run. You can specify multiple -e params. At least one must be specified.")
 print("")
 print("optional params:")
 print("-pre <script>: Optional lua script, executed before main config script. May contain some additional functions for use with main script. Non zero exit code aborts further execution.")
 print("-post <script>: Optional lua script, executed after main config script. May contain some some verification logic for use with main script. Non zero exit code aborts further execution.")
 os.exit(1)
end

function LoaderParamSetCheck(par)
 if loader[par] ~= nil then
  print(string.format("param \"%s\" already set",par))
  print()
  LoaderShowUsage()
 end
end

function LoaderParamNotSetCheck(par)
 if loader[par] == nil then
  print(string.format("param \"%s\" is not set",par))
  print()
  LoaderShowUsage()
 end
end

function LoaderSetParam (name, value)
 if name == nil then
  error(string.format("param \"%s\" is nil",name))
 end
 if value == nil then
  error(string.format("param \"%s\" is not set",name))
 end
 loader[name]=string.format("%s",value)
end

set=false
par="none"
exnum=-1

for i,ar in ipairs(arg) do
 if set == true then
  if par == "add_export" then
   loader.export[exnum]=string.format("%s",ar)
  else
   LoaderSetParam(par,ar)
  end
  set = false
 else
  if ar == "-t" then
   par="tmpdir"
  elseif ar == "-w" then
   par="workdir"
  elseif ar == "-c" then
   par="exec"
  elseif ar == "-pre" then
   par="preexec"
  elseif ar == "-post" then
   par="postexec"
  elseif ar == "-e" then
   par="add_export"
   exnum=exnum+1
  else
   print(string.format("incorrect parameter: %s",ar))
   print()
   LoaderShowUsage()
  end
  LoaderParamSetCheck(par)
  set = true
 end
end

LoaderParamNotSetCheck("tmpdir")
LoaderParamNotSetCheck("workdir")
LoaderParamNotSetCheck("exec")

if loader.export[0] == nil then
 print("at least one global variable name to export must be provided!")
 print()
 LoaderShowUsage()
end

exnum=nil
set=nil
par=nil

