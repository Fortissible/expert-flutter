import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/seasons.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart' as mvGenre;
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season_detail.dart';

// MOVIE DUMMY OBJECT
final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [mvGenre.Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

// TV DUMMY OBJECT
final testTv = Tv(
    adult: false,
    backdropPath: "/AvsNXUbP7UKCVnypyx2eWp8z2N3.jpg",
    genreIds: [
      16,
      35,
      10765
    ],
    id: 94954,
    originalLanguage: "en",
    originalName: "Hazbin Hotel",
    overview: "In attempt to find a non-violent alternative for reducing Hell's overpopulation, the daughter of Lucifer opens a rehabilitation hotel that offers a group of misfit demons a chance at redemption.",
    popularity: 399.893,
    posterPath: "/dTiZBcnMHSMfc4QVIbgULIWPcwL.jpg",
    name: "Hazbin Hotel",
    voteAverage: 9.027,
    voteCount: 819
);

final testTvList = <Tv>[testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: "/AvsNXUbP7UKCVnypyx2eWp8z2N3.jpg",
  createdBy: [],
  episodeRunTime: [25],
  genres: [
    Genre(id: 16, name: "Animation"),
    Genre(id: 35, name: "Comedy"),
    Genre(id: 10765, name: "Sci-Fi & Fantasy"),
  ],
  homepage: "https://www.amazon.com/dp/B0CLMPQTJ2",
  id: 94954,
  inProduction: true,
  languages: ["en"],
  name: "Hazbin Hotel",
  nextEpisodeToAir: null,
  networks: [
    Network(
      id: 1024,
      logoPath: "/ifhbNuuVnlwYy5oXA5VIb2YR8AZ.png",
      name: "Prime Video",
      originCountry: OriginCountry.US,
    ),
  ],
  numberOfEpisodes: 8,
  numberOfSeasons: 1,
  originalLanguage: "en",
  originalName: "Hazbin Hotel",
  overview:
  "In attempt to find a non-violent alternative for reducing Hell's overpopulation, the daughter of Lucifer opens a rehabilitation hotel that offers a group of misfit demons a chance at redemption.",
  popularity: 399.893,
  posterPath: "/dTiZBcnMHSMfc4QVIbgULIWPcwL.jpg",
  productionCompanies: [],
  productionCountries: [
    ProductionCountry(
      iso31661: OriginCountry.US,
      name: "United States of America",
    ),
  ],
  seasons: [
    Season(
      airDate: DateTime.parse("2019-10-28"),
      episodeCount: 2,
      id: 199540,
      name: "Specials",
      overview: "",
      posterPath: "/aYApV2vAn2bvY8HbkXHGbmG6FYS.jpg",
      seasonNumber: 0,
      voteAverage: 0,
    ),
    Season(
      airDate: DateTime.parse("2024-01-18"),
      episodeCount: 8,
      id: 134875,
      name: "Season 1",
      overview: "",
      posterPath: "/u9zmPp8ouqyX2zwXkqM9JzJ4zCO.jpg",
      seasonNumber: 1,
      voteAverage: 8.6,
    ),
  ],
  spokenLanguages: [
    SpokenLanguage(
      englishName: "English",
      iso6391: "en",
      name: "English",
    ),
  ],
  status: "Returning Series",
  tagline: "",
  type: "Scripted",
  voteAverage: 9.027,
  voteCount: 819,
);

final testTvWatchlist = Tv.watchlist(
    id: 94954,
    overview: "In attempt to find a non-violent alternative for reducing Hell's overpopulation, the daughter of Lucifer opens a rehabilitation hotel that offers a group of misfit demons a chance at redemption.",
    posterPath: "/dTiZBcnMHSMfc4QVIbgULIWPcwL.jpg",
    name: "Hazbin Hotel",
);

final testTvTable = TvTable(
    id: 94954,
    overview: "In attempt to find a non-violent alternative for reducing Hell's overpopulation, the daughter of Lucifer opens a rehabilitation hotel that offers a group of misfit demons a chance at redemption.",
    posterPath: "/dTiZBcnMHSMfc4QVIbgULIWPcwL.jpg",
    name: "Hazbin Hotel",
);

final testTvMap = {
  'id': 94954,
  'overview': "In attempt to find a non-violent alternative for reducing Hell's overpopulation, the daughter of Lucifer opens a rehabilitation hotel that offers a group of misfit demons a chance at redemption.",
  'posterPath': "/dTiZBcnMHSMfc4QVIbgULIWPcwL.jpg",
  'name': "Hazbin Hotel",
};

// SEASON DUMMY OBJECT
final testSeason = Seasons(
    expandedValue: ["Expanded Value 1", "Expanded Value 2"],
    headerValue: "Header Value"
);

final testSeasonDetail = TvSeasonDetail(
  id: "1",
  name: "Season 1",
  seasonNumber: 1,
  episodes: <Episode>[
    Episode(
        episodeNumber: 1,
        episodeType: EpisodeType.STANDARD,
        runtime: 30,
    ),
    Episode(
        episodeNumber: 2,
        episodeType: EpisodeType.STANDARD,
        runtime: 30
    ),
    Episode(
        episodeNumber: 3,
        episodeType: EpisodeType.FINALE,
        runtime: 60
    ),
  ]
);