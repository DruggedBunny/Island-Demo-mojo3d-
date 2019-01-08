
Const BULLET_LENGTH:Float	= 15.0
Const REMOVE_DISTANCE:Float	= 750.0

Class BulletBehaviour Extends Behaviour

	Global BulletModel:Model
	Global LastBullet:Entity
	
	Field start_pos:Vec3f
	
	Function CreateBullet (parent:Entity)
	
		If Not LastBullet

			BulletModel			= Model.CreateCylinder (0.33, BULLET_LENGTH, Axis.Z, 8, New PbrMaterial (Color.White))
			BulletModel.Visible	= False

			New BulletBehaviour (BulletModel.Copy (parent))

		Else
			If LastBullet.Position.Distance (parent.Position) > BULLET_LENGTH * 2.5
				New BulletBehaviour (BulletModel.Copy (parent))
			Endif
		Endif
		
	End
	
	Method New (entity:Entity)

		Super.New (entity)
		AddInstance ()
		
	End
	
	Method OnStart () Override
	
		Entity.Visible					= True
		Entity.Move (0, -2, 15)

		Local bullet_velocity:Vec3f		= Entity.Parent.RigidBody.LinearVelocity + (Entity.Basis * New Vec3f (0, 0, 300))
		
		Entity.Parent					= Null
		
		Local collider:CylinderCollider	= Entity.AddComponent <CylinderCollider> ()
		
			collider.Radius				= 1.0
			collider.Axis				= Axis.Z
		
		Local body:RigidBody			= Entity.AddComponent <RigidBody> ()
			
			body.Collided				=	Lambda (other_body:RigidBody)
												
												MarkerBehaviour.Create (Entity)
												
												Entity.Destroy ()
												
											End

' Additional function test: note += syntax to add to functions called... uncomment to try!

'			body.Collided				+=	Lambda (other_body:RigidBody)
'												Print "Hi"
'											End
		
		start_pos						= Entity.Position
		
		LastBullet						= Entity
		
		Select Int (Rnd (4))
		
			Case 0
				Entity.Color			= Color.White
			Case 1
				Entity.Color			= Color.Yellow
			Case 2
				Entity.Color			= Color.Orange
			Case 3
				Entity.Color			= Color.Red
			
		End
		
		Local model:Model				= Cast <Model> (Entity)
		Local pbrm:PbrMaterial			= Cast <PbrMaterial> (model.Material)

			pbrm.EmissiveFactor			= Entity.Color

		Entity.RigidBody.ApplyImpulse (bullet_velocity)

	End
	
	Method OnUpdate (elapsed:Float) Override
		
		Entity.RigidBody.ApplyForce (New Vec3f (0.0, -40.0, 0.0))
		
		If Entity.Position.Distance (start_pos) > REMOVE_DISTANCE
			Entity.Destroy ()
		Endif
		
	End
	
End
