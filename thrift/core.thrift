namespace java com.github.mistertea.html5animator.thrift

const i32 VERSION = 1

enum Easing {
	EASE_IN_LINEAR,
	EASE_IN_QUAD,
	EASE_OUT_QUAD,
	EASE_IN_OUT_QUAD,
	EASE_IN_CUBIC,
	EASE_OUT_CUBIC,
	EASE_IN_OUT_CUBIC,
}


struct User
{
  1:string id = "",
  2:string name,
  3:string ipAddress,
  4:bool loggedIn = false,
}

struct UserData
{
  1:string id = "",
  128:map<string, string> lastVisited = {},
  129:map<string, set<string>> bookmarks = {},
  130:set<string> favoriteComics = {},
}

struct UserInternal
{
  1:string id = "",
  2:string password,
  3:string emailAddress,
  4:string facbeookId,
  5:string googleId,
  128:set<string> friends = []
}

struct UserSession
{
  1:string id = "",
  2:string userId,
  3:i64 createTime,
  4:map<string, string> data,
  5:i64 expirationTime = 0,
  128:i64 accessTime,
}

struct ClientErrorInfo
{
	1:string id,
	2:string browser,
	3:i32 version,
	4:string message,
	5:string url,
	6:i32 lineNumber,
}

struct Point
{
  1:i32 x,
  2:i32 y,
}

struct Color
{
  1:i16 r,
  2:i16 g,
  3:i16 b,
  4:i16 a,
}

struct Music
{
  1:string id,
  2:string name,
  3:string format,

  100:binary data,
}

struct Image
{
  1:string id,
  2:string name,
  3:string format,

  100:binary data,
}

struct Polygon
{
  1:string id,
  100:list<Point> vertices,
  101:Color lineColor,
  102:Color fillColor
}

struct Keyframe
{
  1:i64 frameTime,
  2:string imageId,
  3:string polygonId,

  100:double rotation,
  101:Point scale,
  102:Point translation,
  103:double opacity,
}

struct Renderable
{
	100:string fabricJson,
	//101:map<string,string> extraAttributes,
	102:i32 keyFrame,
	103:Easing easeAfter = Easing.EASE_IN_LINEAR;
}

struct Actor
{
	1:string id,

	// NOTE: Keep this sorted by KeyFrame
	100:list<Renderable> keyFrameRenderables = [];
}

struct Layer
{
  1:string id,
  2:bool visible = true,
  3:bool locked = false,

  100:list<Actor> actors = [],
}

struct Movie
{
  1:string id,
  2:string name,
  3:string creatorId,
  4:set<string> composerIds = {},
  5:set<string> accessIds = {},
  6:string musicId,

  100:list<Layer> layers = [],
  101:i32 frameMs = 100,
  102:Point size,
}
