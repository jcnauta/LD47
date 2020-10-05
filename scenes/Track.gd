extends Node2D

var Tile = preload("res://scenes/Tile.tscn")
var TrackCoords = preload("res://scenes/TrackCoords.gd")

var tiles = []
var trackside = 1
var turndir = 1
var wrap_width
var wrap_limits = []
var level_idx
var disabled = false

# Add tiles from c0 up to c1, excluding c1.
func intermediate_tiles(c0, c1):
    var tiles = []
    if c0.x == c1.x: # same column
        for r in range(c0.y, c1.y, sign(c1.y - c0.y)):
            var new_tile = Tile.instance()
            new_tile.track = self
            new_tile.set_coords(Vector2(c0.x, r))
            tiles.append(new_tile)
    else: # same row
        for c in range(c0.x, c1.x, sign(c1.x - c0.x)):
            var new_tile = Tile.instance()
            new_tile.track = self
            new_tile.set_coords(Vector2(c, c0.y))
            tiles.append(new_tile)
    return tiles

func set_tile_neighbors():
    for idx in len(tiles):
        var curr_t = tiles[idx]
        var prev_t = tiles[(idx - 1 + len(tiles)) % len(tiles)]
        var next_t = tiles[(idx + 1) % len(tiles)]
        curr_t.set_prev_and_next(prev_t, next_t)

# "Inside" = 1
# "Outside" = 0
#Q1|Q0
#-----
#Q2|Q3
func set_in_outs():
    var q0
    var q1
    var q2
    var q3
    for idx in len(tiles):
        var prev_t = tiles[(idx - 1 + len(tiles)) % len(tiles)]
        var curr_t = tiles[idx]
        var next_t = tiles[(idx + 1) % len(tiles)]
        var to_next = next_t.position - curr_t.position
        var to_prev = prev_t.position - curr_t.position
        if to_next.x > 0:
            q3 = 1
            q0 = 0
            if to_prev.y < 0:
                q1 = 1
                q2 = 1
            elif to_prev.x < 0:
                q1 = 0
                q2 = 1
            else:
                q1 = 0
                q2 = 0
        elif to_next.x < 0:
            q1 = 1
            q2 = 0
            if to_prev.y < 0:
                q0 = 0
                q3 = 0
            elif to_prev.y > 0:
                q0 = 1
                q3 = 1
            else:
                q0 = 1
                q3 = 0
        elif to_next.y < 0:
            q0 = 1
            q1 = 0
            if to_prev.x < 0:
                q2 = 1
                q3 = 1
            elif to_prev.x > 0:
                q2 = 0
                q3 = 0
            else:
                q2 = 0
                q3 = 1
        elif to_next.y > 0:
            q2 = 1
            q3 = 0
            if to_prev.x < 0:
                q0 = 0
                q1 = 0
            elif to_prev.x > 0:
                q0 = 1
                q1 = 1
            else:
                q0 = 0
                q1 = 1
        curr_t.set_in_outs([q0, q1, q2, q3])
    
func generate_tiles(coords):
    for idx in len(coords):
        var c_this = coords[idx]
        var c_next = coords[(idx + 1) % len(coords)]
        tiles += intermediate_tiles(c_this, c_next)
    set_in_outs()
    set_tile_neighbors()
    for t in tiles:
        add_child(t)

func get_track_coords(tile): # returns a triplet (tile0_idx, tile1_idx, interpolation in [0, 1])
    var tile_idx = tiles.find(tile)
    return TrackCoords.new(tile_idx, (tile_idx + 1) % len(tiles), 0)

func position_from_coords(track_coords):
    # track position + interpolate between tiles + offset for right wrapped copy
    return position + \
        G.tilesize * (tiles[track_coords.t0].coords + track_coords.offset * (tiles[track_coords.t1].coords - tiles[track_coords.t0].coords)) + \
        Vector2(tiles[track_coords.t0].collision_area.position.x, 0)

func get_car_rotation(tile0, tile1, cw):
    if tile0.position.x == tile1.position.x: # same column
        if (cw == 1 and tile1.position.y > tile0.position.y) or \
           (cw == -1 and tile1.position.y > tile0.position.y):
            return PI / 2.0
        else:
            return -PI / 2.0
    else: # same row
        if (cw == 1 and tile1.position.x > tile0.position.x) or \
           (cw == -1 and tile1.position.x > tile0.position.x):
            return 0
        else:
            return PI

func move_along(track_coords, cw, delta):
    var t0 = tiles[track_coords.t0]
    var t1 = tiles[track_coords.t1]
    var t_vec = G.tilesize * (t1.coords - t0.coords)
    var t_dist = t_vec.length()
    var dist_left_to_cover = G.trackspeed * delta
    var dist_left_in_segment
    var new_t0
    var new_t1
    var new_offset
    var new_rotation
    if cw == 1:
        dist_left_in_segment = (1 - track_coords.offset) * t_dist
#        print(dist_left_in_segment)
#        print(dist_left_to_cover)
        if dist_left_in_segment > dist_left_to_cover: # stay between same tiles
            new_t0 = track_coords.t0
            new_t1 = track_coords.t1
            new_offset = track_coords.offset + dist_left_to_cover / t_dist
        else: # move past next tile, for now just go to the next file
            new_t0 = track_coords.t1
            new_t1 = (track_coords.t1 + 1) % len(tiles)
            new_offset = 0
    else:
        dist_left_in_segment = track_coords.offset * t_dist
        if dist_left_in_segment > dist_left_to_cover:
            new_offset = track_coords.offset - dist_left_to_cover / t_dist
            new_t0 = track_coords.t0
            new_t1 = track_coords.t1
        else:
            new_t0 = (track_coords.t0 - 1 + len(tiles)) % len(tiles)
            new_t1 = track_coords.t0
            new_offset = 1
    new_rotation = get_car_rotation(tiles[new_t0], tiles[new_t1], cw)
    return [TrackCoords.new(new_t0, new_t1, new_offset), new_rotation]

func set_wrap_width(ww):
    wrap_width = ww

func update_wrap():
    var cam_center = G.camera.get_camera_screen_center()
    for t in tiles:
        t.update_collision_position(cam_center)

func add_to_bin(bin):
    for t in tiles:
        t.add_to_bin(bin)
