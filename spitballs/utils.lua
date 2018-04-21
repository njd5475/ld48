

function inside(bb1, x, y)
  return x > bb1.x and x < bb1.x+bb1.w and y > bb1.y and y < bb1.y+bb1.h
end

function insideOrTouching(bb1, x, y)
  return x >= bb1.x and x <= bb1.x+bb1.w and y >= bb1.y and y <= bb1.y+bb1.h
end

function collides(bb1, bb2)
  return  inside(bb1, bb2.x, bb2.y) or
    inside(bb1, bb2.x+bb2.w, bb2.y) or
    inside(bb1, bb2.x, bb2.y+ bb2.h) or
    inside(bb1, bb2.x+bb2.w, bb2.y+bb2.h) or
    -- now see if bb1 is inside bb2
    inside(bb2, bb1.x, bb1.y) or
    inside(bb2, bb1.x+bb1.w, bb1.y) or
    inside(bb2, bb1.x, bb1.y+ bb1.h) or
    inside(bb2, bb1.x+bb1.w, bb1.y+bb1.h)
end
