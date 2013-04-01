/**
 * Autogenerated by Thrift Compiler (0.9.0-dev)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
package com.github.mistertea.html5animator.thrift;

import org.apache.thrift.scheme.IScheme;
import org.apache.thrift.scheme.SchemeFactory;
import org.apache.thrift.scheme.StandardScheme;

import org.apache.thrift.scheme.TupleScheme;
import org.apache.thrift.protocol.TTupleProtocol;
import org.apache.thrift.protocol.TProtocolException;
import org.apache.thrift.EncodingUtils;
import org.apache.thrift.TException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.EnumMap;
import java.util.Set;
import java.util.HashSet;
import java.util.EnumSet;
import java.util.Collections;
import java.util.BitSet;
import java.nio.ByteBuffer;
import java.util.Arrays;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Color implements org.apache.thrift.TBase<Color, Color._Fields>, java.io.Serializable, Cloneable {
  private static final org.apache.thrift.protocol.TStruct STRUCT_DESC = new org.apache.thrift.protocol.TStruct("Color");

  private static final org.apache.thrift.protocol.TField R_FIELD_DESC = new org.apache.thrift.protocol.TField("r", org.apache.thrift.protocol.TType.I16, (short)1);
  private static final org.apache.thrift.protocol.TField G_FIELD_DESC = new org.apache.thrift.protocol.TField("g", org.apache.thrift.protocol.TType.I16, (short)2);
  private static final org.apache.thrift.protocol.TField B_FIELD_DESC = new org.apache.thrift.protocol.TField("b", org.apache.thrift.protocol.TType.I16, (short)3);
  private static final org.apache.thrift.protocol.TField A_FIELD_DESC = new org.apache.thrift.protocol.TField("a", org.apache.thrift.protocol.TType.I16, (short)4);

  private static final Map<Class<? extends IScheme>, SchemeFactory> schemes = new HashMap<Class<? extends IScheme>, SchemeFactory>();
  static {
    schemes.put(StandardScheme.class, new ColorStandardSchemeFactory());
    schemes.put(TupleScheme.class, new ColorTupleSchemeFactory());
  }

  public short r; // required
  public short g; // required
  public short b; // required
  public short a; // required

  /** The set of fields this struct contains, along with convenience methods for finding and manipulating them. */
  public enum _Fields implements org.apache.thrift.TFieldIdEnum {
    R((short)1, "r"),
    G((short)2, "g"),
    B((short)3, "b"),
    A((short)4, "a");

    private static final Map<String, _Fields> byName = new HashMap<String, _Fields>();

    static {
      for (_Fields field : EnumSet.allOf(_Fields.class)) {
        byName.put(field.getFieldName(), field);
      }
    }

    /**
     * Find the _Fields constant that matches fieldId, or null if its not found.
     */
    public static _Fields findByThriftId(int fieldId) {
      switch(fieldId) {
        case 1: // R
          return R;
        case 2: // G
          return G;
        case 3: // B
          return B;
        case 4: // A
          return A;
        default:
          return null;
      }
    }

    /**
     * Find the _Fields constant that matches fieldId, throwing an exception
     * if it is not found.
     */
    public static _Fields findByThriftIdOrThrow(int fieldId) {
      _Fields fields = findByThriftId(fieldId);
      if (fields == null) throw new IllegalArgumentException("Field " + fieldId + " doesn't exist!");
      return fields;
    }

    /**
     * Find the _Fields constant that matches name, or null if its not found.
     */
    public static _Fields findByName(String name) {
      return byName.get(name);
    }

    private final short _thriftId;
    private final String _fieldName;

    _Fields(short thriftId, String fieldName) {
      _thriftId = thriftId;
      _fieldName = fieldName;
    }

    public short getThriftFieldId() {
      return _thriftId;
    }

    public String getFieldName() {
      return _fieldName;
    }
  }

  // isset id assignments
  private static final int __R_ISSET_ID = 0;
  private static final int __G_ISSET_ID = 1;
  private static final int __B_ISSET_ID = 2;
  private static final int __A_ISSET_ID = 3;
  private byte __isset_bitfield = 0;
  public static final Map<_Fields, org.apache.thrift.meta_data.FieldMetaData> metaDataMap;
  static {
    Map<_Fields, org.apache.thrift.meta_data.FieldMetaData> tmpMap = new EnumMap<_Fields, org.apache.thrift.meta_data.FieldMetaData>(_Fields.class);
    tmpMap.put(_Fields.R, new org.apache.thrift.meta_data.FieldMetaData("r", org.apache.thrift.TFieldRequirementType.DEFAULT, 
        new org.apache.thrift.meta_data.FieldValueMetaData(org.apache.thrift.protocol.TType.I16)));
    tmpMap.put(_Fields.G, new org.apache.thrift.meta_data.FieldMetaData("g", org.apache.thrift.TFieldRequirementType.DEFAULT, 
        new org.apache.thrift.meta_data.FieldValueMetaData(org.apache.thrift.protocol.TType.I16)));
    tmpMap.put(_Fields.B, new org.apache.thrift.meta_data.FieldMetaData("b", org.apache.thrift.TFieldRequirementType.DEFAULT, 
        new org.apache.thrift.meta_data.FieldValueMetaData(org.apache.thrift.protocol.TType.I16)));
    tmpMap.put(_Fields.A, new org.apache.thrift.meta_data.FieldMetaData("a", org.apache.thrift.TFieldRequirementType.DEFAULT, 
        new org.apache.thrift.meta_data.FieldValueMetaData(org.apache.thrift.protocol.TType.I16)));
    metaDataMap = Collections.unmodifiableMap(tmpMap);
    org.apache.thrift.meta_data.FieldMetaData.addStructMetaDataMap(Color.class, metaDataMap);
  }

  public Color() {
  }

  public Color(
    short r,
    short g,
    short b,
    short a)
  {
    this();
    this.r = r;
    setRIsSet(true);
    this.g = g;
    setGIsSet(true);
    this.b = b;
    setBIsSet(true);
    this.a = a;
    setAIsSet(true);
  }

  /**
   * Performs a deep copy on <i>other</i>.
   */
  public Color(Color other) {
    __isset_bitfield = other.__isset_bitfield;
    this.r = other.r;
    this.g = other.g;
    this.b = other.b;
    this.a = other.a;
  }

  public Color deepCopy() {
    return new Color(this);
  }

  @Override
  public void clear() {
    setRIsSet(false);
    this.r = 0;
    setGIsSet(false);
    this.g = 0;
    setBIsSet(false);
    this.b = 0;
    setAIsSet(false);
    this.a = 0;
  }

  public short getR() {
    return this.r;
  }

  public Color setR(short r) {
    this.r = r;
    setRIsSet(true);
    return this;
  }

  public void unsetR() {
    __isset_bitfield = EncodingUtils.clearBit(__isset_bitfield, __R_ISSET_ID);
  }

  /** Returns true if field r is set (has been assigned a value) and false otherwise */
  public boolean isSetR() {
    return EncodingUtils.testBit(__isset_bitfield, __R_ISSET_ID);
  }

  public void setRIsSet(boolean value) {
    __isset_bitfield = EncodingUtils.setBit(__isset_bitfield, __R_ISSET_ID, value);
  }

  public short getG() {
    return this.g;
  }

  public Color setG(short g) {
    this.g = g;
    setGIsSet(true);
    return this;
  }

  public void unsetG() {
    __isset_bitfield = EncodingUtils.clearBit(__isset_bitfield, __G_ISSET_ID);
  }

  /** Returns true if field g is set (has been assigned a value) and false otherwise */
  public boolean isSetG() {
    return EncodingUtils.testBit(__isset_bitfield, __G_ISSET_ID);
  }

  public void setGIsSet(boolean value) {
    __isset_bitfield = EncodingUtils.setBit(__isset_bitfield, __G_ISSET_ID, value);
  }

  public short getB() {
    return this.b;
  }

  public Color setB(short b) {
    this.b = b;
    setBIsSet(true);
    return this;
  }

  public void unsetB() {
    __isset_bitfield = EncodingUtils.clearBit(__isset_bitfield, __B_ISSET_ID);
  }

  /** Returns true if field b is set (has been assigned a value) and false otherwise */
  public boolean isSetB() {
    return EncodingUtils.testBit(__isset_bitfield, __B_ISSET_ID);
  }

  public void setBIsSet(boolean value) {
    __isset_bitfield = EncodingUtils.setBit(__isset_bitfield, __B_ISSET_ID, value);
  }

  public short getA() {
    return this.a;
  }

  public Color setA(short a) {
    this.a = a;
    setAIsSet(true);
    return this;
  }

  public void unsetA() {
    __isset_bitfield = EncodingUtils.clearBit(__isset_bitfield, __A_ISSET_ID);
  }

  /** Returns true if field a is set (has been assigned a value) and false otherwise */
  public boolean isSetA() {
    return EncodingUtils.testBit(__isset_bitfield, __A_ISSET_ID);
  }

  public void setAIsSet(boolean value) {
    __isset_bitfield = EncodingUtils.setBit(__isset_bitfield, __A_ISSET_ID, value);
  }

  public void setFieldValue(_Fields field, Object value) {
    switch (field) {
    case R:
      if (value == null) {
        unsetR();
      } else {
        setR((Short)value);
      }
      break;

    case G:
      if (value == null) {
        unsetG();
      } else {
        setG((Short)value);
      }
      break;

    case B:
      if (value == null) {
        unsetB();
      } else {
        setB((Short)value);
      }
      break;

    case A:
      if (value == null) {
        unsetA();
      } else {
        setA((Short)value);
      }
      break;

    }
  }

  public Object getFieldValue(_Fields field) {
    switch (field) {
    case R:
      return Short.valueOf(getR());

    case G:
      return Short.valueOf(getG());

    case B:
      return Short.valueOf(getB());

    case A:
      return Short.valueOf(getA());

    }
    throw new IllegalStateException();
  }

  /** Returns true if field corresponding to fieldID is set (has been assigned a value) and false otherwise */
  public boolean isSet(_Fields field) {
    if (field == null) {
      throw new IllegalArgumentException();
    }

    switch (field) {
    case R:
      return isSetR();
    case G:
      return isSetG();
    case B:
      return isSetB();
    case A:
      return isSetA();
    }
    throw new IllegalStateException();
  }

  @Override
  public boolean equals(Object that) {
    if (that == null)
      return false;
    if (that instanceof Color)
      return this.equals((Color)that);
    return false;
  }

  public boolean equals(Color that) {
    if (that == null)
      return false;

    boolean this_present_r = true;
    boolean that_present_r = true;
    if (this_present_r || that_present_r) {
      if (!(this_present_r && that_present_r))
        return false;
      if (this.r != that.r)
        return false;
    }

    boolean this_present_g = true;
    boolean that_present_g = true;
    if (this_present_g || that_present_g) {
      if (!(this_present_g && that_present_g))
        return false;
      if (this.g != that.g)
        return false;
    }

    boolean this_present_b = true;
    boolean that_present_b = true;
    if (this_present_b || that_present_b) {
      if (!(this_present_b && that_present_b))
        return false;
      if (this.b != that.b)
        return false;
    }

    boolean this_present_a = true;
    boolean that_present_a = true;
    if (this_present_a || that_present_a) {
      if (!(this_present_a && that_present_a))
        return false;
      if (this.a != that.a)
        return false;
    }

    return true;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  public int compareTo(Color other) {
    if (!getClass().equals(other.getClass())) {
      return getClass().getName().compareTo(other.getClass().getName());
    }

    int lastComparison = 0;
    Color typedOther = (Color)other;

    lastComparison = Boolean.valueOf(isSetR()).compareTo(typedOther.isSetR());
    if (lastComparison != 0) {
      return lastComparison;
    }
    if (isSetR()) {
      lastComparison = org.apache.thrift.TBaseHelper.compareTo(this.r, typedOther.r);
      if (lastComparison != 0) {
        return lastComparison;
      }
    }
    lastComparison = Boolean.valueOf(isSetG()).compareTo(typedOther.isSetG());
    if (lastComparison != 0) {
      return lastComparison;
    }
    if (isSetG()) {
      lastComparison = org.apache.thrift.TBaseHelper.compareTo(this.g, typedOther.g);
      if (lastComparison != 0) {
        return lastComparison;
      }
    }
    lastComparison = Boolean.valueOf(isSetB()).compareTo(typedOther.isSetB());
    if (lastComparison != 0) {
      return lastComparison;
    }
    if (isSetB()) {
      lastComparison = org.apache.thrift.TBaseHelper.compareTo(this.b, typedOther.b);
      if (lastComparison != 0) {
        return lastComparison;
      }
    }
    lastComparison = Boolean.valueOf(isSetA()).compareTo(typedOther.isSetA());
    if (lastComparison != 0) {
      return lastComparison;
    }
    if (isSetA()) {
      lastComparison = org.apache.thrift.TBaseHelper.compareTo(this.a, typedOther.a);
      if (lastComparison != 0) {
        return lastComparison;
      }
    }
    return 0;
  }

  public _Fields fieldForId(int fieldId) {
    return _Fields.findByThriftId(fieldId);
  }

  public void read(org.apache.thrift.protocol.TProtocol iprot) throws org.apache.thrift.TException {
    schemes.get(iprot.getScheme()).getScheme().read(iprot, this);
  }

  public void write(org.apache.thrift.protocol.TProtocol oprot) throws org.apache.thrift.TException {
    schemes.get(oprot.getScheme()).getScheme().write(oprot, this);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder("Color(");
    boolean first = true;

    sb.append("r:");
    sb.append(this.r);
    first = false;
    if (!first) sb.append(", ");
    sb.append("g:");
    sb.append(this.g);
    first = false;
    if (!first) sb.append(", ");
    sb.append("b:");
    sb.append(this.b);
    first = false;
    if (!first) sb.append(", ");
    sb.append("a:");
    sb.append(this.a);
    first = false;
    sb.append(")");
    return sb.toString();
  }

  public void validate() throws org.apache.thrift.TException {
    // check for required fields
    // check for sub-struct validity
  }

  private void writeObject(java.io.ObjectOutputStream out) throws java.io.IOException {
    try {
      write(new org.apache.thrift.protocol.TCompactProtocol(new org.apache.thrift.transport.TIOStreamTransport(out)));
    } catch (org.apache.thrift.TException te) {
      throw new java.io.IOException(te);
    }
  }

  private void readObject(java.io.ObjectInputStream in) throws java.io.IOException, ClassNotFoundException {
    try {
      // it doesn't seem like you should have to do this, but java serialization is wacky, and doesn't call the default constructor.
      __isset_bitfield = 0;
      read(new org.apache.thrift.protocol.TCompactProtocol(new org.apache.thrift.transport.TIOStreamTransport(in)));
    } catch (org.apache.thrift.TException te) {
      throw new java.io.IOException(te);
    }
  }

  private static class ColorStandardSchemeFactory implements SchemeFactory {
    public ColorStandardScheme getScheme() {
      return new ColorStandardScheme();
    }
  }

  private static class ColorStandardScheme extends StandardScheme<Color> {

    public void read(org.apache.thrift.protocol.TProtocol iprot, Color struct) throws org.apache.thrift.TException {
      org.apache.thrift.protocol.TField schemeField;
      iprot.readStructBegin();
      while (true)
      {
        schemeField = iprot.readFieldBegin();
        if (schemeField.type == org.apache.thrift.protocol.TType.STOP) { 
          break;
        }
        switch (schemeField.id) {
          case 1: // R
            if (schemeField.type == org.apache.thrift.protocol.TType.I16) {
              struct.r = iprot.readI16();
              struct.setRIsSet(true);
            } else { 
              org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
            }
            break;
          case 2: // G
            if (schemeField.type == org.apache.thrift.protocol.TType.I16) {
              struct.g = iprot.readI16();
              struct.setGIsSet(true);
            } else { 
              org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
            }
            break;
          case 3: // B
            if (schemeField.type == org.apache.thrift.protocol.TType.I16) {
              struct.b = iprot.readI16();
              struct.setBIsSet(true);
            } else { 
              org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
            }
            break;
          case 4: // A
            if (schemeField.type == org.apache.thrift.protocol.TType.I16) {
              struct.a = iprot.readI16();
              struct.setAIsSet(true);
            } else { 
              org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
            }
            break;
          default:
            org.apache.thrift.protocol.TProtocolUtil.skip(iprot, schemeField.type);
        }
        iprot.readFieldEnd();
      }
      iprot.readStructEnd();

      // check for required fields of primitive type, which can't be checked in the validate method
      struct.validate();
    }

    public void write(org.apache.thrift.protocol.TProtocol oprot, Color struct) throws org.apache.thrift.TException {
      struct.validate();

      oprot.writeStructBegin(STRUCT_DESC);
      oprot.writeFieldBegin(R_FIELD_DESC);
      oprot.writeI16(struct.r);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(G_FIELD_DESC);
      oprot.writeI16(struct.g);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(B_FIELD_DESC);
      oprot.writeI16(struct.b);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(A_FIELD_DESC);
      oprot.writeI16(struct.a);
      oprot.writeFieldEnd();
      oprot.writeFieldStop();
      oprot.writeStructEnd();
    }

  }

  private static class ColorTupleSchemeFactory implements SchemeFactory {
    public ColorTupleScheme getScheme() {
      return new ColorTupleScheme();
    }
  }

  private static class ColorTupleScheme extends TupleScheme<Color> {

    @Override
    public void write(org.apache.thrift.protocol.TProtocol prot, Color struct) throws org.apache.thrift.TException {
      TTupleProtocol oprot = (TTupleProtocol) prot;
      BitSet optionals = new BitSet();
      if (struct.isSetR()) {
        optionals.set(0);
      }
      if (struct.isSetG()) {
        optionals.set(1);
      }
      if (struct.isSetB()) {
        optionals.set(2);
      }
      if (struct.isSetA()) {
        optionals.set(3);
      }
      oprot.writeBitSet(optionals, 4);
      if (struct.isSetR()) {
        oprot.writeI16(struct.r);
      }
      if (struct.isSetG()) {
        oprot.writeI16(struct.g);
      }
      if (struct.isSetB()) {
        oprot.writeI16(struct.b);
      }
      if (struct.isSetA()) {
        oprot.writeI16(struct.a);
      }
    }

    @Override
    public void read(org.apache.thrift.protocol.TProtocol prot, Color struct) throws org.apache.thrift.TException {
      TTupleProtocol iprot = (TTupleProtocol) prot;
      BitSet incoming = iprot.readBitSet(4);
      if (incoming.get(0)) {
        struct.r = iprot.readI16();
        struct.setRIsSet(true);
      }
      if (incoming.get(1)) {
        struct.g = iprot.readI16();
        struct.setGIsSet(true);
      }
      if (incoming.get(2)) {
        struct.b = iprot.readI16();
        struct.setBIsSet(true);
      }
      if (incoming.get(3)) {
        struct.a = iprot.readI16();
        struct.setAIsSet(true);
      }
    }
  }

}

