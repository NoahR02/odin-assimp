package assimp

when ODIN_OS == .Windows {
	foreign import assimp "libs/assimp-vc143-mt.lib"
} else {
	foreign import assimp "system:assimp"
}

@(default_calling_convention="c", link_prefix="ai")
foreign assimp {
	ImportFile                 :: proc(path: cstring, flags: u32) -> ^Scene ---
	ReleaseImport              :: proc(scene: ^Scene) ---
	GetErrorString             :: proc() -> cstring ---
	IdentityMatrix4            :: proc(dest: ^Mat4) ---
	MultiplyMatrix4            :: proc(dest: ^Mat4, src: ^Mat4) ---
	TransformVecByMatrix4      :: proc(vec: ^Vector3D, mat: ^Mat4) ---
	TransformVecByMatrix3      :: proc(vec: ^Vector3D, mat: ^Mat3) ---
	Matrix3FromMatrix4         :: proc(dest: ^Mat3, src: ^Mat4) ---

	GetMaterialFloatArray :: proc(
		material: ^Material,
		key:       cstring,
		type:      TextureType,
		index:     u32,
		out:      ^f32,
		max:      ^u32,
	) ---

	GetMaterialColor :: proc(
		material: ^Material,
		key:       cstring,
		type:      TextureType,
		index:     u32,
		out:      ^Color4D,
	) ---

	GetMaterialTextureCount :: proc(material: ^Material, type: TextureType) -> u32 ---

	GetMaterialTexture :: proc(
		material: ^Material,
		type: TextureType,
		index: u32,
		path: ^String,
		mapping: ^TextureMapping = nil,
		uv_index: ^u32 = nil,
		blend: ^f32 = nil,
		op: ^TextureOp = nil,
		mapmode: ^TextureMapMode = nil,
		flags: ^u32 = nil,
	) ---
}

PostProcessFlags :: enum(u32) {
	CalcTangentSpace         = 0x00000001,
	JoinIdenticalVertices    = 0x00000002,
	MakeLeftHanded           = 0x00000004,
	Triangulate              = 0x00000008,
	RemoveComponent          = 0x00000010,
	GenNormals               = 0x00000020,
	GenSmoothNormals         = 0x00000040,
	SplitLargeMeshes         = 0x00000080,
	PreTransformVertices     = 0x00000100,
	LimitBoneWeights         = 0x00000200,
	ValidateDataStructure    = 0x00000400,
	ImproveCacheLocality     = 0x00000800,
	RemoveRedundantMaterials = 0x00001000,
	FixInfacingNormals       = 0x00002000,
	PoplateArmatureData      = 0x00004000,
	SortByPType              = 0x00008000,
	FindDegenerates          = 0x00010000,
	FindInvalidData          = 0x00020000,
	GenUVCoords              = 0x00040000,
	TransformUVCoords        = 0x00080000,
	FindInstances            = 0x00100000,
	OptimizeMeshes           = 0x00200000,
	OptimizeGraph            = 0x00400000,
	FlipUVs                  = 0x00800000,
	FlipWindingOrder         = 0x01000000,
	SplitByBoneCount         = 0x02000000,
	Debone                   = 0x04000000,
	GlobalScale              = 0x08000000,
	EmbedTextures            = 0x10000000,
	ForceGenNormals          = 0x20000000,
	DropNormals              = 0x40000000,
	GenBoundingBoxes         = 0x80000000,
}

SceneFlags :: enum(u32) {
	Incomplete        = 0x01,
	Validated         = 0x02,
	ValidationWarning = 0x04,
	NonVerboseFormat  = 0x08,
	FlagsTerrain      = 0x10,
	AllowShared       = 0x20,
}

Scene :: struct {
	flags:              u32,
	root_node:         ^Node,
	num_meshes:         u32,
	meshes:         [^]^Mesh,
	num_materials:      u32,
	materials:      [^]^Material,
	num_animations:     u32,
	animations:     [^]^Animation,
	num_textures:       u32,
	textures:       [^]^Texture,
	num_lights:         u32,
	lights:         [^]^Light,
	num_cameras:        u32,
	cameras:        [^]^Camera,
	metadata:          ^Metadata,
	name:               String,
	skeletons:      [^]^Skeleton,
	private_data_do_not_touch: rawptr,
}

Node :: struct {
	name:             String,
	transform:        Mat4,
	parent:          ^Node,
	num_children:     u32,
	children:     [^]^Node,
	num_meshes:       u32,
	meshes:        [^]u32,
	metadata:        ^Metadata,
}

PrimitiveType :: enum(u32) {
	Point            = 0x01,
	Line             = 0x02,
	Triangle         = 0x04,
	Polygon          = 0x08,
	NGonEncodingFlag = 0x10,
}

MAX_NUMBER_OF_COLOR_SETS    :: 0x8
MAX_NUMBER_OF_TEXTURECOORDS :: 0x8

