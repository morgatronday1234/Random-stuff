--This project is under the CC-BY-4.0 license
--https://github.com/morgatronday1234


--remember to connect a cobblestone storage method like a chest with cobblestone with a modem then right click the modem and paste the network location/path here
cobble_path = "storagedrawers:standard_drawers_1_2"
cobble_per = peripheral.wrap(cobble_path)
cobble_slot = 2
--cobble input

water_path = "fluidTank_0"
water_per = peripheral.wrap(water_path)

tuff_buffer_path = "storagedrawers:standard_drawers_1_1"
tuff_buffer_per = peripheral.wrap(tuff_buffer_path)

basins_path = {"basin_2", "basin_4", "basin_5"}
basins_per = {}
for basin_index, basin_in_path in pairs(basins_path) do
 basins_per[basin_index] = peripheral.wrap(basin_in_path)
end
--basin(s)

crushing_input_path = "create:chute_0"
crushing_input_per = peripheral.wrap(crushing_input_path)

crushing_output_path = "create:chute_1"
crushing_output_per = peripheral.wrap(crushing_output_path)
--crushing

trashcan_path = "trashcans:item_trash_can_tile_1"
trashcan_per = peripheral.wrap(trashcan_path)

drawer_contr_path = "storagedrawers:controller_1"
drawer_contr_per = peripheral.wrap(drawer_contr_path)
--output


function mix_tuff() while(true) do
 for _, tuff_mixing_basinX in pairs(basins_per) do
  tuff_mixing_basinX.pullFluid(water_path, 2700)

  tuff_mixing_basinX.pullItems(cobble_path, cobble_slot, 16, 1)
  --[[
  tuff_mixing_basinX.pullItems(cobble_path, cobble_slot, 16, 2)
  tuff_mixing_basinX.pullItems(cobble_path, cobble_slot, 16, 3)
  tuff_mixing_basinX.pullItems(cobble_path, cobble_slot, 16, 4)
  --]]
  --I genuinely can't tell if its create breaking this or generic_peripheral im guessing create 
  --But for some reason basins can only have 16 cobble per-slot when using generic_peripheral
  --So fuck a real fix, This is good enough
  --(This doesn't work :<)
 end
 
 for _, basin_trans_buffer in pairs(basins_path) do
  tuff_buffer_per.pullItems(basin_trans_buffer, 10)
 end
end end


function crushing_tuff() while(true) do
 crushing_input_per.pullItems(tuff_buffer_path, 2)

 
 for __=1, 5 do 
  item_in_chute = crushing_output_per.list()[1]
  
  if (item_in_chute) and (item_in_chute.name ~= "minecraft:flint") then
   drawer_contr_per.pullItems(crushing_output_path, 1, 64)
  elseif (item_in_chute) and (item_in_chute.name == "minecraft:flint") then
   trashcan_per.pullItems(crushing_output_path, 1, 64)
  end
 end
end end
--mix_tuff()
--crushing_tuff()
parallel.waitForAll(mix_tuff, crushing_tuff)
