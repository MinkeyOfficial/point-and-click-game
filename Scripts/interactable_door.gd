extends Interactable

# Cesta k pivotu (Hinge) - zkontrolujte cestu, jak jsme se dohodli
@onready var hinge_pivot = $".."

var is_open = false
var open_angle = 90.0
var close_angle = 0.0
var animation_duration = 0.5 # Délka animace v sekundách (0.5s)
var is_animating = false # Proměnná, která brání vícenásobné interakci během pohybu

func interact():
	# Kontrola, zda se již neprovádí animace, aby nedošlo k problémům
	if is_animating:
		return

	# 1. Spustíme animaci
	is_animating = true
	
	# Vytvoříme nový Tween objekt
	var tween = create_tween()
	
	# Nastavíme to, co se má rotovat, a kam se má rotovat
	var target_rotation: float
	
	if is_open == false:
		print("Interacted with: ", name)
		target_rotation = open_angle
		is_open = true
	else:
		target_rotation = close_angle
		is_open = false

	# 2. Přidáme Tween pro rotaci
	# property() změní vlastnost 'rotation_degrees.y' nodu 'hinge_pivot'
	# z aktuální hodnoty na 'target_rotation' za 'animation_duration'
	tween.tween_property(hinge_pivot, "rotation_degrees:y", target_rotation, animation_duration)
	
	# 3. Připojíme signál, který se spustí po dokončení Tweenu
	# (Tím znovu umožníme interakci)
	tween.finished.connect(_on_tween_finished)


func _on_tween_finished():
	# Po dokončení animace je možné znovu interagovat
	is_animating = false
