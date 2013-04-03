//
// Autogenerated by Thrift Compiler (0.9.0-dev)
//
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
//

Easing = {
'EASE_IN_LINEAR' : 0,
'EASE_IN_QUAD' : 1,
'EASE_OUT_QUAD' : 2,
'EASE_IN_OUT_QUAD' : 3,
'EASE_IN_CUBIC' : 4,
'EASE_OUT_CUBIC' : 5,
'EASE_IN_OUT_CUBIC' : 6
};
Point = function(args) {
  this.x = null;
  this.y = null;
  if (args) {
    if (args.x !== undefined) {
      this.x = args.x;
    }
    if (args.y !== undefined) {
      this.y = args.y;
    }
  }
};
Point.prototype = {};
Point.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.I32) {
        this.x = input.readI32().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.I32) {
        this.y = input.readI32().value;
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Point.prototype.write = function(output) {
  output.writeStructBegin('Point');
  if (this.x !== null && this.x !== undefined) {
    output.writeFieldBegin('x', Thrift.Type.I32, 1);
    output.writeI32(this.x);
    output.writeFieldEnd();
  }
  if (this.y !== null && this.y !== undefined) {
    output.writeFieldBegin('y', Thrift.Type.I32, 2);
    output.writeI32(this.y);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Color = function(args) {
  this.r = null;
  this.g = null;
  this.b = null;
  this.a = null;
  if (args) {
    if (args.r !== undefined) {
      this.r = args.r;
    }
    if (args.g !== undefined) {
      this.g = args.g;
    }
    if (args.b !== undefined) {
      this.b = args.b;
    }
    if (args.a !== undefined) {
      this.a = args.a;
    }
  }
};
Color.prototype = {};
Color.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.I16) {
        this.r = input.readI16().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.I16) {
        this.g = input.readI16().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.I16) {
        this.b = input.readI16().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 4:
      if (ftype == Thrift.Type.I16) {
        this.a = input.readI16().value;
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Color.prototype.write = function(output) {
  output.writeStructBegin('Color');
  if (this.r !== null && this.r !== undefined) {
    output.writeFieldBegin('r', Thrift.Type.I16, 1);
    output.writeI16(this.r);
    output.writeFieldEnd();
  }
  if (this.g !== null && this.g !== undefined) {
    output.writeFieldBegin('g', Thrift.Type.I16, 2);
    output.writeI16(this.g);
    output.writeFieldEnd();
  }
  if (this.b !== null && this.b !== undefined) {
    output.writeFieldBegin('b', Thrift.Type.I16, 3);
    output.writeI16(this.b);
    output.writeFieldEnd();
  }
  if (this.a !== null && this.a !== undefined) {
    output.writeFieldBegin('a', Thrift.Type.I16, 4);
    output.writeI16(this.a);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Music = function(args) {
  this.id = null;
  this.name = null;
  this.format = null;
  this.data = null;
  if (args) {
    if (args.id !== undefined) {
      this.id = args.id;
    }
    if (args.name !== undefined) {
      this.name = args.name;
    }
    if (args.format !== undefined) {
      this.format = args.format;
    }
    if (args.data !== undefined) {
      this.data = args.data;
    }
  }
};
Music.prototype = {};
Music.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.id = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.STRING) {
        this.name = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.STRING) {
        this.format = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.STRING) {
        this.data = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Music.prototype.write = function(output) {
  output.writeStructBegin('Music');
  if (this.id !== null && this.id !== undefined) {
    output.writeFieldBegin('id', Thrift.Type.STRING, 1);
    output.writeString(this.id);
    output.writeFieldEnd();
  }
  if (this.name !== null && this.name !== undefined) {
    output.writeFieldBegin('name', Thrift.Type.STRING, 2);
    output.writeString(this.name);
    output.writeFieldEnd();
  }
  if (this.format !== null && this.format !== undefined) {
    output.writeFieldBegin('format', Thrift.Type.STRING, 3);
    output.writeString(this.format);
    output.writeFieldEnd();
  }
  if (this.data !== null && this.data !== undefined) {
    output.writeFieldBegin('data', Thrift.Type.STRING, 100);
    output.writeString(this.data);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Image = function(args) {
  this.id = null;
  this.name = null;
  this.format = null;
  this.data = null;
  if (args) {
    if (args.id !== undefined) {
      this.id = args.id;
    }
    if (args.name !== undefined) {
      this.name = args.name;
    }
    if (args.format !== undefined) {
      this.format = args.format;
    }
    if (args.data !== undefined) {
      this.data = args.data;
    }
  }
};
Image.prototype = {};
Image.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.id = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.STRING) {
        this.name = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.STRING) {
        this.format = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.STRING) {
        this.data = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Image.prototype.write = function(output) {
  output.writeStructBegin('Image');
  if (this.id !== null && this.id !== undefined) {
    output.writeFieldBegin('id', Thrift.Type.STRING, 1);
    output.writeString(this.id);
    output.writeFieldEnd();
  }
  if (this.name !== null && this.name !== undefined) {
    output.writeFieldBegin('name', Thrift.Type.STRING, 2);
    output.writeString(this.name);
    output.writeFieldEnd();
  }
  if (this.format !== null && this.format !== undefined) {
    output.writeFieldBegin('format', Thrift.Type.STRING, 3);
    output.writeString(this.format);
    output.writeFieldEnd();
  }
  if (this.data !== null && this.data !== undefined) {
    output.writeFieldBegin('data', Thrift.Type.STRING, 100);
    output.writeString(this.data);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Polygon = function(args) {
  this.id = null;
  this.vertices = null;
  this.lineColor = null;
  this.fillColor = null;
  if (args) {
    if (args.id !== undefined) {
      this.id = args.id;
    }
    if (args.vertices !== undefined) {
      this.vertices = args.vertices;
    }
    if (args.lineColor !== undefined) {
      this.lineColor = args.lineColor;
    }
    if (args.fillColor !== undefined) {
      this.fillColor = args.fillColor;
    }
  }
};
Polygon.prototype = {};
Polygon.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.id = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.LIST) {
        var _size0 = 0;
        var _rtmp34;
        this.vertices = [];
        var _etype3 = 0;
        _rtmp34 = input.readListBegin();
        _etype3 = _rtmp34.etype;
        _size0 = _rtmp34.size;
        for (var _i5 = 0; _i5 < _size0; ++_i5)
        {
          var elem6 = null;
          elem6 = new Point();
          elem6.read(input);
          this.vertices.push(elem6);
        }
        input.readListEnd();
      } else {
        input.skip(ftype);
      }
      break;
      case 101:
      if (ftype == Thrift.Type.STRUCT) {
        this.lineColor = new Color();
        this.lineColor.read(input);
      } else {
        input.skip(ftype);
      }
      break;
      case 102:
      if (ftype == Thrift.Type.STRUCT) {
        this.fillColor = new Color();
        this.fillColor.read(input);
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Polygon.prototype.write = function(output) {
  output.writeStructBegin('Polygon');
  if (this.id !== null && this.id !== undefined) {
    output.writeFieldBegin('id', Thrift.Type.STRING, 1);
    output.writeString(this.id);
    output.writeFieldEnd();
  }
  if (this.vertices !== null && this.vertices !== undefined) {
    output.writeFieldBegin('vertices', Thrift.Type.LIST, 100);
    output.writeListBegin(Thrift.Type.STRUCT, this.vertices.length);
    for (var iter7 in this.vertices)
    {
      if (this.vertices.hasOwnProperty(iter7))
      {
        iter7 = this.vertices[iter7];
        iter7.write(output);
      }
    }
    output.writeListEnd();
    output.writeFieldEnd();
  }
  if (this.lineColor !== null && this.lineColor !== undefined) {
    output.writeFieldBegin('lineColor', Thrift.Type.STRUCT, 101);
    this.lineColor.write(output);
    output.writeFieldEnd();
  }
  if (this.fillColor !== null && this.fillColor !== undefined) {
    output.writeFieldBegin('fillColor', Thrift.Type.STRUCT, 102);
    this.fillColor.write(output);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Keyframe = function(args) {
  this.frameTime = null;
  this.imageId = null;
  this.polygonId = null;
  this.rotation = null;
  this.scale = null;
  this.translation = null;
  this.opacity = null;
  this.destroy = false;
  if (args) {
    if (args.frameTime !== undefined) {
      this.frameTime = args.frameTime;
    }
    if (args.imageId !== undefined) {
      this.imageId = args.imageId;
    }
    if (args.polygonId !== undefined) {
      this.polygonId = args.polygonId;
    }
    if (args.rotation !== undefined) {
      this.rotation = args.rotation;
    }
    if (args.scale !== undefined) {
      this.scale = args.scale;
    }
    if (args.translation !== undefined) {
      this.translation = args.translation;
    }
    if (args.opacity !== undefined) {
      this.opacity = args.opacity;
    }
    if (args.destroy !== undefined) {
      this.destroy = args.destroy;
    }
  }
};
Keyframe.prototype = {};
Keyframe.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.I64) {
        this.frameTime = input.readI64().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.STRING) {
        this.imageId = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.STRING) {
        this.polygonId = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.DOUBLE) {
        this.rotation = input.readDouble().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 101:
      if (ftype == Thrift.Type.STRUCT) {
        this.scale = new Point();
        this.scale.read(input);
      } else {
        input.skip(ftype);
      }
      break;
      case 102:
      if (ftype == Thrift.Type.STRUCT) {
        this.translation = new Point();
        this.translation.read(input);
      } else {
        input.skip(ftype);
      }
      break;
      case 103:
      if (ftype == Thrift.Type.DOUBLE) {
        this.opacity = input.readDouble().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 104:
      if (ftype == Thrift.Type.BOOL) {
        this.destroy = input.readBool().value;
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Keyframe.prototype.write = function(output) {
  output.writeStructBegin('Keyframe');
  if (this.frameTime !== null && this.frameTime !== undefined) {
    output.writeFieldBegin('frameTime', Thrift.Type.I64, 1);
    output.writeI64(this.frameTime);
    output.writeFieldEnd();
  }
  if (this.imageId !== null && this.imageId !== undefined) {
    output.writeFieldBegin('imageId', Thrift.Type.STRING, 2);
    output.writeString(this.imageId);
    output.writeFieldEnd();
  }
  if (this.polygonId !== null && this.polygonId !== undefined) {
    output.writeFieldBegin('polygonId', Thrift.Type.STRING, 3);
    output.writeString(this.polygonId);
    output.writeFieldEnd();
  }
  if (this.rotation !== null && this.rotation !== undefined) {
    output.writeFieldBegin('rotation', Thrift.Type.DOUBLE, 100);
    output.writeDouble(this.rotation);
    output.writeFieldEnd();
  }
  if (this.scale !== null && this.scale !== undefined) {
    output.writeFieldBegin('scale', Thrift.Type.STRUCT, 101);
    this.scale.write(output);
    output.writeFieldEnd();
  }
  if (this.translation !== null && this.translation !== undefined) {
    output.writeFieldBegin('translation', Thrift.Type.STRUCT, 102);
    this.translation.write(output);
    output.writeFieldEnd();
  }
  if (this.opacity !== null && this.opacity !== undefined) {
    output.writeFieldBegin('opacity', Thrift.Type.DOUBLE, 103);
    output.writeDouble(this.opacity);
    output.writeFieldEnd();
  }
  if (this.destroy !== null && this.destroy !== undefined) {
    output.writeFieldBegin('destroy', Thrift.Type.BOOL, 104);
    output.writeBool(this.destroy);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Renderable = function(args) {
  this.fabricJson = null;
  this.keyFrame = null;
  this.easeAfter = 0;
  if (args) {
    if (args.fabricJson !== undefined) {
      this.fabricJson = args.fabricJson;
    }
    if (args.keyFrame !== undefined) {
      this.keyFrame = args.keyFrame;
    }
    if (args.easeAfter !== undefined) {
      this.easeAfter = args.easeAfter;
    }
  }
};
Renderable.prototype = {};
Renderable.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 100:
      if (ftype == Thrift.Type.STRING) {
        this.fabricJson = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 102:
      if (ftype == Thrift.Type.I32) {
        this.keyFrame = input.readI32().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 103:
      if (ftype == Thrift.Type.I32) {
        this.easeAfter = input.readI32().value;
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Renderable.prototype.write = function(output) {
  output.writeStructBegin('Renderable');
  if (this.fabricJson !== null && this.fabricJson !== undefined) {
    output.writeFieldBegin('fabricJson', Thrift.Type.STRING, 100);
    output.writeString(this.fabricJson);
    output.writeFieldEnd();
  }
  if (this.keyFrame !== null && this.keyFrame !== undefined) {
    output.writeFieldBegin('keyFrame', Thrift.Type.I32, 102);
    output.writeI32(this.keyFrame);
    output.writeFieldEnd();
  }
  if (this.easeAfter !== null && this.easeAfter !== undefined) {
    output.writeFieldBegin('easeAfter', Thrift.Type.I32, 103);
    output.writeI32(this.easeAfter);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Actor = function(args) {
  this.id = null;
  this.keyFrameRenderables = [];
  if (args) {
    if (args.id !== undefined) {
      this.id = args.id;
    }
    if (args.keyFrameRenderables !== undefined) {
      this.keyFrameRenderables = args.keyFrameRenderables;
    }
  }
};
Actor.prototype = {};
Actor.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.id = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.LIST) {
        var _size8 = 0;
        var _rtmp312;
        this.keyFrameRenderables = [];
        var _etype11 = 0;
        _rtmp312 = input.readListBegin();
        _etype11 = _rtmp312.etype;
        _size8 = _rtmp312.size;
        for (var _i13 = 0; _i13 < _size8; ++_i13)
        {
          var elem14 = null;
          elem14 = new Renderable();
          elem14.read(input);
          this.keyFrameRenderables.push(elem14);
        }
        input.readListEnd();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Actor.prototype.write = function(output) {
  output.writeStructBegin('Actor');
  if (this.id !== null && this.id !== undefined) {
    output.writeFieldBegin('id', Thrift.Type.STRING, 1);
    output.writeString(this.id);
    output.writeFieldEnd();
  }
  if (this.keyFrameRenderables !== null && this.keyFrameRenderables !== undefined) {
    output.writeFieldBegin('keyFrameRenderables', Thrift.Type.LIST, 100);
    output.writeListBegin(Thrift.Type.STRUCT, this.keyFrameRenderables.length);
    for (var iter15 in this.keyFrameRenderables)
    {
      if (this.keyFrameRenderables.hasOwnProperty(iter15))
      {
        iter15 = this.keyFrameRenderables[iter15];
        iter15.write(output);
      }
    }
    output.writeListEnd();
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Layer = function(args) {
  this.id = null;
  this.visible = true;
  this.locked = false;
  this.actors = [];
  if (args) {
    if (args.id !== undefined) {
      this.id = args.id;
    }
    if (args.visible !== undefined) {
      this.visible = args.visible;
    }
    if (args.locked !== undefined) {
      this.locked = args.locked;
    }
    if (args.actors !== undefined) {
      this.actors = args.actors;
    }
  }
};
Layer.prototype = {};
Layer.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.id = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.BOOL) {
        this.visible = input.readBool().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.BOOL) {
        this.locked = input.readBool().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.LIST) {
        var _size16 = 0;
        var _rtmp320;
        this.actors = [];
        var _etype19 = 0;
        _rtmp320 = input.readListBegin();
        _etype19 = _rtmp320.etype;
        _size16 = _rtmp320.size;
        for (var _i21 = 0; _i21 < _size16; ++_i21)
        {
          var elem22 = null;
          elem22 = new Actor();
          elem22.read(input);
          this.actors.push(elem22);
        }
        input.readListEnd();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Layer.prototype.write = function(output) {
  output.writeStructBegin('Layer');
  if (this.id !== null && this.id !== undefined) {
    output.writeFieldBegin('id', Thrift.Type.STRING, 1);
    output.writeString(this.id);
    output.writeFieldEnd();
  }
  if (this.visible !== null && this.visible !== undefined) {
    output.writeFieldBegin('visible', Thrift.Type.BOOL, 2);
    output.writeBool(this.visible);
    output.writeFieldEnd();
  }
  if (this.locked !== null && this.locked !== undefined) {
    output.writeFieldBegin('locked', Thrift.Type.BOOL, 3);
    output.writeBool(this.locked);
    output.writeFieldEnd();
  }
  if (this.actors !== null && this.actors !== undefined) {
    output.writeFieldBegin('actors', Thrift.Type.LIST, 100);
    output.writeListBegin(Thrift.Type.STRUCT, this.actors.length);
    for (var iter23 in this.actors)
    {
      if (this.actors.hasOwnProperty(iter23))
      {
        iter23 = this.actors[iter23];
        iter23.write(output);
      }
    }
    output.writeListEnd();
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

Movie = function(args) {
  this.id = null;
  this.name = null;
  this.creatorId = null;
  this.composerIds = [];
  this.accessIds = [];
  this.musicId = null;
  this.layers = [];
  this.frameMs = 100;
  this.size = null;
  if (args) {
    if (args.id !== undefined) {
      this.id = args.id;
    }
    if (args.name !== undefined) {
      this.name = args.name;
    }
    if (args.creatorId !== undefined) {
      this.creatorId = args.creatorId;
    }
    if (args.composerIds !== undefined) {
      this.composerIds = args.composerIds;
    }
    if (args.accessIds !== undefined) {
      this.accessIds = args.accessIds;
    }
    if (args.musicId !== undefined) {
      this.musicId = args.musicId;
    }
    if (args.layers !== undefined) {
      this.layers = args.layers;
    }
    if (args.frameMs !== undefined) {
      this.frameMs = args.frameMs;
    }
    if (args.size !== undefined) {
      this.size = args.size;
    }
  }
};
Movie.prototype = {};
Movie.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.id = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.STRING) {
        this.name = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.STRING) {
        this.creatorId = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 4:
      if (ftype == Thrift.Type.SET) {
        var _size24 = 0;
        var _rtmp328;
        this.composerIds = [];
        var _etype27 = 0;
        _rtmp328 = input.readSetBegin();
        _etype27 = _rtmp328.etype;
        _size24 = _rtmp328.size;
        for (var _i29 = 0; _i29 < _size24; ++_i29)
        {
          var elem30 = null;
          elem30 = input.readString().value;
          this.composerIds.push(elem30);
        }
        input.readSetEnd();
      } else {
        input.skip(ftype);
      }
      break;
      case 5:
      if (ftype == Thrift.Type.SET) {
        var _size31 = 0;
        var _rtmp335;
        this.accessIds = [];
        var _etype34 = 0;
        _rtmp335 = input.readSetBegin();
        _etype34 = _rtmp335.etype;
        _size31 = _rtmp335.size;
        for (var _i36 = 0; _i36 < _size31; ++_i36)
        {
          var elem37 = null;
          elem37 = input.readString().value;
          this.accessIds.push(elem37);
        }
        input.readSetEnd();
      } else {
        input.skip(ftype);
      }
      break;
      case 6:
      if (ftype == Thrift.Type.STRING) {
        this.musicId = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 100:
      if (ftype == Thrift.Type.LIST) {
        var _size38 = 0;
        var _rtmp342;
        this.layers = [];
        var _etype41 = 0;
        _rtmp342 = input.readListBegin();
        _etype41 = _rtmp342.etype;
        _size38 = _rtmp342.size;
        for (var _i43 = 0; _i43 < _size38; ++_i43)
        {
          var elem44 = null;
          elem44 = new Layer();
          elem44.read(input);
          this.layers.push(elem44);
        }
        input.readListEnd();
      } else {
        input.skip(ftype);
      }
      break;
      case 101:
      if (ftype == Thrift.Type.I32) {
        this.frameMs = input.readI32().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 102:
      if (ftype == Thrift.Type.STRUCT) {
        this.size = new Point();
        this.size.read(input);
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

Movie.prototype.write = function(output) {
  output.writeStructBegin('Movie');
  if (this.id !== null && this.id !== undefined) {
    output.writeFieldBegin('id', Thrift.Type.STRING, 1);
    output.writeString(this.id);
    output.writeFieldEnd();
  }
  if (this.name !== null && this.name !== undefined) {
    output.writeFieldBegin('name', Thrift.Type.STRING, 2);
    output.writeString(this.name);
    output.writeFieldEnd();
  }
  if (this.creatorId !== null && this.creatorId !== undefined) {
    output.writeFieldBegin('creatorId', Thrift.Type.STRING, 3);
    output.writeString(this.creatorId);
    output.writeFieldEnd();
  }
  if (this.composerIds !== null && this.composerIds !== undefined) {
    output.writeFieldBegin('composerIds', Thrift.Type.SET, 4);
    output.writeSetBegin(Thrift.Type.STRING, this.composerIds.length);
    for (var iter45 in this.composerIds)
    {
      if (this.composerIds.hasOwnProperty(iter45))
      {
        iter45 = this.composerIds[iter45];
        output.writeString(iter45);
      }
    }
    output.writeSetEnd();
    output.writeFieldEnd();
  }
  if (this.accessIds !== null && this.accessIds !== undefined) {
    output.writeFieldBegin('accessIds', Thrift.Type.SET, 5);
    output.writeSetBegin(Thrift.Type.STRING, this.accessIds.length);
    for (var iter46 in this.accessIds)
    {
      if (this.accessIds.hasOwnProperty(iter46))
      {
        iter46 = this.accessIds[iter46];
        output.writeString(iter46);
      }
    }
    output.writeSetEnd();
    output.writeFieldEnd();
  }
  if (this.musicId !== null && this.musicId !== undefined) {
    output.writeFieldBegin('musicId', Thrift.Type.STRING, 6);
    output.writeString(this.musicId);
    output.writeFieldEnd();
  }
  if (this.layers !== null && this.layers !== undefined) {
    output.writeFieldBegin('layers', Thrift.Type.LIST, 100);
    output.writeListBegin(Thrift.Type.STRUCT, this.layers.length);
    for (var iter47 in this.layers)
    {
      if (this.layers.hasOwnProperty(iter47))
      {
        iter47 = this.layers[iter47];
        iter47.write(output);
      }
    }
    output.writeListEnd();
    output.writeFieldEnd();
  }
  if (this.frameMs !== null && this.frameMs !== undefined) {
    output.writeFieldBegin('frameMs', Thrift.Type.I32, 101);
    output.writeI32(this.frameMs);
    output.writeFieldEnd();
  }
  if (this.size !== null && this.size !== undefined) {
    output.writeFieldBegin('size', Thrift.Type.STRUCT, 102);
    this.size.write(output);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

VERSION = 1;