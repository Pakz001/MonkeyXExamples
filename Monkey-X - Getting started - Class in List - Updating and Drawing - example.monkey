Import mojo

' what is the size of the screen.
Global screenwidth:Int=640
Global screenheight:Int=480

Class alien
	' initialisation of variables for this class.
	Field ax:Int
	Field ay:Int
	Field deleteme:Bool=False
	Method New(x:Int,y:Int)
		' assign the location of the alien
		ax = x
		ay = y		
	End Method
	Method update()'update method
		' copy the mouse x and y into local variables
		Local x:Int=MouseX()
		Local y:Int=MouseY()
		If MouseDown(MOUSE_LEFT) 'if mouse pressed
		If rectsoverlap(x,y,1,1,ax,ay,16,16) 'if ontop of alien
			deleteme = True 'flag for deletion
		End If
		End If
	End Method
	Method draw() 'draw method
		SetColor 255,255,255
		DrawRect ax,ay,16,16
	End Method
	' little helper function
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    	If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    	Return True
	End Function	
End Class

' Start a list to store classes into
Global myalien:List<alien> = New List<alien>

Class MyGame Extends App

    Method OnCreate()
    	' frames per second (refresh rate)
        SetUpdateRate(60)
        For Local i=0 Until 50
        	myalien.AddLast(New alien(Rnd(screenwidth),Rnd(screenheight)))
        Next
    End Method
    Method OnUpdate()
    	'update the alien
    	For Local i:=Eachin myalien
			i.update
		Next
		'delete from list if set for deletion
		For Local i:=Eachin myalien
			If i.deleteme = True Then myalien.Remove(i)
		Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        'draw the aliens
		For Local i:=Eachin myalien
			i.draw
		Next
		SetColor 255,255,255
		DrawText "Press on a alien to make him disappear.",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
