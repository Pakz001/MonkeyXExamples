Import mojo

Class circle
	Field x:Int,y:Int
	Field radius:Int
	Method New()
		radius = 2
		Local exitloop:Bool=False
		While exitloop = False
			exitloop=True
			Self.x = Rnd(DeviceWidth)
			Self.y = Rnd(DeviceHeight)
			For Local i:=Eachin mycircle
				If i.x = x And i.y = y Then
					Else
					If circleoverlap(	i.x,i.y,i.radius,
										x,y,2) = True Then
						exitloop=False
					End If
				End If
			Next
		Wend
	End Method
	Method grow()
		If x-radius<0 Then Return
		If x+radius>DeviceWidth Then Return
		If y-radius<0 Then Return
		If y+radius>DeviceHeight Then Return
		For Local i:=Eachin mycircle
			If i.x=x And i.y=y Then
			Else
				If circleoverlap(	x,y,radius,
									i.x,i.y,i.radius)
					Return
				End If 
			End If
		Next
		radius+=1
	End Method
	Method draw()
		SetColor 255,255,255
		DrawCircle x,y,radius
		SetColor 0,0,0
		DrawCircle x,y,radius-2
	End Method
	Function circleoverlap:Bool(x1:Int,y1:Int,r1:Int,x2:Int,y2:Int,r2:Int)
    	Local dx:Int = x1-x2
    	Local dy:Int = y1-y2
    	Local r:Int = r1+r2
    	If dx*dx+dy*dy <= r*r Then Return True Else Return False
	End Function	
End Class

Global mycircle:List<circle> = New List<circle>

Class MyGame Extends App
	Field counter:Int
    Method OnCreate()
        SetUpdateRate(5)
        mycircle.AddLast(New circle())
    End Method
    Method OnUpdate()   
    	If counter>100 Then
    		counter=0
    		mycircle = New List<circle>
    	End If
    	For Local i=0 Until 5
    		mycircle.AddLast(New circle())
    	Next
    	For Local i:=Eachin mycircle
    		i.grow
    	Next
    	counter+=1
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin mycircle
        	i.draw
        Next
    End Method
End Class


Function Main()
    New MyGame()
End Function
