require 'ruby2d'

set title: "spelprojekt1", width: 1200, height: 675
background = Image.new("bakgrund.jpg", x: 0, y: 0)
player_right = Image.new("meow_right.png", x:0, y:475, width:100, height: 100)
player_left = Image.new("meow_left.png",x:0, y:475, width:100, height: 100 )
text = Sprite.new("soace.png", x: 500, y: 100, width: 400  , height:400)
player_right_crouch = Image.new("crouch_right.png", x:0, y:475, width:100, height: 100)
player_left_crouch = Image.new("crouch_left.png", x:0, y:475, width:100, height:100)
obstacle = Rectangle.new(color:'black',x: 1190, y:500, width:15, height:10)
boing2 = Sound.new("boing1.wav")
boing1 = Sound.new("boing2.wav")
crouch = Sound.new("crouch_sfx.wav")
explosion = Image.new("explosion.png", x: 500, y: 100, width: 150  , height:150)
controls = Image.new("controls.png",  x: 30, y: 30, width: 200, height:200)
deathscreen = Sprite.new("deathscreen.png",x: 500, y: 30, width: 400  , height:300)
deathsfx = Sound.new("deathsfx.wav")
obstacle2 = Rectangle.new(color:'black',x: 1190, y:475, width:30, height:20)
score = 0
score_display = Text.new("Score: #{score}", x: 10, y: 10, size: 25, color: 'white')

blink_timer = 0
blink_speed = 30
rectangle = Rectangle.new(
  color: '#b3c43a',
  x: 0,
  y: 575,
  width: 1200,
  height: 100
  
)
$current_player = player_right
def switch_to(player_to_show)
  $current_player.remove
  player_to_show.x = $current_player.x
  player_to_show.y = $current_player.y
  $current_player = player_to_show
  $current_player.add
end


# Håller koll på nedtryckta tangenter
all_pressed_keys = {}

on :key_down do |event|
  all_pressed_keys[event.key] = true  # lägg till nyckeln med ett värde
#  puts all_pressed_keys.keys          # skriver ut alla tangenter som tryckts ner
end
on :key_down do |event|
  if event.key == 's'
    crouch.play
    end
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
keys_held = {}

# When a key is pressed
on :key_down do |event|
  keys_held[event.key] = true
end

# When a key is released
on :key_up do |event|
  keys_held[event.key] = false
end


velocity_y = 0 
gravity = 0.5
jump_strength = -15
on_ground = false  

facing_left = false
facing_right = false
text_exist = false
key_down = false
is_crouching = false
randomizertick = 0
dead = false
bgframe = 0
audio_played = false
obstacle2speed = 5
boost_at_3 = false
boost_at_5 = false
boost_at_7 = false
boost_at_11 = false
boost_at_16 = false
boost_at_21= false
boost_at_29= false
boost_at_39= false
boost_at_50= false


update do




  if all_pressed_keys.include?("space") && dead == false
bgframe += 0.2   # Increase bgframe first
bgframe = (bgframe * 10).round / 10.0
  end
    if dead == true && !audio_played
      deathscreen.add
      deathsfx.play
      audio_played = true
    elsif dead == false
      deathscreen.remove
    end
    if pressed_keys["space"] && dead == true
        audio_played = false
      dead = false
      player_right.x = 0
      player_right.y = 475
    end

randomizertick += 1
#putsr randomizertick

# bgframe
if all_pressed_keys.include?("space") 
blink_timer += 0
text_exist = true
else 
  blink_timer += 1
end

if randomizertick % 60==0
  p
end

if (blink_timer / blink_speed) % 2 == 0
  text.add 
elsif (blink_timer / blink_speed) % 2 != 0
  text.remove
end
 #puts player_right.x
#uts player_right.y
  move_x = 0
  move_y = 0
  move_x_obstacle = 0
  move_x_obstacle2 = 0
player_left_crouch.remove
player_right_crouch.remove
player_left.remove
#deathscreen.remove
obstacle2.remove
if dead == false 
  explosion.remove
