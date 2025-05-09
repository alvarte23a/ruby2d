require 'ruby2d'

set title: "spelprojekt1", width: 1200, height: 675
background = Image.new("bakgrund.jpg", x: 0, y: 0)
player_right = Image.new("MEWOW.v2.png", x:0, y:475, width:100, height: 100)
player_left = Image.new("image.png",x:0, y:475, width:100, height: 100 )
text = Sprite.new("soace.png", x: 500, y: 100, width: 400  , height:400)

obstacle = Rectangle.new(color:'black',x: 1190, y:475, width:15, height:10)
#current_player = player

blink_timer = 0
blink_speed = 30
rectangle = Rectangle.new(
  color: 'green',
  x: 0,
  y: 575,
  width: 1200,
  height: 100
  
)

def switch_to(player_to_show)
  current_player.remove
  player_to_show.x = current_player.x
  player_to_show.y = current_player.y
  current_player = player_to_show
  current_player.add
end

# Håller koll på nedtryckta tangenter
all_pressed_keys = {}

on :key_down do |event|
  all_pressed_keys[event.key] = true  # lägg till nyckeln med ett värde
  puts all_pressed_keys.keys          # skriver ut alla tangenter som tryckts ner
end




pressed_keys = {}

# När en tangent trycks ner
on :key_down do |event|
  pressed_keys[event.key] = true
end

# När en tangent släpps
on :key_up do |event|
  pressed_keys.delete(event.key)  # Tar bort tangenten från listan
end


velocity_y = 0 
gravity = 0.5
jump_strength = -15
on_ground = false  

facing_left = false
facing_right = false
text_exist = false
update do

if all_pressed_keys.include?("space")
blink_timer += 0
text_exist = true
else 
  blink_timer += 1
end
if text_exist == true
  text.remove
end


if (blink_timer / blink_speed) % 2 == 0
  text.add if text_exist == true
  text_exist = true
else
  text.remove
  text_exist = false 
end
  puts player_right.x
  puts player_right.y
  move_x = 0
  move_y = 0
  move_x_obstacle = 0

player_left.remove
current_player = player_right 
  
  if pressed_keys["w"] && on_ground
    velocity_y = jump_strength
    on_ground = false
  end  
  velocity_y += gravity

  player_right.x += move_x
  player_right.y += velocity_y
  if player_right.y + player_right.height >= rectangle.y
    player_right.y = rectangle.y - player_right.height
    velocity_y = 0
    on_ground = true
  else
    on_ground = false
  end

  if pressed_keys["d"] && current_player.x < 1100
    current_player.remove
    player_right.x = current_player.x
    player_right.y = current_player.y
    current_player = player_right
    current_player.add
    move_x += 5
  end
  if pressed_keys["d"]
    facing_left = false
    facing_right = true
  end
  
  if pressed_keys["a"] && current_player.x > 0
    current_player.remove
    player_left.x = current_player.x
    player_left.y = current_player.y
    current_player = player_left
    current_player.add
    move_x -= 5
  end
  if pressed_keys["a"]
    facing_right = false
    facing_left = true
  end

  if  facing_left == true
    player_left.x = current_player.x
    player_left.y = current_player.y
    player_left.add
  end

  if all_pressed_keys.include?("space")
    move_x_obstacle = -5
  end
  if obstacle.x == 5
    obstacle.x = 1190
  end

  obstacle.x += move_x_obstacle
  player_right.x += move_x
  player_right.y += move_y

end

show
