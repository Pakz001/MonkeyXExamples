Strict

Import mojo

Global mapx:Int = 0
' Scrolling offset
Global mapsx:Int = 0

Global SW:Int = 0, SH:Int = 0
Global player:Image

' Multiple of tilesize
Global speed:Int = 4

Global x:Int, y:Int
Global initialPosX:Int, initialPosY:Int

Global movement:Int = 0
Global direction:String

Global showgrid:Int = 1

Const tilewidth:Int = 32
Const tileheight:Int = 32
Const tilesize:Int = 32

Const mapwidth:Int = 20
Const mapheight:Int = 15
Global map:Int[][] = [ [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
								[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
								[1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
								[1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1],
								[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
								[1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1],
								[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
									[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
									[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
									[1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
									[1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
									[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1],
								 [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
								[1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
								[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] ]

Function Main:Int()
	New TileMove
	Return True
End

Class TileMove Extends App

	Field text:String = "Monkey X Grid-Based or Tile Movement"
	Field text2:String = "Use WASD Keys to Move Player, G to Toggle Grid"

	Method OnCreate:Int()
		SetUpdateRate 60
		SW = 640 SH = 480

		player = CreateImage(tilesize, tilesize)
		' create an array for that image
		Local pixels:Int[player.Width() * player.Height()]
		' draw the color red in the pixels array
		For Local i:Int = 0 Until player.Width() * player.Height()
			pixels[i] = argb(200, 0, 0)
		Next
		' copy the array to the image
		player.WritePixels(pixels, 0, 0, player.Width(), player.Height(), 0)
 		
		player.SetHandle player.Width()/2, player.Height()/2
		x = 6 * tilesize
		y = 11 * tilesize
		initialPosX = x
		initialPosY = y

		Return True
	End

	Method OnUpdate:Int()
	
		If KeyHit(KEY_G) Then showgrid = Not showgrid
		
		If KeyDown(KEY_W)
			If movement = 0
				movement = 1
				direction = "up"
				Print "UP"
			End If
		End If
		
		If KeyDown(KEY_S)
			If movement = 0
				movement = 1
			 	direction = "down"
				Print "Down"
			End If
		End If
	
		If KeyDown(KEY_A)
			If movement = 0
				movement = 1
				direction = "left"
				Print "Left"
			End If
		End If
	
		If KeyDown(KEY_D)
			If movement = 0
				movement = 1
				direction = "right"
				Print "Right"
			End If
		End If
			
		If direction = "right" And movement
			If x <> initialPosX + tilesize
				If playertc(1, 0) = False
						x = x + speed; movement = 1
					Else
						movement = 0
				End If
			Else
				initialPosX = x; movement = 0
			End If
		End If

		If direction = "left" And movement
			If x <> initialPosX - tilesize
				If playertc(-1, 0) = False
					x = x - speed; movement = 1
				Else
		 			movement = 0
				End If
			Else
				initialPosX = x; movement = 0
			End If
		End If
		
		If direction = "up" And movement
			If y <> initialPosY - tilesize
				If playertc(0, -1) = False
					y = y - speed; movement = 1
				Else
					movement = 0
	 			End If
			Else
				initialPosY = y; movement = 0
			End If
		End If
		
		If direction = "down" And movement
			If y <> initialPosY + tilesize
				If playertc(0, 1) = False
					y = y + speed; movement = 1
				Else
					movement = 0
	 			End If
			Else
				initialPosY = y; movement = 0
			End If
		End If
		
		Return True
	End

	Method OnRender:Int()

		Cls 0, 0, 0
		
		SetColor 100, 100, 100
				
		If showgrid = 1
			For Local v:Int = 0 Until SW Step tilesize
				DrawLine v, 0, v, SH ; DrawLine 0, v, SW, v
			Next
		End If
	
		SetColor 255, 255, 255
		
		drawmap
		
		DrawImage player, x+player.Width()/2, y+player.Height()/2
		
		Local m:Int = 0
						
		If movement Then m = 1 Else m = 0

		SetAlpha .7
		DrawText(text, DeviceWidth() / 2 - TextWidth(text)/2, DeviceHeight() / 2 - 30)
		DrawText(text2, DeviceWidth() / 2 - TextWidth(text2)/2, DeviceHeight() / 2 - 10)
		SetAlpha 1
		
		Return True
	End
End

'helper function
Function argb:Int(r:Int, g:Int, b:Int , alpha:Int = 255)
	Return (alpha Shl 24) | (r Shl 16) | (g Shl 8) | b
End Function

Function drawmap:Void()
	SetColor 255, 255, 255
	For Local y:Int = 0 Until mapheight
	For Local x:Int = 0 Until mapwidth
		If map[y][x] = 1
			DrawRect x*tilewidth, y*tileheight, tilewidth, tileheight
		End If
	Next
	Next
End Function

' This function returns true if the player coordinates are inside a tile on the map.
Function playertc:Bool(x1:Int = 0, y1:Int = 0)
	Local playerx:Int = x
	Local playery:Int = y
	Local playerheight:Int = 32
	Local playerwidth:Int = 32
	Local cx:Int = (playerx + x1) / tilewidth
	Local cy:Int = (playery + y1) / tileheight
	For Local y2:Int = cy-1 Until cy+2
	For Local x2:Int = cx-1 Until cx+2
		If x2 >= 0 And x2 < mapwidth And y2 >= 0 And y2 < mapheight
			If map[y2][x2] > 0
				If rectsoverlap(playerx+x1, playery+y1, playerwidth, playerheight, x2*tilewidth, y2*tileheight, tilewidth, tileheight) = True
					Return True
				End If
			End If
		End If
	Next
	Next
	Return False
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	Return True
End