end
current_player = player_right
  
  if pressed_keys["w"] && on_ground && dead == false
    velocity_y = jump_strength
    on_ground = false
    boing1.play if randomizertick % 2 == 0
    boing2.play if randomizertick % 2 != 0
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

  if pressed_keys["d"] && current_player.x < 1100 && !pressed_keys["s"] && dead == false
    switch_to(player_right)
    move_x += 5
  end
  if pressed_keys["d"] && pressed_keys["s"] && dead == false
    move_x +=5
  end
    if pressed_keys["a"] && pressed_keys["s"] && dead == false 
    move_x -=5
  end
 
  if pressed_keys["d"]
    facing_left = false
    facing_right = true
  end
  
  if pressed_keys["a"] && current_player.x > 0 && !pressed_keys["s"] && dead == false
    switch_to(player_left)
    move_x -= 5
  end
  if pressed_keys["a"] && dead == false
    facing_right = false
    facing_left = true
  end

  if  facing_left == true
    player_left.x = current_player.x
    player_left.y = current_player.y
    player_left.add
  end
  if facing_right == true
    player_right.x = current_player.x 
    player_right.y = current_player.y 
    player_right.add
  end

  if all_pressed_keys.include?("space") 
    move_x_obstacle = -5

  end
  if obstacle.x < 5
    obstacle.x = 1190
    score += 1
  end
    if obstacle2.x < 5
    obstacle2.x = 1190
        score += 1

  end
  if score == 3 && !boost_at_3
    obstacle2speed += 1
    boost_at_3 = true
  end

  if score == 5 && !boost_at_5
    obstacle2speed += 1
    boost_at_5 = true
  end

  if score == 7 && !boost_at_7
    obstacle2speed += 1
    boost_at_7 = true
  end
    if score == 11 && !boost_at_11
    obstacle2speed += 1
    boost_at_11 = true
  end

  if score == 16 && !boost_at_16
    obstacle2speed += 1
    boost_at_16 = true
  end

  if score == 21 && !boost_at_21
    obstacle2speed += 1
    boost_at_21 = true
  end
    if score == 29 && !boost_at_29
    obstacle2speed += 1
    boost_at_29 = true
  end
      if score == 39 && !boost_at_39
    obstacle2speed += 3
    boost_at_39 = true
  end
      if score == 50 && !boost_at_50
    obstacle2speed += 5
    boost_at_50 = true
  end

  if pressed_keys["s"] && facing_left == true
    is_crouching = true
    current_player.remove
    player_left_crouch.x = current_player.x 
    player_left_crouch.y = current_player.y 
    current_player = player_left_crouch
    current_player.add
  end

  if pressed_keys["s"] && facing_right == true
    is_crouching = true
    current_player.remove
    player_right_crouch.x = current_player.x 
    player_right_crouch.y = current_player.y 
    current_player = player_right_crouch
    current_player.add
  end
  if !keys_held["s"]
    is_crouching = false
    player_left_crouch.remove
    player_right_crouch.remove
  end
  if keys_held["s"]
    player_left.remove
    player_right.remove
  end

 if 200 < randomizertick && all_pressed_keys.include?("space") 
  obstacle2.add
  move_x_obstacle2 = -obstacle2speed
 end
 puts obstacle2speed
  obstacle.x += move_x_obstacle
  obstacle2.x += move_x_obstacle2
  player_right.x += move_x
  player_right.y += move_y

if text_exist == true
  text.remove
end
if player_right.y > obstacle.y - 30 && player_right.y < obstacle.y + 30 &&
   player_right.x > obstacle.x - 30 && player_right.x < obstacle.x + 30 && !keys_held["s"]
  explosion.x = current_player.x - 30
  explosion.y = current_player.y - 30
  explosion.add
  dead = true
end
if player_right.y > obstacle2.y - 30 && player_right.y < obstacle2.y + 30 &&
   player_right.x > obstacle2.x - 30 && player_right.x < obstacle2.x + 30 && !keys_held["s"]
  explosion.x = current_player.x - 30
  explosion.y = current_player.y - 30
  explosion.add
  dead = true
end

  if bgframe == 1
    background.remove
    background = Image.new('frame1.png', x: 0, y: 0, z: -1)
    #puts 1
  elsif bgframe == 2
    background.remove
    background = Image.new('frame2.png', x: 0, y: 0, z: -1)
   # puts 2
  elsif bgframe == 3
    background.remove
    background = Image.new('frame3.png', x: 0, y: 0, z: -1)
 #   puts 3
  elsif bgframe == 4
    background.remove
    background = Image.new('frame4.png', x: 0, y: 0, z: -1)
 #   puts 4
  elsif bgframe == 5
    background.remove
    background = Image.new('frame5.png', x: 0, y: 0, z: -1)
 #   puts 5
  elsif bgframe == 6
    background.remove
    background = Image.new('frame6.png', x: 0, y: 0, z: -1)
 #   puts 6
  elsif bgframe == 7
    background.remove
    background = Image.new('frame7.png', x: 0, y: 0, z: -1)
 #   puts 7
  elsif bgframe == 8
    background.remove
    background = Image.new('frame8.png', x: 0, y: 0, z: -1)
 #   puts 8
  elsif bgframe == 9
    background.remove
    background = Image.new('frame9.png', x: 0, y: 0, z: -1)
 #   puts 9
  elsif bgframe == 10
    background.remove
    background = Image.new('frame10.png', x: 0, y: 0, z: -1)
 #   puts 10
  elsif bgframe == 11
    background.remove
    background = Image.new('frame11.png', x: 0, y: 0, z: -1)
  #  puts 11
  elsif bgframe == 12
    background.remove
    background = Image.new('frame12.png', x: 0, y: 0, z: -1)
  #  puts 12
  elsif bgframe == 13
    background.remove
    background = Image.new('frame13.png', x: 0, y: 0, z: -1)
  #  puts 13
  elsif bgframe == 14
    background.remove
    background = Image.new('frame14.png', x: 0, y: 0, z: -1)
 #   puts 14
  elsif bgframe == 15
    background.remove
    background = Image.new('frame15.png', x: 0, y: 0, z: -1)
 #   puts 15
  elsif bgframe == 16
    background.remove
    background = Image.new('frame16.png', x: 0, y: 0, z: -1)
 #   puts 16
  elsif bgframe == 17
    background.remove
    background = Image.new('frame17.png', x: 0, y: 0, z: -1)
 #   puts 17
  elsif bgframe == 18
    background.remove
    background = Image.new('frame18.png', x: 0, y: 0, z: -1)
 #   puts 18
    bgframe = 0


end
  score_display.text = "Score: #{score}"
end
show
