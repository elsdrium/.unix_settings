set history save on
set history filename ~/.gdb_history
set auto-load safe-path /
set verbose off

set print array-indexes on
set python print-stack full

set disassembly-flavor intel
set confirm off

# automatically set pending breakpoints
set breakpoint pending on


define hookpost-up
  dashboard
end

define hookpost-down
  dashboard
end

define hookpost-frame
  dashboard
end

define ipy
  py __import__('IPython').embed_kernel()
end