MAX_FACE_INDICES :: 0x7fff
MAX_BONE_WEIGHTS :: 0x7fffffff
MAX_VERTICES     :: 0x7fffffff
MAX_FACES        :: 0x7fffffff

MorphingMethod :: enum(u32) {
	VertexBlend     = 0x1,
	MorphNormalized = 0x2,
	MorphRelative   = 0x3,
}

Mesh :: struct {
	primitive_types:       u32,
	num_vertices:          u32,
	num_faces:             u32,
	vertices:           [^]Vector3D,
	normals:            [^]Vector3D,
	tangents:           [^]Vector3D,
	bitangents:         [^]Vector3D,
	colors:               [MAX_NUMBER_OF_COLOR_SETS]^Color4D,
	texture_coords:       [MAX_NUMBER_OF_TEXTURECOORDS][^]Vector3D,
	num_uv_components:    [MAX_NUMBER_OF_TEXTURECOORDS]u32,
	faces:              [^]Face,
	num_bones:             u32,
	bones:             [^]^Bone,
	material_index:        u32,
	name:                  String,
	num_anim_meshes:       u32,
	anim_meshes:       [^]^AnimMesh,
	method:                MorphingMethod,
	aabb:                  AABB,
	texture_coords_names: [^]^String,
}

AnimMesh :: struct {
	name:              String,
	vertices:       [^]Vector3D,
	normals:        [^]Vector3D,
	tangents:       [^]Vector3D,
	bitangents:     [^]Vector3D,
	colors:           [MAX_NUMBER_OF_COLOR_SETS]^Color4D,
	texture_coords:   [MAX_NUMBER_OF_TEXTURECOORDS]^Vector3D,
	num_vertices:      u32,
	weight:            f32,
}

Face :: struct {
	num_indices:    u32,
	indices:     [^]u32,
}

Bone :: struct {
	name:           String,
	num_weights:    u32,
	weights:     [^]VertexWeight,
	offset_mat:     Mat4,
}

VertexWeight :: struct {
	vertex_id: u32,
	weight:    f32,
}

SkeletonBone :: struct {
	parent:         i32,
	num_weights:    u32,
	mesh_id:       ^Mesh,
	weights:     [^]VertexWeight,
	offset_mat:     Mat4,
	local_mat:      Mat4,
}

Skeleton :: struct {
	name:          String,
	num_bones:     u32,
	bones:     [^]^SkeletonBone,
}

TextureOp :: enum(u32) {
	Multiply  = 0x0,
	Add       = 0x1,
	Subtract  = 0x2,
	Divide    = 0x3,
	SmoothAdd = 0x4,
	SignedAdd = 0x5,
}

TextureMapMode :: enum(u32) {
	Wrap   = 0x0,
	Clamp  = 0x1,
	Decal  = 0x3,
	Mirrow = 0x2,
}

TextureMapping :: enum(u32) {
	UV       = 0x0,
	Sphere   = 0x1,
	Cylinder = 0x2,
	Box      = 0x3,
	Plane    = 0x4,
	Other    = 0x5,
}

TEXTURE_TYPE_MAX :: TextureType.Transmission

TextureType :: enum(u32) {
	None             = 0,
	Diffuse          = 1,
	Specular         = 2,
	Ambient          = 3,
	Emissive         = 4,
	Height           = 5,
	Normals          = 6,
	Shininess        = 7,
	Opacity          = 8,
	Displacement     = 9,
	Lightmap         = 10,
	Reflection       = 11,
	BaseColor        = 12,
	NormalCamera     = 13,
	EmissionColor    = 14,
	Metalness        = 15,
	DiffuseRoughness = 16,
	AmbientOcclusion = 17,
	Sheen            = 19,
	Clearcoat        = 20,
	Transmission     = 21,
	Unknown          = 18,
}

ShadingMode :: enum(u32) {
	Flat         = 0x1,
	Gouraud      = 0x2,
	Phong        = 0x3,
	Blinn        = 0x4,
	Toon         = 0x5,
	OrenNayar    = 0x6,
	Minnaert     = 0x7,
	CookTorrance = 0x8,
	NoShading    = 0x9,
	Unlit        = 0x9,
	Fresnel      = 0xa,
	PbrBrdf      = 0xb,
}

TextureFlags :: enum(u32) {
	Invert      = 0x1,
	UseAlpha    = 0x2,
	IgnoreAlpha = 0x4,
}

BlendMode :: enum(u32) {
	Default  = 0x0,
	Additive = 0x1,
}

UVTransform :: struct {
	translation: Vector2D,
	scaling:     Vector2D,
	rotation:    f32,
}

PropertyTypeInfo :: enum(u32) {
	Float   = 0x1,
	Double  = 0x2,
	String  = 0x3,
	Integer = 0x4,
	Buffer  = 0x5,
}

MATKEY_SHININESS_KEY :: "$mat.shininess"
MATKEY_SHININESS_TY  :: TextureType.None
MATKEY_SHININESS_IDX :: 0

