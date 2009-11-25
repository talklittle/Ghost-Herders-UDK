// Adapted from Whizzle_Creation_Document_1_2.pdf

class GhostCharacter extends KAssetSpawnable
        placeable;

simulated function clicked()
{

}

DefaultProperties
{
    BlockRigidBody=true
    Begin Object Name=MyLightEnvironment
        bEnabled=true
    End Object
    
    Begin Object Name=KAssetSkelMeshComponent
        Animations=None
        
        // Set up the Skeletal mesh reference
        SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
        
        // Add any anim sets and anim trees for later use
        //AnimSets.Add(AnimSet'Char_Whizzle.SK.Whizzle01_Animset')
        //PhysicsAsset=PhysicsAsset'Char_Whizzle.SK.Wizzle01_Physics'
        //AnimTreeTemplate=AnimTree'Char_Whizzle.SK.Whizzle01_Animtree'
        //MorphSets(0)=MorphTargetSet'Char_Whizzle.SK.Whizzle01_MorphSet'
        
        // If the character has a Physics Asset, make sure to set this to true
        bHasPhysicsAssetInstance=true
        bUpdateKinematicBonesFromAnimation=true
        bUpdateJointsFromAnimation=true

        // Use 0 physics weight, so the character is completely moved by animation
        PhysicsWeight=0.0f
        // Collision flags that should all be set to false, so the skeletal mesh should not collide with anything
        BlockRigidBody=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        RBChannel=RBCC_GameplayPhysics
        RBCollideWithChannels=(Default=true,BlockingVolume=true,EffectPhysics=true,GameplayPhysics=true)
        // Set a high RBDominanceGroup so the GhostBall can pull the GhostCharacter, but the GhostCharacter can't have any physics pulling on the Ball
        RBDominanceGroup=30
        // Set the character to show up in the foreground by default
        DepthPriorityGroup=SDPG_Foreground
        LightingChannels=(Dynamic=TRUE,Gameplay_1=TRUE) Rotation=(Yaw=0)
    End Object

    // The main collision mesh for the Ghost - used to get RigidBodyCollision events
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
	Scale=1.0
	MotionBlurScale=1.0
	Scale3D=(X=0.25,Y=0.25,Z=0.25)
        LightEnvironment=MyLightEnvironment
        bUsePrecomputedShadows=FALSE
        StaticMesh=StaticMesh'EngineMeshes.Cube'
        BlockActors=TRUE
        BlockZeroExtent=TRUE
        BlockNonZeroExtent=TRUE
        BlockRigidBody=TRUE
        bNotifyRigidBodyCollision=true
        ScriptRigidBodyCollisionThreshold=0.001
        HiddenGame=TRUE
    End Object
    CollisionComponent=StaticMeshComponent0
    Components.Add(StaticMeshComponent0)
}

