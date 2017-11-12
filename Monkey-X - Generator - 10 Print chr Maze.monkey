Import mojo

Class MyGame Extends App
	Field x:Int,y:Int
	Field spacing:Int=10
	Field map:Int[][]
    Method OnCreate()
	    SetUpdateRate(60)
    	map = New Int[100][]
    	For Local i:Int=0 Until 100
			map[i] = New Int[100]
	    Next
	    makemaze()
    End Method
    Method OnUpdate()  
	    If KeyHit(KEY_SPACE) Or MouseHit(MOUSE_LEFT)
	    	makemaze()
	    End If
    End Method
    Method OnRender()
    	Cls 0,0,0
		drawmaze()
		DrawText "Press Space or Mouse for new maze",0,0
    End Method
	Method drawmaze()		
	    For Local y:Int=0 Until 100
	    For Local x:Int=0 Until 100
	    	Select map[x][y]
	    		Case 0
	    			DrawLine x*10,y*10,x*10+10,y*10+10
	    		Case 1
	    			DrawLine x*10+10,y*10,x*10,y*10+10
	    	End Select
	    Next
	    Next
	End Method
	Method makemaze()
	    For Local y:Int=0 Until 100
	    For Local x:Int=0 Until 100
	    	If Rnd(1)<.5 Then map[x][y] = 1 Else map[x][y] = 0
	    Next
	    Next
   End Method
End Class


Function Main()
    New MyGame()
End Function
