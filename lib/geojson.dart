class GeoJson {
  final String type;
  final List<Feature> features;

  GeoJson(this.type, this.features);

  GeoJson.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        features = json['features'].cast<Feature>();
}

class Feature {
  final String type;
  final Geometry geometry;
  final Properties properties;

  Feature(this.type, this.geometry, this.properties);

  Feature.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        geometry = json['geometry'].cast<Geometry>(),
        properties = json['properties'].cast<Properties>();
}

class Geometry {
  final String type;
  final List<List<double>> coordiates;

  Geometry(this.type, this.coordiates);

  Geometry.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        coordiates = json['coordinates'].cast<List<List<double>>>();
}

class Properties {
  final String gid1;
  final String gid2;
  final String country;
  final String name1;
  final String varname1;
  final String nl_name1;
  final String type1;
  final String engtype1;
  final String cc1;
  final String hasc1;
  final String iso1;

  Properties(
      this.gid1,
      this.gid2,
      this.country,
      this.name1,
      this.varname1,
      this.nl_name1,
      this.type1,
      this.engtype1,
      this.cc1,
      this.hasc1,
      this.iso1);

  Properties.fromJson(Map<String, dynamic> json)
      : gid1 = json['GID_1'],
        gid2 = json['GID_2'],
        country = json['COUNTRY'],
        name1 = json['NAME_1'],
        varname1 = json['VARNAME_1'],
        nl_name1 = json['NL_NAME1'],
        type1 = json['TYPE_1'],
        engtype1 = json['ENGTYPE_1'],
        cc1 = json['CC_1'],
        hasc1 = json['HASC_1'],
        iso1 = json['ISO_1'];
}
