Import mojo

Class MyGame Extends App
	Field lastvalue:Int=0
	Field laststring:String
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()   
    	If KeyDown(KEY_1) Then lastvalue = 1
    	If KeyDown(KEY_2) Then lastvalue = 2
    	If KeyDown(KEY_3) Then laststring = "the string"
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
		Scale 2,2
        DrawText "Press the 1 or 2 or 3 keys",0,0
        Select lastvalue
        	Case 1
        		DrawText "Last key pressed is 1",10,20
        	Case 2
        		DrawText "Last key pressed is 2",10,20
        	Default
        		DrawText "1 or 2 key was not pressed.",10,20
        End Select
        Select laststring
        	Case "the string"
        		DrawText "3 Key was pressed.",10,40
        	Default
        		DrawText "3 Key was not pressed.",10,40
        End Select
    End Method
End Class


Function Main()
    New MyGame()
End Function
