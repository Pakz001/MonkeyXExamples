Import mojo

    Global playerx:Float = 6*32
    Global playery:Float = 11*32
    Const playerwidth:Int = 32
    Const playerheight:Int = 32
    Const screenwidth = 640
    Const screenheight = 480
    Const tilewidth = 32
    Const tileheight = 32
    Const mapwidth:Int=20
    Const mapheight:Int=15
    Global map:Int[][] = [      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                                [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
                                [1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,1],
                                [1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,0,0,1],
                                [1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1],
                                [1,0,1,1,1,1,1,1,1,0,0,0,1,1,0,0,1,1,1,1],
                                [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
                                  [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],                       
                                  [1,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,0,0,1],
                                  [1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1],
                                  [1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1],
                                  [1,0,0,0,0,0,0,0,0,1,1,0,1,1,1,0,0,0,0,1],
                                 [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                                [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()  
        For Local i=0 Until 2      
        If KeyDown(KEY_UP)
            If playertc(0,-1) = False
                playery-=1
            End If
        End If
        If KeyDown(KEY_DOWN)
            If playertc(0,1) = False
                playery+=1
            End If
        End If
        If KeyDown(KEY_LEFT)
            If playertc(-1,0) = False
                playerx-=1
            End If
        End If
        If KeyDown(KEY_RIGHT)
            If playertc(1,0) = False
                playerx+=1
            End If
        End If
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        drawmap
        drawplayer
        SetColor 255,255,255
        DrawText "Topdown tilemap and player movement - Use Cursor Keys to move",10,10
    End Method
End Class

Function drawplayer:Void()
    SetColor 255,255,0
    DrawOval playerx,playery,playerwidth,playerheight
End Function

Function drawmap:Void()
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[y][x] = 1
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
    Next
    Next
End Function

' This function returns true if the player coordinates are inside a tile on the map.
Function playertc:Bool(x1:Int=0,y1:Int=0)
    Local cx = (playerx + x1) / tilewidth
    Local cy = (playery + y1) / tileheight
    For Local y2=cy-1 Until cy+2
    For Local x2=cx-1 Until cx+2
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] > 0
                If rectsoverlap(playerx+x1,playery+y1,playerwidth,playerheight,x2*tilewidth,y2*tileheight,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function


Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End Function
