' Adding binary up - getting every combination
'

Import mojo

' How long should the binary be
Global binlen:Int=14
' This contains the binary data. bin[0] is the most left
Global bin:Int[]


Class MyGame Extends App
	' keep track of the number
	Field cnt:Int=0
    Method OnCreate()
        SetUpdateRate(60)
        ' create our binary array
		bin = New Int[binlen]
    End Method
    Method OnUpdate() 
        If KeyHit(KEY_SPACE) Or MouseHit(MOUSE_LEFT) 
        	' Add one to the binary
	    	incbin
	    	' Add up one into our count
	    	cnt+=1
	   	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        Scale 2,2
        DrawText "Press Space or LMB(touch) to increase",0,0
        ' Draw the binary on the screen
		For Local i:Int=0 Until binlen
			DrawText bin[i],i*20,100
		Next
		DrawText cnt,0,120
    End Method
End Class

'We go from right to left turning each 1 into a zero until
'or if we find a 0 and then we then turn this into a 1 and then return
Function incbin()
	' Loop from right to left
	For Local i:Int=binlen-1 To 0 Step -1
		' if we encounter a 0 then turn it into a 1 and return
		If bin[i] = 0 Then 
			bin[i] = 1
			Return
		End If
		' turn the next bit into a 0
		bin[i] = 0
	Next
End Function

Function Main()
    New MyGame()
End Function
