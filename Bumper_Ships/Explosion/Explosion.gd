extends Node2D

var bumper_texture : Texture
var shard_velocity_map = {}
var shard_count = 50

func _ready():
	$Boom.play()
	make_debris()

func _process(delta):
	for child in shard_velocity_map.keys():
		child.position -= shard_velocity_map[child] * delta * 400
		child.color.a -= delta 

func _on_Boom_animation_finished():
	queue_free()

func make_debris():
	var points = PoolVector2Array()
	var w = bumper_texture.get_width()
	var h = bumper_texture.get_height()
	
	$Boom.scale.x = (float(w)/256) * 1.2
	$Boom.scale.y = (float(h)/256) * 1.2
	
	$Debris.position.x -= w/2
	$Debris.position.y -= h/2
	points.append(Vector2(0,0))
	points.append(Vector2(0,h))
	points.append(Vector2(w,h))
	points.append(Vector2(w,0))
		
	for i in range(shard_count):
		points.append(Vector2(randi()%w,randi()%h))
	
	var delaunay_points = Geometry.triangulate_delaunay_2d(points)
	
	for index in len(delaunay_points) / 3:
		var shard_pool = PoolVector2Array()
		var center = Vector2.ZERO
		
		for n in range(3):
			shard_pool.append(points[delaunay_points[(index * 3) + n]])
			center += points[delaunay_points[(index * 3) + n]]
		center /= 3
			
		var shard = Polygon2D.new()
		shard.polygon = shard_pool
		shard.texture = bumper_texture
		var shard_velocity = (Vector2(w/2,h/2) - center) / Vector2(w/2,h/2)
		shard_velocity_map[shard] = shard_velocity
		$Debris.add_child(shard)