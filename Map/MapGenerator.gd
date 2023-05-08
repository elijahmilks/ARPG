extends TileMap


@export var map_size: Vector2i;
@export var fill_percent: float;
@export var live_neighbors_required: int;

var _rng = RandomNumberGenerator.new();
var _map: BitMap;
var _updates_count = -1;

const land_texture_pos = Vector2i(10, 0);
const lava_texture_pos = Vector2i(11, 7);


func _ready():
	# tmp
	generate();
	each(_map, draw_map);

func add_borders(bitmap: BitMap):
	var size = bitmap.get_size();
	for x in range(0, size.x):
		bitmap.set_bit(x, 0, false);
		bitmap.set_bit(x, size.y - 1, false);
	for y in range(0, size.y):
		bitmap.set_bit(0, y, false);
		bitmap.set_bit(size.x - 1, y, false);

func generate_stable():
	_rng.randomize();

	var new_map = BitMap.new();
	new_map.create(map_size);
	new_map = each_update(new_map, gen_cell);

	# ensure a spawn area
	var spawn_rect = Rect2i(6, 6, 6, 6);
	new_map.set_bit_rect(spawn_rect, true);

	var last_updates_count = 0;
	var total_loops = 0;
	while (_updates_count != last_updates_count && total_loops < 20):
		new_map = each_update(new_map, ca_step_count);
		last_updates_count = _updates_count;
		_updates_count = 0;
		total_loops += 1;

	return new_map;

func generate():
	_rng.randomize();

	_map = generate_stable();
	add_borders(_map);

func ca_step(bitmap: BitMap, pos: Vector2i, value: bool):
	var live_cells_count = 1 if value else 0;
	live_cells_count += get_neighbor_active_cell_count(bitmap, pos);
	return true if live_cells_count > live_neighbors_required else false;

func ca_step_count(bitmap: BitMap, pos: Vector2i, value: bool):
	var new_value = ca_step(bitmap, pos, value);
	if (new_value != value): _updates_count += 1;
	return new_value;

func get_neighbor_active_cell_count(bitmap: BitMap, pos: Vector2i):
	var size = bitmap.get_size();
	var count = 0;

	if (pos.x > 0):
		if (pos.y > 0 && bitmap.get_bitv(pos + Vector2i(-1, -1))):
			count += 1;
		if (bitmap.get_bitv(pos + Vector2i(-1, 0))):
			count += 1;
		if (pos.y < size.y - 1 && bitmap.get_bitv(pos + Vector2i(-1, 1))):
			count += 1;
	if (pos.y > 0 && bitmap.get_bitv(pos + Vector2i(0, -1))):
		count += 1;
	if (pos.y < size.y - 1 && bitmap.get_bitv(pos + Vector2i(0, 1))):
		count += 1;
	if (pos.x < size.x - 1):
		if (pos.y > 0 && bitmap.get_bitv(pos + Vector2i(1, -1))):
			count += 1;
		if (bitmap.get_bitv(pos + Vector2i(1, 0))):
			count += 1;
		if (pos.y < size.y - 1 && bitmap.get_bitv(pos + Vector2i(1, 1))):
			count += 1;

	return count;

func draw_map(bitmap: BitMap, pos: Vector2i, value: bool):
	var texture_pos = land_texture_pos if value else lava_texture_pos;
	set_cell(0, pos, 3, texture_pos);

func gen_cell(bitmap: BitMap, pos: Vector2i, value: bool):
	return true if _rng.randf() > fill_percent else false;

func each(bitmap: BitMap, fn: Callable):
	var size = bitmap.get_size();
	for x in range(0, size.x):
		for y in range(0, size.y):
			fn.call(bitmap, Vector2i(x, y), bitmap.get_bit(x, y));

func each_update(bitmap: BitMap, fn: Callable):
	var new_map = BitMap.new();
	var size = bitmap.get_size();
	new_map.create(size);
	for x in range(0, size.x):
		for y in range(0, size.y):
			var new_value = fn.call(bitmap, Vector2i(x, y), bitmap.get_bit(x, y));
			new_map.set_bit(x, y, new_value);
	return new_map;
