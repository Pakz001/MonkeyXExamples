Import mojo

Global mleft:Bool = False
Global mright:Bool = False
Global mup:Bool = False
Global mdown:Bool = False
Global px:Int = 320
Global py:Int = 220

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
        If KeyDown(KEY_LEFT) Then mleft = True Else mleft = False
        If KeyDown(KEY_RIGHT) Then mright = True Else mright = False
        If KeyDown(KEY_UP) Then mup = True Else mup = False
        If KeyDown(KEY_DOWN) Then mdown = True Else mdown = False
        If mleft And px > 0 Then px-=1
        If mright And px <640-16 Then px+=1
        If mup And py > 0 Then py-=1
        If mdown And py <480-16 Then py+=1
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawRect(px,py,16,16)
        DrawText("Use cursors to move player",10,10)
    End
End

Function Main()
    New MyGame()
End
