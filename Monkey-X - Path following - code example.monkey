' Path following - from the book - ai for game developers
Import mojo

Class entity
	Field tilex:Int
	Field tiley:Int
	Field entwidth:Int
	Field entheight:Int
	Field tilewidth:Float
	Field tileheight:Float
	Field mapwidth:Int
	Field mapheight:Int	
	Field direction:Int=1 ' 1 is up, 2 is upright ect clockwise
	Method New()
		mapwidth = mypathfollowing.mapwidth
		mapheight = mypathfollowing.mapheight
		entwidth = mypathfollowing.tilewidth
		entheight = mypathfollowing.tileheight
		tilewidth = mypathfollowing.tilewidth
		tileheight = mypathfollowing.tileheight
		findstartpos		
	End Method
	Method update()
		' terrain analysis
		' here we check clockwise around the entity its position
		' and fill the ta(terrainanalysis) array with 0 if there is no read there
		' and 10 if there is a road
		Local ta:Int[] = New Int[9]
		ta[1] = mypathfollowing.map[tiley-1][tilex]
		ta[2] = mypathfollowing.map[tiley-1][tilex+1]
		ta[3] = mypathfollowing.map[tiley][tilex+1]
		ta[4] = mypathfollowing.map[tiley+1][tilex+1]
		ta[5] = mypathfollowing.map[tiley+1][tilex]
		ta[6] = mypathfollowing.map[tiley+1][tilex-1]
		ta[7] = mypathfollowing.map[tiley][tilex-1]
		ta[8] = mypathfollowing.map[tiley-1][tilex-1]
		For Local i = 1 To 8
			If ta[i] = 0 
				ta[i] = 0
			Else
				ta[i] = 10
			End If
		Next
		' weighted direction analysis
		' here we use the current direction and add
		' up the current direction with 2 and left and
		' right from there with +1 and the opposite
		' direction of the entity direction -1		
		If direction = 1
			ta[1] += 2
			ta[2] += 1
			ta[8] += 1
			ta[5] -= 1
		End If
		If direction = 2
			ta[2] += 2
			ta[3] += 1
			ta[1] += 1
			ta[6] -= 1
		End If
		If direction = 3
			ta[3] += 2
			ta[4] += 1
			ta[2] += 1
			ta[7] -= 1
		End If
		If direction = 4
			ta[4] += 2
			ta[5] += 1
			ta[3] += 1
			ta[8] -= 1
		End If
		If direction = 5
			ta[5] += 2
			ta[6] += 1
			ta[4] += 1
			ta[1] -= 1
		End If
		If direction = 6
			ta[6] += 2
			ta[7] += 1
			ta[5] += 1
			ta[2] -= 1
		End If
		If direction = 7
			ta[7] += 2
			ta[8] += 1
			ta[6] += 1
			ta[3] -= 1
		End If
		If direction = 8
			ta[8] += 2
			ta[1] += 1
			ta[7] += 1
			ta[4] -= 1
		End If
		' choosing direction
		' here we get the highest weight to get the next direction
		Local maxterrain:Int
		Local maxindex:Int
		For Local i=1 To 8
			If ta[i] > maxterrain
				maxterrain = ta[i]
				maxindex = i
			End If
		Next
		' update position
		' here we use the new direction and move the entity and set
		' the new or last direction
		If maxindex = 1
			direction = 1
			tiley -= 1
		End If
		If maxindex = 2
			direction = 2
			tilex += 1
			tiley -= 1
		End If
		If maxindex = 3
			direction = 3
			tilex += 1
		End If
		If maxindex = 4
			direction = 4
			tilex += 1
			tiley += 1
		End If
		If maxindex = 5
			direction = 5
			tiley += 1
		End If
		If maxindex = 6
			direction = 6
			tilex -= 1
			tiley += 1
		End If
		If maxindex = 7
			direction = 7
			tilex -= 1
		End If
		If maxindex = 8
			direction = 8
			tilex -= 1
			tiley -= 1
		End If
	End Method
	Method findstartpos()
		For Local y=0 Until mapheight
		For Local x=0 Until mapwidth
			If mypathfollowing.map[y][x] = 1
				tilex = x
				tiley = y
				Return
			End If
		Next
		Next
	End Method
	Method draw()
		SetColor 255,255,0
		DrawRect tilex*tilewidth,tiley*tileheight,entwidth,entheight
	End Method
End Class

Class pathfollowing
Global map:Int[][] = [
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0],
[0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
[0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
[0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,0,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0],
[0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0],
[0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,0,0],
[0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
[0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
[0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]	
Field screenwidth:Int
	Field screenheight:Int
	Field mapwidth:Int
	Field mapheight:Int
	Field tilewidth:Float
	Field tileheight:Float
	Method New(width:Int,height:Int)
		mapwidth = map.Length
		mapheight = map[0].Length
		screenwidth = width
		screenheight = height
		tilewidth = Float(screenwidth)/Float(mapwidth)
		tileheight = Float(screenheight)/Float(mapheight)
	End Method
	Method draw()
		SetColor 200,100,0
		For Local y = 0 Until mapheight
		For Local x = 0 Until mapwidth
			If map[y][x] = 1
				DrawRect 	x*tilewidth,y*tileheight,
							tilewidth+1,tileheight+1
			End If
		Next
		Next
	End Method
End Class

Global mypathfollowing:pathfollowing
Global myentity:entity

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(5)
        mypathfollowing = New pathfollowing(DeviceWidth,DeviceHeight)
        myentity = New entity()
    End Method
    Method OnUpdate()        
    	myentity.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        mypathfollowing.draw
		myentity.draw
        SetColor 255,255,255
		DrawText "Monkey-X - Path Following Example",10,10
    End Method
End Class


Function Main()
    New MyGame()
End Function
