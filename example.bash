#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

echo "example.bash says: sourcing lua-helper.bash.in"

# all paths may be relative to current dir
. "$script_dir/lua-helper.bash.in" "$script_dir/example.cfg.lua" -e config.sub \
-e config.paths -e config.empty -e wrong.table -e empty -r cfg -l cfg_list -b "$script_dir/example.pre.lua" -a "$script_dir/example.post.lua" -o test1 -o test2 -w /tmp
# ^ options at this line is optional ^

echo "example.bash says: lua-helper.bash.in complete"
echo "example.bash says: my own cmdline params=$@"
echo ""
echo "example.bash says: names of all global variables exported from lua script:"
echo "$cfg_list"
echo ""
echo -n "example.bash says: check for config.empty variable availability is "
check_lua_export config.empty && echo "passed, but should fail !!!" || echo "failed, as expected"
echo -n "example.bash says: check for wrong.table variable availability is "
check_lua_export wrong.table && echo "passed, but should fail !!!" || echo "failed, as expected"
echo -n "example.bash says: check for empty variable availability is "
check_lua_export empty && echo "passed, but should fail !!!" || echo "failed, as expected"
echo -n "example.bash says: check for config.value variable availability is "
check_lua_export config.value && echo "passed, but should fail !!!" || echo "failed, as expected"
echo -n "example.bash says: check for config.sub.string variable availability is "
check_lua_export config.sub.string && echo "passed, as expected" || echo "failed, but should pass !!!"
echo -n "example.bash says: check for config.sub variable availability is "
check_lua_export config.sub && echo "passed, as expected" || echo "failed, but should pass !!!"
echo "example.bash says: config.value is not selected for export, so cfg[config.value] = ${cfg[config.value]}"
echo "example.bash says: config.empty is not found in lua config file, so cfg[config.empty] = ${cfg[config.empty]}"
echo "example.bash says: cfg[config.paths.tempdir] = ${cfg[config.paths.tempdir]}"
echo "example.bash says: cfg[config.paths.workdir] = ${cfg[config.paths.workdir]}"
echo "example.bash says: cfg[config.paths.dynpath] = ${cfg[config.paths.dynpath]}"
echo "example.bash says: cfg[config.paths.tempdir_raw] = ${cfg[config.paths.tempdir_raw]}"
echo "example.bash says: cfg[config.paths.workdir_raw] = ${cfg[config.paths.workdir_raw]}"
echo "example.bash says: cfg[config.paths.dynpath_raw] = ${cfg[config.paths.dynpath_raw]}"
echo "example.bash says: (should be empty, because it is a container) cfg[config.sub] = ${cfg[config.sub]}"
echo "example.bash says: cfg[config.sub.lua_v1] = ${cfg[config.sub.lua_v1]}"
echo "example.bash says: cfg[config.sub.lua_v2] = ${cfg[config.sub.lua_v2]}"
echo "example.bash says: cfg[config.sub.lua_v3] = ${cfg[config.sub.lua_v3]}"
echo "example.bash says: cfg[config.sub.lua_num] = ${cfg[config.sub.lua_num]}"
echo "example.bash says: cfg[config.sub.number1] = ${cfg[config.sub.number1]}"
echo "example.bash says: cfg[config.sub.string] = ${cfg[config.sub.string]}"
echo "example.bash says: cfg[config.sub.problematic_string] = ${cfg[config.sub.problematic_string]}"
echo "example.bash says: cfg[config.sub.non_latin_string] = ${cfg[config.sub.non_latin_string]}"
echo "example.bash says: cfg[config.sub.sub.message] = ${cfg[config.sub.sub.message]}"
echo "example.bash says: cfg[config.sub.sub.message2] = ${cfg[config.sub.sub.message2]}"
echo "example.bash says: cfg[config.sub.multiline_string] = ${cfg[config.sub.multiline_string]}"
