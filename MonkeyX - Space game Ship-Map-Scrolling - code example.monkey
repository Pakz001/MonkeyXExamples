Import mojo

Global tilewidth:Int=32
Global tileheight:Int=32
Global ang:Float=0
Global thrust:Float=2
' poly shape
Global ship:Float[]=[    -5.0,-5.0,
                         5.0,0.0,
                         -5.0,5.0]  

Class map
    Field mapx:Float=0
    Field mapy:Float=0
    Field map:Int[][] = [    [0,0,0,1,0,1,0,1,0,1,0,1,0,0,0],
                            [0,0,0,0,1,0,0,0,0,0,1,0,0,0,0],
                            [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
                            [0,1,0,0,0,0,1,1,1,0,0,0,0,1,0],
                            [0,1,0,1,0,0,1,0,1,0,0,1,0,1,0],
                            [0,1,0,0,0,0,1,1,1,0,0,0,0,1,0],
                            [0,1,0,1,0,1,0,0,0,1,0,1,0,1,0],
                            [0,1,0,0,1,0,0,0,0,0,1,0,0,1,0],
                            [0,0,0,1,0,1,0,1,0,1,0,1,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]                                                                                                                                                                                                    
    Method New()        
    End Method
    Method update()
           mymap.mapx -= Cos(ang)*thrust
           mymap.mapy -= Sin(ang)*thrust        
    End Method
    Method draw()
        SetColor 155,155,155
        For Local y=0 Until 10
        For Local x=0 Until 15
            If map[y][x] = 1
                DrawRect     x*tilewidth+mapx,
                            y*tileheight+mapy,
                            tilewidth,
                            tileheight
            End If
        Next
        Next
    End Method
End Class

Global mymap:map = New map()

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate() 
        ang+=1
        If ang>360 Then ang=0
        mymap.update
    End Method
    Method OnRender()
        Cls 0,0,0  
        mymap.draw                
        SetColor 255,255,255
        PushMatrix()
        Translate DeviceWidth()/2,DeviceHeight()/2
        Rotate(-ang)
        Scale(4,4)
        DrawPoly(ship)
        PopMatrix()  
        Translate 0,0
        SetColor 255,0,0
        DrawLine    DeviceWidth()/2,
                      DeviceHeight()/2,
                    DeviceWidth()/2+Cos(ang)*64,
                    DeviceHeight()/2+Sin(ang)*64
                    SetColor 255,255,255
           DrawText "MonkeyX - Space game ship/map/scrolling example",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
