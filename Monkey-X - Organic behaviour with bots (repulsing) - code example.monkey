Import mojo

Const numbots:Int=50
Global screenwidth:Int=640
Global screenheight:Int=480
Global map:Int[screenwidth][]  ' used for storing the position of the bots and collision checking

Class bots
    Field x:Float
    Field y:Float
    Field radius:Int=24
    Field repel:Float=0.8
    Field north:Float
    Field east:Float
    Field south:Float
    Field west:Float
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
    End Method
    Method update()
         ' here we increase with the repel value if there are bots there
         '
        ' check north
        For Local x1=0 Until radius
        For Local y1=0 Until radius
            Local x2:Int=x1+(x-radius/2)
            Local y2:Int=y-y1
            If x2>=0 And y2>=0 And x2<screenwidth And y2<screenheight
            If map[x2][y2] = 1 Then north += repel
            End If
        Next
        Next
        ' check east
        For Local x1=0 Until radius
        For Local y1=0 Until radius
            Local x2:Int=x1+x
            Local y2:Int=y-radius/2+y1
            If x2>=0 And y2>=0 And x2<screenwidth And y2<screenheight
            If map[x2][y2] = 1 Then east += repel
            End If
        Next
        Next
        ' check south
        For Local x1=0 Until radius
        For Local y1=0 Until radius
            Local x2:Int=(x-radius/2)+x1
            Local y2:Int=y+y1
            If x2>=0 And y2>=0 And x2<screenwidth And y2<screenheight
            If map[x2][y2] = 1 Then south += repel
            End If
        Next
        Next
        ' check west
        For Local x1=0 Until radius
        For Local y1=0 Until radius
            Local x2:Int=x-x1
            Local y2:Int=(y-radius/2)+y1
            If x2>=0 And y2>=0 And x2<screenwidth And y2<screenheight
            If map[x2][y2] = 1 Then west += repel
            End If
        Next
        Next

        ' keep them inside a area in the middle of the screen
        If x > 640-100 Then east+=repel
        If x < 100 Then west+=repel
        If y > 480-100 Then south+=repel
        If y < 100 Then north+=repel

        ' random movement
        If Rnd(0,10) < 2 Then
            Select Int(Rnd(0,5))
                Case 1 ; north+=repel
                Case 2 ; east+=repel
                Case 3 ; south+=repel
                Case 4 ; west+=repel
            End Select
        End If

        ' slowly decrease the reppelent
        north=north*.9
        east=east*.9
        south=south*.9
        west=west*.9
        
        ' move the bots
        map[x][y] = 0
        y=y+north
        x=x-east
        y=y-south
        x=x+west
        map[x][y] = 1
                
        ' keep inside boundries        
        If x<=0 Then x=0
        If y<=0 Then y=0
        If x>=screenwidth Then x=screenwidth-1
        If y>=screenheight Then y=screenheight-1                    
    
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x-3,y-3,6,6
    End Method
End Class

Global bot:List<bots> = New List<bots>


Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until screenwidth
            map[i] = New Int[screenheight]
        Next

        For Local i=0 To numbots
            bot.AddLast(New bots(Rnd(640-200)+100,Rnd(480-300)+150))
        Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin bot
            i.update
        Next        
    End Method
    Method OnRender()
        Cls 0,0,0 
        For Local i:=Eachin bot
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Organic like behaviour with bots - repulse n/e/s/w",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
