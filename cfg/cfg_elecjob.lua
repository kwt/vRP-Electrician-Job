elecjobcfg = {}

elecjobcfg.repairTime = 15 * 1000 -- 15 seconds - time for the repair animation

elecjobcfg.payment = { -- minimum and maximum payment (put the same value to both if you want constant payments)
    min = 500,
    max = 600
}

elecjobcfg.jobCount = {
    minJobs = 1,
    maxJobs = 2,
}

elecjobcfg.joblocation = vector3(442.93350219727,-1969.0008544922,24.401752471924)

elecjobcfg.lang = {
    nextTask = "~g~Go to the location and repair the electric panel.", -- task instructions                   
    beginRepair = "Press ~g~[E]~w~ to begin the repair.",              -- begin repair after pressin "E"
    finishedTask = "~g~You fixed the electric panel and got ~y~£",    -- task is done, and the player is being paid
    taskFailed = "~r~You failed to repair the electric panel."         -- task failed because the player pressed ESC while using the sliders
}

elecjobcfg.locations = { -- locations (they're all around the map, you can always add more)
    {796.76080322266,-104.40004730225,82.031387329102},
    {533.27752685547,-1603.1750488281,29.097993850708},
    {83.621444702148,-1613.2407226563,29.591735839844},
    {-10.910053253174,-1310.8446044922,29.300472259521},
    {-166.01905822754,-1178.6082763672,24.256629943848},
    {-615.27093505859,-1087.3980712891,22.322261810303},
    {-986.94665527344,-1210.830078125,5.5901303291321},
    {-1326.4638671875,-1075.861328125,6.9471325874329},
    {-1367.0280761719,-649.36248779297,28.6038646698},
    {-1343.7171630859,-201.99969482422,43.695610046387},
    {205.19973754883,1180.6953125,227.00907897949},
    {-98.964584350586,1886.8309326172,197.3331451416},
    {338.01187133789,3402.2766113281,36.479785919189},
    {1700.4973144531,3759.1442871094,34.428932189941},
    {1942.4954833984,3840.6264648438,32.160850524902},
    {2150.7214355469,4774.9370117188,41.126544952393},
    {1710.1099853516,4729.7016601563,42.147998809814},
    {1713.6135253906,6426.12109375,32.774425506592},
    {113.72604370117,6639.8408203125,31.80225944519},
    {-690.18865966797,5787.484375,17.330945968628},
    {-2178.3005371094,4274.216796875,49.117809295654},
    {-3223.0444335938,915.19995117188,13.992435455322},
    {-1598.3941650391,-872.15496826172,9.8733644485474},
}


return elecjobcfg