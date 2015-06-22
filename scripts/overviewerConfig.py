import os

worlds["Mavencraft"] = os.environ['FULL_BACKUP']

world = "Mavencraft"

renders["normal"] = {
  "title": "Normal",
  "dimension": "overworld",
  "rendermode": "smooth_lighting"
}

#renders["normal cave"] = {
#  "title": "Normal Cave",
#  "dimension": "overworld",
#  "rendermode": "cave"
#}

#renders["nether"] = {
#  "title": "Nether",
#  "dimension": "nether",
#  "rendermode": "nether_smooth_lighting"
#}

#renders["nether plain"] = {
#  "title": "Nether Plain",
#  "dimension": "nether",
#  "rendermode": "nether"
#}

showlocationmarker = False
defaultzoom = 4 
processes = 6
outputdir = os.environ['FULL_MAP']
texturepath = "/home/mavencraft/textures"
