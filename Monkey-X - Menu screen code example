Import mojo

Class MyGame Extends App
    Global menu:String[] = ["Please Select","New Game","Load","Save","Settings","About"]
    Global menuactive:Bool[menu.Length]
    Global menuindex:Int = 1
    Method OnCreate()
        SetUpdateRate(60)
        menuactive[menuindex] = True
    End Method
    Method OnUpdate()
        For Local i = 1 Until menu.Length
            Local oldmenuindex = menuindex
            Local tw = TextWidth(menu[i])
            If rectsoverlap(MouseX(),MouseY(),1,1,DeviceWidth/2-tw/2,100+i*22,100,22) = True            
                menuindex = i
                menuactive[oldmenuindex] = False
                menuactive[menuindex] = True
            End If            
        Next

        If KeyHit(KEY_DOWN)
            If menuindex < menu.Length-1
                menuactive[menuindex] = False
                menuindex+=1
                menuactive[menuindex] = True
            End If
        End If
        If KeyHit(KEY_UP)
            If menuindex > 1
                menuactive[menuindex] = False
                menuindex-=1
                menuactive[menuindex] = True
            End If
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Menu Example",10,10
        DrawText "Use cursor keys up/down to cycle through menu",10,25
        DrawText "Move mouse across menu item",10,40
        
        For Local i = 0 Until menu.Length
            If menuactive[i] = False Then
                SetColor 155,155,155
            Else
                SetColor 255,255,255
            End If
            DrawText menu[i],DeviceWidth/2,100+i*22,.5,0            
        Next
    End Method
End Class

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 > (x2 + w2) Or (x1 + w1) < x2 Then Return False
    If y1 > (y2 + h2) Or (y1 + h1) < y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End Function
