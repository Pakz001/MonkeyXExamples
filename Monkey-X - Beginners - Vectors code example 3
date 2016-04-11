Import mojo

Global numfishies:Int=100

Class fishy
    Field x:Float,y:Float,speed:Float,heading:Float,size:Float
    Field headx:Float,heady:Float
    Field color:Int
    Method New(x:Float,y:Float,speed:Float,heading:Float,size:Float,color:Int)
        Self.x = x
        Self.y = y
        Self.speed = speed
        Self.heading = heading
        Self.size = size
        Self.color = color
    End Method
    Method update()
        heading+=Rnd(-10,10)
        If heading<0 Then heading=heading + 360
        If heading>359 Then heading=heading - 360
        x += vectorx(speed,heading)
        If x<0 Then x=640
        If x>640 Then x=0
        y += vectory(speed,heading)
        If y<0 Then y=480
        If y>480 Then y=0
        headx=x+vectorx(size,heading)
        heady=y+vectory(size,heading)
    End Method
    Method draw()
        SetColor color,color,color
        DrawLine x,y,headx,heady
    End Method
End Class

Global fishies:List<fishy> = New List<fishy>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until numfishies
            fishies.AddLast(New fishy(Rnd(0,640),Rnd(0,480),Rnd(2,5),Rnd(0,360),Rnd(5,10),Rnd(32,200)))
        Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin fishies
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin fishies
            i.draw
        Next
    End Method
End Class

' Thanks to Blitzcoder for the functions
';= Get horizontal size of vector using distance and angle
Function vectorx:Float(distance:Float,angle:Float)
    Return Sin(angle)*distance
End Function
';= Get vertical size of vector using distance and angle
Function vectory:Float(distance:Float,angle:Float)
    Return Sin(angle-90)*distance
End Function
';= Get True length of a vector
Function vectordistance:Float(x:Float,y:Float)
    Return Sqrt(x*x+y*y)
End Function
';= Get True angle of a vector
Function vectorangle:Float(x:Float,y:Float)
    Return -ATan2(x,y)+180
End Function


Function Main()
    New MyGame()
End Function
