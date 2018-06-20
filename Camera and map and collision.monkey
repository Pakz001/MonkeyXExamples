Import mojo

Global mapw:Int=200
Global maph:Int=200
Global screenw:Int=640
Global screenh:Int=480
Global tilew:Float=16
Global tileh:Float=16
'number of tiles on screen
Global tilesx:Int = screenw / tilew
Global tilesy:Int = screenh / tileh

Class player
	Field px:Int,py:Int
	Field pw:Int,ph:Int
	Method New()
		px = screenw / 2
		py = screenh / 2
		pw = 16
		ph = 32
	End Method
	Method update()
		If playermapcollide(0,1)=False Then 
			mymap.movecameray(1)
		End If
	End Method
	Method playermapcollide:Bool(ox:Int,oy:Int)
		Local tx:Int=mymap.camerax/tilew
		Local ty:Int=mymap.cameray/tileh
		Local offx:Int=tx*tilew-mymap.camerax
		Local offy:Int=ty*tileh-mymap.cameray
		offx-=ox
		offy-=oy
		For Local y=0 Until tilesy
		For Local x=0 Until tilesx
			Select mymap.map[x+tx][y+ty]
				Case 0
				Case 1
					If rectsoverlap(px,py,pw,ph,(x*tilew)+offx,(y*tileh)+offy,tilew,tileh)
						Return True
					End If
			End Select
		Next
		Next
		Return False		
	End Method
	Method draw()
		SetColor 255,0,0
		DrawRect px,py,pw,ph
	End Method
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)  
		If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False  
	  	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False  
		Return True  
	End Function  
End Class

Class map
	Field camerax:Float=mapw/2*tilew,cameray:Float=(maph-50)*tileh
	Field maxcamerax:Int=(mapw*tilew)-(screenw)
	Field maxcameray:Int=(maph*tileh)-(screenh)
	' the map array
	Field map:Int[][]
	Method New()
		' set up the map array
		map = New Int[mapw][]
		For Local i:Int=0 Until mapw
			map[i] = New Int[maph]
		Next
		generate()
	End Method
	Method generate()
		' borders
		For Local x:Int=0 Until mapw
			map[x][0] = 1
			map[x][maph-1] = 1
		Next
		For Local y:Int=0 Until maph
			map[0][y] = 1
			map[mapw-1][y] = 1
		Next
		blockrect(1,0,maph-20,mapw,20)
	End Method
	Method movecamerax(x:Int)
		Local comp:Int=camerax+x
		If comp < 0 Or comp > maxcamerax Then Return
		camerax+=x
	End Method
	Method movecameray(y:Int)
		Local comp:Int=cameray+y
		If comp < 0 Or comp > maxcameray Then Return
		cameray+=y
	End Method
	' Draw a section of tiles into the map
	Method blockrect(tile:Int,x:Int,y:Int,w:Int,h:Int)
		For Local y2:Int=y Until y+h
		For Local x2:Int=x Until x+w
			If x2<0 Or x2>=mapw Or y2<0 Or y2>=maph Then Continue
			map[x2][y2] = tile
		Next
		Next
	End Method
	Method draw()
		Local tx:Int=camerax/tilew
		Local ty:Int=cameray/tileh
		Local offx:Int=tx*tilew-camerax
		Local offy:Int=ty*tileh-cameray
		For Local y=0 Until tilesy
		For Local x=0 Until tilesx
			Select map[x+tx][y+ty]
				Case 0
				Case 1
					drawtile(0,(x*tilew)+offx,(y*tileh)+offy)
			End Select
		Next
		Next
	End Method
	Method drawtile(tile:Int,x:Int,y:Int)
		SetColor 255,255,255
		DrawRect x,y,tilew+1,tileh+1
	End Method
End Class

Global mymap:map
global myplayer:player

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        mymap = New map()
        myplayer = New player()
    End Method
    Method OnUpdate()        
		myplayer.update()

    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw()
        myplayer.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
