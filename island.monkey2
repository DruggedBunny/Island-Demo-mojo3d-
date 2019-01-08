
' Model credits at end of source.

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"
#Import "<mojo3d-loaders>"

#Import "aerialcamera"
#Import "plane"
#Import "bullet"
#Import "marker"

#Import "assets/"

Using std..
Using mojo..
Using mojo3d..

Class IslandDemo Extends Window

	' Set this to True for ground self-shadowing on decent desktop PCs:
	
	Const GROUND_SHADOWS:Bool		= False
	
	Const WINDOW_WIDTH:Int			= 640
	Const WINDOW_HEIGHT:Int			= 480
	Const WINDOW_FLAGS:WindowFlags	= WindowFlags.Resizable

'	Const WINDOW_WIDTH:Int			= 1920
'	Const WINDOW_HEIGHT:Int			= 1080
'	Const WINDOW_FLAGS:WindowFlags	= WindowFlags.Fullscreen

	Field scene:Scene
	Field camera:AerialCamera
	Field plane:PlaneBehaviour
	
	Method New (title:String = "Island Demo", width:Int = WINDOW_WIDTH, height:Int = WINDOW_HEIGHT, flags:WindowFlags = WINDOW_FLAGS)
		Super.New (title, width, height, flags)
	End
	 
	Method OnCreateWindow () Override

		scene									= Scene.GetCurrent ()

			scene.ClearColor					= New Color (0.2, 0.6, 1.0)
			scene.AmbientLight					= scene.ClearColor * 0.25
			scene.FogColor						= scene.ClearColor
			scene.FogNear						= 128
			scene.FogFar						= 2048

		camera									= New AerialCamera (App.ActiveWindow.Rect, Null, 4096)
		
		Local light:Light						= New Light

			light.CastsShadow					= True
	
			light.Rotate (45, 45, 0)
		
		Local ground_size:Float					= 4096 * 0.5
		Local ground_box:Boxf					= New Boxf (-ground_size, -ground_size * 0.5, -ground_size, ground_size, 0, ground_size)
		Local ground_model:Model				= Model.Load ("asset::model_gltf_6G3x4Sgg6iX_7QCCWe9sgpb\model.gltf")'CreateBox( groundBox,1,1,1,groundMaterial )

			ground_model.CastsShadow			= GROUND_SHADOWS
			
			ground_model.Mesh.FitVertices (ground_box, False)
			
			For Local mat:Material = Eachin ground_model.Materials
				mat.CullMode = CullMode.Back	
			Next

		Local ground_collider:MeshCollider		= ground_model.AddComponent <MeshCollider> ()

			ground_collider.Mesh				= ground_model.Mesh
		
		Local ground_body:RigidBody				= ground_model.AddComponent <RigidBody> ()

			ground_body.Mass					= 0

		Local plane_model:Model					= Model.Load ("asset::1397 Jet_gltf_3B3Pa6BHXn1_fKZwaiJPXpf\1397 Jet.gltf")

		Local mass:Float						= 10954.0

		Local pitch_rate:Float					= 175000.0
		Local roll_rate:Float					= 550000.0
		Local yaw_rate:Float					= 100000.0
	
		plane = New PlaneBehaviour (plane_model, mass, pitch_rate, roll_rate, yaw_rate)

		Mouse.PointerVisible					= False
		
	End
	
	Method OnRender (canvas:Canvas) Override
	
		If Keyboard.KeyHit (Key.Escape) Then App.Terminate ()

		If Keyboard.KeyDown (Key.Space) Then BulletBehaviour.CreateBullet (plane.Entity)
		
		RequestRender ()
		scene.Update ()
		
		camera.Update (plane)
		camera.Render (canvas)
		
		canvas.DrawText ("FPS: " + App.FPS, 0, 0)
		canvas.DrawText ("Flight controls: Cursors for roll & pitch, Q/E for yaw", 0, 40)
		canvas.DrawText ("Throttle: A/Z", 0, 60)
		canvas.DrawText ("Fire cannon: Space", 0, 80)

	End
	
End

Class Entity Extension

	Method RollFactor:Float ()
		Return Sin (Basis.GetRoll ())
	End

End

Class Mesh Extension

	' Thanks, DoctorWhoof!

	Method Rotate (pitch:Float, yaw:Float, roll:Float)
		TransformVertices (AffineMat4f.Rotation (Radians (pitch), Radians(yaw), Radians (roll)))
	End
	
End

Function Main ()

	New AppInstance
	New IslandDemo
	
	App.Run ()

End

' Model credits -- thanks to the authors!

' Unmodified GLTF models from sources below.

' Model: "A little Irish island"

' 		Author

'			John Huikku:	https://poly.google.com/user/1b9F61Bj5l9
'			Source:			https://poly.google.com/view/6G3x4Sgg6iX

'		License

'			Attribution 3.0 Unported (CC BY 3.0) aka. "CC-BY 3.0"
'			https://creativecommons.org/licenses/by/3.0/
'			https://support.google.com/poly/answer/7418679

' Model: "Jet"

'		Author

'			Poly by Google:	https://poly.google.com/user/1b9F61Bj5l9
'			Source:			https://poly.google.com/view/3B3Pa6BHXn1

'		License

'			Attribution 3.0 Unported (CC BY 3.0) aka. "CC-BY 3.0"
'			https://creativecommons.org/licenses/by/3.0/
'			https://support.google.com/poly/answer/7418679
