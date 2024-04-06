enum Type {dada, paha}

enum Sambal {matah, daunJeruk, korek, bawang}

// NORMAL PATTERN
class AyamGeprek{
  Type type;
  bool extraNasi;
  int jmlCabai;
  // OPTIONAL
  Sambal? sambal;
  String? notes;

  AyamGeprek(
      // ORDERED ARGUMENT
      this.type,
      this.notes,
      // NAMED ARGUMENT
      {
        this.sambal,
        this.jmlCabai = 0,
        this.extraNasi = false
      }
  );
}

// BUILDER PATTERN
class BebekGorengBuilder {
  Type type;
  Sambal? sambal;
  bool extraNasi = false;
  int jmlCabai = 0;
  String? notes;

  BebekGorengBuilder(this.type);
}

class BebekGoreng {
  final Type type;
  final Sambal? sambal;
  final bool extraNasi;
  final int jmlCabai;
  final String? notes;

  BebekGoreng(BebekGorengBuilder builder)
    : type = builder.type,
      sambal = builder.sambal,
      extraNasi = builder.extraNasi,
      jmlCabai = builder.jmlCabai,
      notes = builder.notes;
}

// COPY WITH BUILDER
class IkanGoreng {
  final Type type;
  final Sambal? sambal;
  final bool extraNasi;
  final int jmlCabai;
  final String? notes;

  IkanGoreng(
      // NAMED ARGUMENT
      {
        // NAMED REQUIRED
        required this.type,

        // NAMED OPTIONAL
        this.sambal,
        this.extraNasi = false,
        this.jmlCabai = 0,
        this.notes,
      }
  );

  IkanGoreng copyWith({
    Sambal? sambal,
    bool extraNasi = false,
    int jmlCabai = 0,
    String? notes,
  }) {
    return IkanGoreng(
        type: type,
        sambal: sambal ?? this.sambal,
        extraNasi: extraNasi,
        jmlCabai: jmlCabai,
        notes: notes ?? this.notes
    );
  }
}