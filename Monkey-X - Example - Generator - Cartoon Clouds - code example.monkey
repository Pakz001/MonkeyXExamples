Import mojo

Class cloud
	Field px:Float,py:Float
	Field pw:Int,ph:Int
	Field mx:Float
	Field sw:Int
	Method New(x:Int,y:Int,w:Int,h:Int,sw:Int)
		px = x
		py = y
		pw = w
		ph = h
		Self.sw = sw
		mx = Rnd(0.05,0.2)
	End Method
	Method update()
		px += mx
		If px > sw+pw Then px = 0-(pw*2)
	End Method
	' This method draws a cloud/
	' at x,y with width w and height h
	Method draw()
		
		' Draw 7 plumps (go around in a circle)
		For Local angle:Int=0 Until 360 Step 360/7
			Local x2:Float=Cos(angle)*pw
			Local y2:Float=Sin(angle)*ph
			SetColor 0,0,0
			DrawOval(x2+px,y2+py,pw,ph)
			SetColor 255,255,255
			DrawOval(x2+px+4,y2+py+4,pw-8,ph-8)
		Next
		' Draw a white oval to erase the center of the cloud
		SetColor 255,255,255
		DrawOval(px-pw/2,py-ph/2,pw+pw,ph+ph)
	End Method		

End Class

Class MyGame Extends App
	Field mycloud:List<cloud> = New List<cloud>
    Method OnCreate()
	    SetUpdateRate(60)
	    Seed = GetDate[4]*GetDate[5]
	    For Local i:Int = 0 Until 15
	    	mycloud.AddLast(New cloud(Rnd(-DeviceWidth*.5,DeviceWidth),Rnd(DeviceHeight),Rnd(30,130),Rnd(20,50),DeviceWidth))
	    Next
    End Method
    Method OnUpdate()  
    	For Local i:=Eachin mycloud
    		i.update()
    	Next
    End Method
    Method OnRender()
    	Cls 0,0,255
    	For Local i:=Eachin mycloud
    		i.draw()
    	Next
    End Method

End Class


Function Main()
    New MyGame()
End Function
