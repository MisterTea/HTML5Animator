//
// Autogenerated by Thrift Compiler (0.9.0-dev)
//
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
//

NotAuthorizedException = function(args) {
  this.errorMessage = null;
  if (args) {
    if (args.errorMessage !== undefined) {
      this.errorMessage = args.errorMessage;
    }
  }
};
Thrift.inherits(NotAuthorizedException, Thrift.TException);
NotAuthorizedException.prototype.name = 'NotAuthorizedException';
NotAuthorizedException.prototype.read = function(input) {
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
        this.errorMessage = input.readString().value;
      } else {
        input.skip(ftype);
      }
      break;
      case 0:
        input.skip(ftype);
        break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

NotAuthorizedException.prototype.write = function(output) {
  output.writeStructBegin('NotAuthorizedException');
  if (this.errorMessage !== null && this.errorMessage !== undefined) {
    output.writeFieldBegin('errorMessage', Thrift.Type.STRING, 1);
    output.writeString(this.errorMessage);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};
