'diffusion limited aggregation (dla)

' This basically works like this.
' You create random walkers(dots) They move into a random direction.
' On the map there is a solid part and if the walker touches it he turns
' into a solid part. This is it.


Import mojo

' The random walker class. We only use it to store
' the x and y coordinates
Class walker
	Field x:Int,y:Int
	Field deleteme:Bool
	Method New(x:Int,y:Int)
		Self.x = x
		Self.y = y
	End Method
End Class

Class dla
	' map width/height screen width/height
	' tile width/height
	' map containing the solids parts. 
	' The walker list containing the walkers
	Field mw:Int,mh:Int,sw:Int,sh:Int
	Field tw:Float,th:Float
	Field map:Int[][]
	Field mywalker:List<walker>
	Field walkerradius:Int=1
	Field finished:Bool=False
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw) / Float(mw)
		Self.th = Float(sh) / Float(mh)
		' create our map array
		map = New Int[mw][]
		For Local i:=0 Until mw
			map[i] = New Int[mh]
		Next
		' create the solid part
		mapcircle(mw/2,mh/2)
		' create the walker list
		mywalker = New List<walker>
		'add some walkers to the list
		For Local i:=0 Until mw*mh/20
			addwalker(Rnd(4))
		Next
	End Method	
	' Here we update the walkers. We keep adding them to 
	' the screen until they have created a solid part 
	' on the most part of the screen.
	Method update()
		' speed it up	
		For Local speed:Int=0 Until 20
			' loop through each walker on the list
			For Local i:=Eachin mywalker
				' step in one of 8 directions	
				Local x:Int=Rnd(-2,2)
				Local y:Int=Rnd(-2,2)
				' if we are not moving outside of the map 
				' then update position
				If i.x+x >= 0 And i.x+x < mw Then i.x += x
				If i.y+y >= 0 And i.y+y < mh Then i.y += y
				' if we touch a solid then
				If map[i.x][i.y] = 1 Then
					' flag for deletion
					i.deleteme = True
					' if the last position was not near the edge of the screen
					If i.x > 10 And i.x < mw-10 And i.y > 10 And i.y < mh-10
						' add new walker to the border of screen
						addwalker(Rnd(4))
					End If
					' Draw the new solid
					mapcircle(i.x,i.y)
				End If
			Next
			' Go through the walker list and see if
			' we can delete any walkers from the list
			For Local i:=Eachin mywalker
				If i.deleteme = True Then mywalker.Remove(i)
			Next
		Next
		If mywalker.IsEmpty Then finished = True
	End Method
	' Add a walker to the list at a random edge location
	Method addwalker(loc:Int)
		Select loc
			Case 0'top
				mywalker.AddLast(New walker(Rnd(mw),0))
			Case 1'bottom
				mywalker.AddLast(New walker(Rnd(mw),mh-1))
			Case 2'left
				mywalker.AddLast(New walker(0,Rnd(mh)))
			Case 3'"right"
				mywalker.AddLast(New walker(mw-1,Rnd(mh)))
		End Select
	End Method
	Method mapcircle(x:Int,y:Int)
		For Local y2:=-walkerradius To walkerradius
		For Local x2:=-walkerradius To walkerradius
			Local x3:Int=x+x2
			Local y3:Int=y+y2
			If x3<0 Or y3<0 Or x3>=mw Or y3>=mh Then Continue
			map[x3][y3] = 1
		Next
		Next
	End Method
	' Draw the solid and walkers
	Method draw()
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x][y] = 1 Then
				SetColor 255,255,255
				DrawRect x*tw,y*th,tw+1,th+1
			End If
		Next
		Next
		For Local i:=Eachin mywalker
			DrawCircle i.x*tw,i.y*th,walkerradius*th
		Next
		
	End Method
End Class

Class MyGame Extends App
	Field mydla:dla
    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[4] + GetDate[5]
        mydla = New dla(DeviceWidth(),DeviceHeight(),100,100)
    End Method
    Method OnUpdate()
    	mydla.update()        
    	
    	If mydla.finished = True Then 
    		Local s:Int=Rnd(50,256)
    		mydla = New dla(DeviceWidth(),DeviceHeight(),s,s)
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mydla.draw()
    End Method
End Class


Function Main()
    New MyGame()
End Function
