


print(1 << 12 == 1 >> -12) --true

local function udiv(n,d)
   if d < 0 then
      if math.ult(n,d) then return 0 
	  else return 1
	  end
   end
   local q = ( (n >> 1) // d )
   local r = n - q * d
   if not math.ult(r, d) then q = q + 1 end
   return q
end

print(1 << 63)
print(udiv(1 << 63,1))

local s = string.pack("iii",1,2,3)
print(s,#s)
string.unpack("iii",s)