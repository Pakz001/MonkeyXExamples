Import mojo

Class game
    Field px:Int,py:Int
    Field pw:Int,ph:Int
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Int
    Field tileheight:Int
    Field map:Int[][]
    Method New(width:Int,height:Int)
        mapwidth = width
        mapheight = height
        tilewidth = DeviceWidth()/mapwidth
        tileheight = DeviceHeight()/mapheight
        map = New Int[mapwidth][]
        For Local i=0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        For Local i=0 Until 10
            Local x:Int=Rnd(0,mapwidth)
            Local y:Int=Rnd(0,mapheight)
            map[x][y] = 1
        Next        
        pw = 16
        ph = 24
        Local exitloop:Bool=False
        While exitloop=False
            Local x:Int=Rnd(0,mapwidth)
            Local y:Int=Rnd(0,mapheight)
            If map[x][y] <> 1
                px = x*tilewidth
                py = y*tileheight
                exitloop = True
            End If
        Wend
    End Method
    Method playerupdate()
        If KeyDown(KEY_LEFT)
            px-=1
        End If
        If KeyDown(KEY_RIGHT)
            px+=1
        End If
        If KeyDown(KEY_UP)
            py-=1
        End If
        If KeyDown(KEY_DOWN)
            py+=1
        End If
        px = Clamp(px,0,DeviceWidth()-pw)
        py = Clamp(py,ph,DeviceHeight()-ph)
    End Method
    Method draw()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Local dx:Int=x*tilewidth
            Local dy:Int=y*tileheight
            If map[x][y] = 1
                SetColor 100,100,0
                DrawRect dx,dy,tilewidth,tileheight
                drawtree dx+16,dy-20

            End If
        Next
            ' Here we find if we should draw the player
            ' as to have the trees be correct with
            ' his location on the screen.
            If rectsoverlap(    px,py-32,pw,ph,
                                0,
                                y*tileheight,
                                DeviceWidth(),
                                tileheight) = True
                ' here we draw the player
                SetColor 255,255,0
                DrawRect px,py,pw,ph        
            End If
        Next
    End Method
    Method drawtree(x:Int,y:Int)
        SetColor 0,200,0
        DrawRect x-32,y-32,64,64
        SetColor 200,100,0
        DrawRect x-10,y+32,20,10
    End Method
End Class

Global mygame:game

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        Seed = GetDate[5]
        mygame = New game(20,15)
    End Method
    Method OnUpdate()    
        mygame.playerupdate    
    End Method
    Method OnRender()
        Cls 0,0,0 
        mygame.draw
        SetColor 255,255,255
        DrawText     "Monkey-X - 2d Player "+
                    "behind And infront of"+
                    " trees - code example",
                    0,10
        DrawText     "Press Cursor + left-"+
                    "right-up-down",0,
                    DeviceHeight()-20
    End Method
End Class


Function Main()
    New MyGame()
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function
