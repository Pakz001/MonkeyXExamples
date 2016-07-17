Import mojo

Class MyGame Extends App

	' set up the triangle
	Field x1:Float=100
	Field y1:Float=100
	Field x2:Float=100
	Field y2:Float=200
	Field x3:Float=200
	Field y3:Float=100
	' collision info
	Field col:String
	
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    	If pointintriangle2d(MouseX(),MouseY(),x1,y1,x2,y2,x3,y3)
    		col="Collision"
    	Else
    		col="No Collision"
    	End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawPoly([x1,y1,x2,y2,x3,y3])
        DrawText col,0,0
    End Method
End Class

' by RaGR (Ralph G. Roeske). from blitzbasic.com
Function pointintriangle2d(px:Float,pz:Float, x1:Float,y1:Float,x2:Float,y2:Float,x3:Float,y3:Float) 
	Local bc:Float,ca:Float,ab:Float,ap:Float,bp:Float,cp:Float,abc:Float
	bc = x2*y3 - y2*x3 
	ca = x3*y1 - y3*x1 
	ab = x1*y2 - y1*x2
	ap = x1*pz - y1*px
	bp = x2*pz - y2*px
	cp = x3*pz - y3*px
	abc = Sgn(bc + ca + ab)
	If (abc*(bc-bp+cp)>=0) And (abc*(ca-cp+ap)>=0) And (abc*(ab-ap+bp)>=0) Return True
End Function

Function Main()
    New MyGame()
End Function
