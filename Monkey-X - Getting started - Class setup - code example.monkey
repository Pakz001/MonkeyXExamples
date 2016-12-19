Import mojo

Global screenwidth:Int=640
Global screeneight:Int=480

Class game
    ' initialisation of variables for this class.
    Field hitpoint:Int=100
    Field gold:Int=234
    Field shieldequiped:Bool=False
    Field swordequiped:Bool=False
    Method New()
        'here the game class is set up
    End Method
    Method update()
        'here you place the game logic
    End Method
    Method draw()
        ' here you place the drawing commands
    End Method
End Class

' make mygame a global variable
Global mygame:game 

Class MyGame Extends App

    Method OnCreate()
        ' frames per second (refresh rate)
        SetUpdateRate(60)
        mygame = New game()
    End Method
    Method OnUpdate()
        ' execute the game update method
        mygame.update
        ' after initialisatoin you can read/write to the variables of the class
        If KeyDown(KEY_E) Then mygame.shieldequiped = True        
    End Method
    Method OnRender()
        Cls 0,0,0 
        ' execute the game draw method
        mygame.draw
        '
        SetColor 255,255,255        
        ' use the mygame class to display information
        DrawText mygame.gold+" gold in pocket",100,100
        If mygame.shieldequiped = False Then DrawText "press 'e' to equip shield",0,0
        If mygame.shieldequiped = True Then DrawText "Shield is equiped",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
