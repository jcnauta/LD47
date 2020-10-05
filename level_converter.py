#!/usr/bin/env python3

import json
import sys

with open("./levels/" + sys.argv[1] + ".json") as file:
	data = json.load(file)
	h = data["height"]
	w = data["width"]
	level_data = []
	for layer in range(len(data["layers"])):
		level_data.append([])
		for y in range(0, h):
			level_data[layer].append([])
			for x in range(0, w):
				level_data[layer][y].append(data["layers"][layer]["data"][y * w + x])
	print("var tracks = " + str(level_data))