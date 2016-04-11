Import mojo

Class Rectangle
  Field x:Float
  Field y:Float
  Field width:Float
  Field height:Float
  
  Method New(x:Float,y:Float,width:Float,height:Float)
    Self.x = x
    Self.y = y
    Self.width = width
    Self.height = height
  End Method
  
  Method Update()
    x = MouseX()
    y = MouseY()
  End Method

  Method draw:Void()
    DrawRect x,y,width,height
  End Method
End Class

Class MyGame Extends App
    Field rect:Rectangle
    Method OnCreate()
        rect = New Rectangle(0,0,150,150)
        SetUpdateRate(60)
    End Method
    
    Method OnUpdate()
        rect.Update()
    End Method
    
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Move the rectangle with the mouse.",0,0
        rect.draw()
    End Method
End Class

Function Main()
    New MyGame()
End Function
