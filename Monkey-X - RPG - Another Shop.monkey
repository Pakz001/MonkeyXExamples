Import mojo

Class items
	Field name:String
	Field def:Int
	Field att:Int
	Field val:Int
End Class

Class shop
	Field playeritems:List<items> = New List<items>
	Field playerinvenx:Int=0
	Field playerinveny:Int=20
	Field playerinvenw:Int=310
	Field playerinvenh:Int=400
	Field shopinvenx:Int=320
	Field shopinveny:Int=20
	Field shopinvenw:Int=310
	Field shopinvenh:Int=300
	Field leftx:Int=320
	Field lefty:Int=340
	Field leftw:Int=155
	Field lefth:Int=50
	Field rightx:Int=475
	Field righty:Int=340
	Field rightw:Int=155
	Field righth:Int=50
	Field upx:Int=320
	Field upy:Int=390
	Field upw:Int=155
	Field uph:Int=50
	Field downx:Int=475
	Field downy:Int=390
	Field downw:Int=155
	Field downh:Int=50
	Field actiont:String="Action"
	Field actionx:Int=155
	Field actiony:Int=420
	Field actionw:Int=155
	Field actionh:Int=50
	Field exitx:Int=0
	Field exity:Int=420
	Field exitw:Int=132
	Field exith:Int=50
	Method New()
	End Method
	Method draw()
		' player inventory
		drawbox playerinvenx,playerinveny,playerinvenw,playerinvenh	
		drawtext "Inventory",playerinvenx+10,playerinveny+10,2
		drawbox shopinvenx,shopinveny,shopinvenw,shopinvenh
		drawtext "Shop Inventory",shopinvenx+10,shopinveny+10,2
		' input
		drawbox leftx,lefty,leftw,lefth
		drawtext "Left",leftx+10,lefty+10,2
		drawbox rightx,righty,rightw,righth
		drawtext "Right",rightx+10,righty+10,2
		drawbox upx,upy,upw,uph
		drawtext "Up",upx+10,upy+10,2
		drawbox downx,downy,downw,downh
		drawtext "Down",downx+10,downy+10,2
		' action button
		drawbox actionx,actiony,actionw,actionh
		drawtext actiont,actionx+10,actiony+10,2
		' exit button
		drawbox exitx,exity,exitw,exith
		drawtext "Exit",exitx+10,exity+10,2
	End Method
	Method drawtext(t:String,x:Int,y:Int,_scale:Float)
        PushMatrix
        Scale _scale,_scale
        DrawText t,x/_scale,y/_scale
        PopMatrix
	End Method
	Method drawbox:Void(x:Int,y:Int,w:Int,h:Int)
	    DrawLine x,y,x+w,y
	    DrawLine x,y,x,y+h
	    DrawLine x,y+h,x+w,y+h
	    DrawLine x+w,y,x+w,y+h
	End Method
End Class

Global myshop:shop

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        myshop = New shop()
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        myshop.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
