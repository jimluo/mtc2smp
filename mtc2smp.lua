function mtc2smp(fmtc, fsmp)
  local line = fmtc:read("*line")
  fsmp:write(line:sub(1, #line-9) .. line:sub(-9):gsub("-", "/"))
  line = fmtc:read("*line")
  fsmp:write("\ndiameter inch\n")
  line = fmtc:read("*line")
  while line ~= nil do
    if line:sub(-3) == ",13" then
      local ruler,_ = line:gsub(",%w+", "")
      line = string.format("%2.3f,13", ruler / 25.4)
    end
    fsmp:write(line .. "\n")
    line = fmtc:read("*line")
  end
end

mtcs = io.popen("dir *.mtc")
mtcs:read("*all"):gsub("%w+-?%w+.mtc", function(mtc)
  local smp = mtc:gsub(".mtc", ".smp")
  local fmtc = assert(io.open(mtc, "r"))
  local fsmp = assert(io.open(smp, "w"))
  print(string.format("convert %s to %s", mtc, smp))
  mtc2smp(fmtc, fsmp)
  fmtc:close()
  fsmp:close()
end)
mtcs:close()
