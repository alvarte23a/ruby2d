require 'ruby2d'

set title: "spelprojekt1", width: 1200, height: 675
background = Image.new("bakgrund.jpg", x: 0, y: 0)

player = Image.new("MEWOW.v2.png", x:300, y:300, width:100, height: 100)
player_flipped = Image.new("image.png",x:300, y:300, width:100, height: 100 )
#current_player = player


rectangle = Rectangle.new(
  color: 'green',
  x: 0,
  y: 575,
  width: 1200,
  height: 100
  
)


# Håller koll på nedtryckta tangenter
pressed_keys = {}

# När en tangent trycks ner
on :key_down do |event|
  pressed_keys[event.key] = true
end

# När en tangent släpps
on :key_up do |event|
  pressed_keys.delete(event.key)  # Tar bort tangenten från listan
end


velocity_y = 0          # Hastighet i Y-led
gravity = 0.5           # Gravitationseffekt
jump_strength = -10     # Hur starkt man hoppar (negativt = uppåt)
on_ground = false  

update do
  puts player.x
  puts player.y
  move_x = 0
  move_y = 0
  
  if pressed_keys["w"] && on_ground
    velocity_y = jump_strength
    on_ground = false
  end  
  velocity_y += gravity

  player.x += move_x
  player.y += velocity_y
  if player.y + player.height >= rectangle.y
    player.y = rectangle.y - player.height
    velocity_y = 0
    on_ground = true
  else
    on_ground = false
  end

  if pressed_keys["d"] && player.x !=1100
    move_x += 5
    x_pos = player.x
    y_pos = player.y
   player.remove
   player_flipped.x = x_pos
   player_flipped.y = y_pos
  end
  if pressed_keys["a"] && player.x !=0
    move_x -= 5 
  end
  if pressed_keys.empty? && 476 > player.y && 474 > player.y
    player.y += 5
  elsif pressed_keys["a"] && pressed_keys.length == 1 && 476 > player.y && 474 > player.y
    player.y += 5
  elsif pressed_keys["d"] && pressed_keys.length == 1 && 476 > player.y && 474 > player.y
    player.y += 5 
  end


  player.x += move_x
  player.y += move_y

end

show
