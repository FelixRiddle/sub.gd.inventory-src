class_name Item

# Scripts
var DicitonaryUtils = preload(
	"res://godot-libs/libs/utils/dictionary_utils.gd")
var uuid_util = preload("res://godot-libs/libs/uuid.gd")

# Signals
signal slot_changed
signal amount_changed(old_value, new_value)

export var class_id = 0 setget set_class_id, get_class_id
export var class_path = "" setget set_class_path, \
	get_class_path
export var debug = false setget set_debug, get_debug
export(String) var scene_path:String = "" setget set_scene_path, \
	get_scene_path

# Because some values were predefined when extending Node
# we are going to use the prefix "item"
export var item_amount = 0 setget set_amount, get_amount
export var item_capacity = 1 setget set_capacity, get_capacity
export var item_description = "Sample text" \
		setget set_id, get_id
export var item_id = 0 setget set_id, get_id
# Path to the item image
var item_image = Node.new() setget set_item_image, get_item_image
export var item_image_path = "" \
		setget set_item_image_path,get_item_image_path
export var item_name = "" setget set_name, get_name
# The slot must be a value between 1 and 10 inclusive
export var item_slot = 0 setget set_slot, get_slot
export var item_subtype = "" setget set_subtype, get_subtype
export var item_type = "" setget set_type, get_type
var item_stats:Dictionary = { } setget set_item_stats, get_item_stats

# Private fields
# A uuid is practically unique almost always
var uuid = uuid_util.v4() setget , get_uuid
var overflow = 0 setget set_overflow, get_overflow

### Functions/Methods ###
# The same as set_amount, except that instead of setting overflow
# returns the remaining items
func add(amount:int) -> int:
	if(self.debug):
		print("Item(Script) -> add(amount): ")
	# Check if there is space available
	var space_available = get_space_available()
	
	# Has space?
	if(!has_space()):
		if(self.debug):
			print(self.item_name, " doesn't have enough space.")
		return amount
	elif(amount <= space_available): # There is enough space
		# There is enough space
		# Add everthing to the item
		self.item_amount += amount
		return 0
	else: # There is space, but not enough
		# Remove some from the amount
		amount -= space_available
		# Add the remaining space
		self.item_amount += space_available
		
		# Return the remaining amount
		return amount

# Drop overflow
func drop_overflow():
	if(debug):
		print("Item.gd -> get_item_overflow(item_dict):")
	
	if(overflow > 0):
		var _overflow = overflow
		overflow = 0
		return _overflow
	else:
		return null


# Get item stats as a dictionary v2
func get_as_dict() -> Dictionary:
	# This class item properties
	var item_props:Array = ["class_id", "class_path", "item_amount",
		"item_capacity", "item_description", "item_id", "item_image",
		"item_name", "item_slot", "item_subtype", "item_type", "overflow",
		"scene_path"]
	
	var dict:Dictionary = DictionaryUtils.get_as_dict(self, item_props)
	return dict


### Amount
func set_amount(value):
	if(debug):
		print("Item.gd -> set_amount(value):")
		print("Amount to add: ", value)
	var old_amount = item_amount
	var space_available = get_space_available()
	
	# There is space to store the items
	if(space_available >= value):
		item_amount = value
		if(self.debug):
			print("Adding everything: ", item_amount)
	else: # There is not enough space
		# We know because of the first check that value is bigger than
		# the space available
		var remaining_items = value - space_available
		
		# Fill it up
		item_amount = item_capacity
		
		# Set the overflow to the remaining items, but we don't know for sure
		# if item_overflow is empty, so we add items to it
		self.overflow += remaining_items
		if(self.debug):
			print("There is not enough space to store the items")
			print(self.item_name, " slot: ", self.item_slot)
			print("Capacity: ", self.item_capacity,
					", Amount: ", self.item_amount,
					", Overflow: ", self.overflow)
	
	emit_signal("amount_changed", old_amount, item_amount)
func get_amount():
	return item_amount


# Get space available
func get_space_available():
	return item_capacity - item_amount


### Capacity
func set_capacity(value):
	item_capacity = value
func get_capacity():
	return item_capacity


func has_overflow():
	return self.overflow > 0


# Check if the item has space
func has_space():
	if item_amount < item_capacity:
		return true
	else:
		return false


### Class id
func set_class_id(value):
	class_id = value
func get_class_id():
	return class_id


### Class path
func set_class_path(value):
	class_path = value
func get_class_path():
	return class_path


### Debug
func set_debug(value):
	debug = value
func get_debug():
	return debug


### Item description
func set_description(value):
	item_description = value
func get_description():
	return item_description


### ID
func set_id(value):
	item_id = value
func get_id():
	return item_id


# setget item_image
func set_item_image(value) -> void:
	var new_image = value
	
	# If it's a path, load the resource
	if(typeof(value) == TYPE_STRING):
		new_image = load(value)
	
	item_image = new_image
func get_item_image():
	return item_image


# setget item_image_path
func set_item_image_path(value:String) -> void:
	item_image_path = value
func get_item_image_path() -> String:
	return item_image_path


# setget item_stats
func set_item_stats(value:Dictionary) -> void:
	item_stats = value
func get_item_stats() -> Dictionary:
	return item_stats


### Item name
func set_name(value):
	item_name = value
func get_name():
	return item_name


### Overflow
func set_overflow(value):
	overflow = value
func get_overflow():
	return overflow


### Scene
func set_scene_path(value):
	scene_path = value
func get_scene_path():
	return scene_path


### Item slot
func set_slot(value:int) -> void:
	item_slot = value
	
	emit_signal("slot_changed")
func get_slot() -> int:
	return item_slot


### Subtype
func set_subtype(value):
	item_subtype = value
func get_subtype():
	return item_subtype


### Item type
func set_type(value):
	item_type = value
func get_type():
	return item_type


### UUID
func get_uuid():
	return uuid