MATKEY_ROUGHNESS_FACTOR_KEY :: "$mat.roughnessFactor"
MATKEY_ROUGHNESS_FACTOR_TY  :: TextureType.None
MATKEY_ROUGHNESS_FACTOR_IDX :: 0

MATKEY_COLOR_DIFFUSE_KEY :: "$clr.diffuse"
MATKEY_COLOR_DIFFUSE_TY  :: TextureType.None
MATKEY_COLOR_DIFFUSE_IDX :: 0

MATKEY_COLOR_BASE_KEY :: "$clr.base"
MATKEY_COLOR_BASE_TY  :: TextureType.None
MATKEY_COLOR_BASE_IDX :: 0

MaterialProperty :: struct {
	key:            String,
	semantic:       u32,
	index:          u32,
	data_length:    u32,
	type:           PropertyTypeInfo,
	data:        [^]u8,
}

Material :: struct {
	properties:     [^]^MaterialProperty,
	num_properties:     u32,
	num_allocated:      u32,
}

Animation :: struct {
	name:                        String,
	duration:                    f64,
	ticks_per_sec:               f64,
	num_channels:                u32,
	channels:                [^]^NodeAnim,
	num_mesh_channels:           u32,
	mesh_channels:           [^]^MeshAnim,
	num_morph_mesh_channels:     u32,
	morph_mesh_channels:     [^]^MeshMorphAnim,
}

AnimBehavior :: enum(u32) {
	Default  = 0x0,
	Constant = 0x1,
	Linear   = 0x2,
	Repeat   = 0x3,
}

MeshMorphKey :: struct {
	time:                      f64,
	values:                 [^]u32,
	weights:                [^]f64,
	num_values_and_weights:    u32,
}

MeshKey :: struct {
	time:  f64,
	value: u32,
}

VectorKey :: struct {
	time:  f64,
	value: Vector3D,
}

QuatKey :: struct {
	time:  f64,
	value: Quat,
}

NodeAnim :: struct {
	name:                 String,
	num_position_keys:    u32,
	position_keys:     [^]VectorKey,
	num_rotation_keys:    u32,
	rotation_keys:     [^]QuatKey,
	num_scaling_keys:     u32,
	scaling_keys:      [^]VectorKey,
	pre_state:            AnimBehavior,
	post_state:           AnimBehavior,
}

MeshAnim :: struct {
	name:        String,
	num_keys:    u32,
	keys:     [^]MeshKey,
}

MeshMorphAnim :: struct {
	name:     String,
	num_keys: u32,
	keys:     MeshMorphKey,
}

HINT_MAX_TEXTURE_LEN :: 9

Texture :: struct {
	width:          u32,
	height:         u32,
	format_hint:   [HINT_MAX_TEXTURE_LEN]u8,
	data:        [^]Texel,
	filename:       String,
}

Texel :: struct {
	b, g, r, a: u8,
}

LightSourceType :: enum(u32) {
	Undefined   = 0x0,
	Directional = 0x1,
	Point       = 0x2,
	Spot        = 0x3,
	Ambient     = 0x4,
	Area        = 0x5,
}

Light :: struct {
	name:                  String,
	type:                  LightSourceType,
	position:              Vector3D,
	direction:             Vector3D,
	up:                    Vector3D,
	attenuation_constant:  f32,
	attenuation_linear:    f32,
	attenuation_quadratic: f32,
	color_diffuse:         Color3D,
	color_specular:        Color3D,
	color_ambient:         Color3D,
	angle_inner_cone:      f32,
	angle_outer_cone:      f32,
	size:                  Vector2D,
}

Camera :: struct {
	name:            String,
	position:        Vector3D,
	up:              Vector3D,
	look_at:         Vector3D,
	h_fov:           f32,
	clip_plane_near: f32,
	clip_plane_far:  f32,
	aspect_ratio:    f32,
	ortho_width:     f32,
}

MetadataType :: enum(u32) {
	Bool       = 0,
	Int32      = 1,
	UInt32     = 2,
	Float      = 3,
	Double     = 4,
	AIString   = 5,
	AIVector3D = 6,
	AIMetadata = 7,
	MetaMax    = 8,
}

Metadata :: struct {
	num_properties:    u32,
	keys:           [^]String,
	values:         [^]MetadataEntry,
}

MetadataEntry :: struct {
	type: MetadataType,
	data: rawptr,
}

MAX_STRING_LEN :: 1024

String :: struct {
	length: u32,
	data: [MAX_STRING_LEN]u8,
}

Vector2D :: distinct [2]f32
Vector3D :: distinct [3]f32

// w, x, y, z
Quat :: distinct [4]f32

Mat3 :: distinct matrix[3, 3]f32
Mat4 :: distinct matrix[4, 4]f32

AABB :: struct {
	min, max: Vector3D,
}

Color3D :: distinct [3]f32
Color4D :: distinct [4]f32
