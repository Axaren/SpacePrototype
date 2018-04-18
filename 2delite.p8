pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
player = {}
player.x=60
player.y=60
player.aim=.5
player.r=5
player.tip={}
player.br={}
player.br.x = 0
player.br.y = 0
player.bl={}
player.bl.x = 0
player.bl.y = 0
player.tip.x = 0
player.tip.y = 0
player.hp=3
player.total_hp=3
player.dx=0
player.dy=0
player.rotspeed=.025
player.accelpow=.15

t=0
bullet_spd=3
bullets = {}

function _init()
  player.x=60
  player.y=60
  player.aim=.5
  player.dx=0
  player.dy=0
  player.color=7
end

function _update()
 t+=1
 update_player()
 update_bullets()
end

function _draw()
  cls()
  draw_player()
  draw_bullets()
end

function update_player()
  player.tip.x = (sin(player.aim)*player.r)+player.x
  player.tip.y = (cos(player.aim)*player.r)+player.y
  player.br.x = (sin(player.aim+.39)*player.r)+player.x
  player.br.y = (cos(player.aim+.39)*player.r)+player.y
  player.bl.x = (sin(player.aim-.39)*player.r)+player.x
  player.bl.y = (cos(player.aim-.39)*player.r)+player.y
  player.x+=player.dx
  player.y+=player.dy

    if player.x<0 then
      player.x=128
    elseif player.x>128 then
      player.x=0
    end
    if player.y<0 then
      player.y=128
    elseif player.y>128 then
      player.y=0
    end
    if btn(0) then
      player.aim-=player.rotspeed
    end
    if btn(1) then
      player.aim+=player.rotspeed
    end
    if btn(2) then
      player.dx+=-sin(player.aim*-1)*player.accelpow
      player.dy+=cos(player.aim*-1)*player.accelpow
    end
    if btn(3) then
      if player.dx>0 then
        if player.dx-player.accelpow<=0 then
          player.dx=0
        else
          player.dx-=player.accelpow
        end
        
      elseif player.dx<0 then
        if player.dx+player.accelpow>=0 then
          player.dx=0
        else
          player.dx+=player.accelpow
        end
      end
        
      if player.dy>0 then
        if player.dy-player.accelpow<=0 then
          player.dy=0
        else
          player.dy-=player.accelpow
        end
        
      elseif player.dy<0 then
        if player.dy+player.accelpow>=0 then
          player.dy=0
        else
          player.dy+=player.accelpow
        end
      end
        
    end
    if btn(4) then
    		fire_bullet()
    end
end

function update_bullets()
  for bullet in all(bullets) do
    bullet.x+=bullet.dx
    bullet.y+=bullet.dy
    bullet.w=2
    bullet.h=2
    bullet.t-=1
    if bullet.x<0 then
      bullet.x=128
    elseif bullet.x>128 then
      bullet.x=0
    end
    if bullet.y<0 then
      bullet.y=128
    elseif bullet.y>128 then
      bullet.y=0
    end
    
				if bullet.t<=0 then
     del(bullets, bullet)
    end
        
  end
end
    
function draw_player()
  line(player.tip.x, player.tip.y, player.br.x, player.br.y, player.color)
  line(player.tip.x, player.tip.y, player.bl.x, player.bl.y, player.color)
  line(player.bl.x, player.bl.y, player.br.x, player.br.y, player.color)
end

function draw_bullets()
  for bullet in all(bullets) do
    circfill(bullet.x, bullet.y, 1, 7)
  end
end

function fire_bullet()
  if #bullets<5 then
    local bullet = {}
    bullet.dx=-sin(player.aim*-1)*bullet_spd
    bullet.dy=cos(player.aim*-1)*bullet_spd
    bullet.x=player.tip.x
    bullet.y=player.tip.y
    bullet.t=30
    add(bullets,bullet)
  end
end


function point_inside(point, rect)
  if point.x <= rect.x+rect.w and
     point.x >= rect.x and
     point.y <= rect.y+rect.h and
     point.y >= rect.y then
     return true
  end
  return false
end

function check_collision(thing1, thing2)
  if thing1.x <= thing2.x+thing2.w and
     thing1.x+thing1.w >= thing2.x and
     thing1.y+thing1.h >= thing2.y and
     thing1.y <= thing2.y+thing2.h and
     thing1.y+thing1.h >= thing2.y then
     
    return true
  end
  return false
end

