class UpdateModel {
  final String category;
  final String title;
  final String description;
  final String? thumbnailUrl;

  UpdateModel({
    required this.category,
    required this.title,
    required this.description,
    this.thumbnailUrl,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    String readFirst(List<String> keys, {String fallback = ""}) {
      for (final key in keys) {
        final value = json[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
      return fallback;
    }

    return UpdateModel(
      category: readFirst(["category", "projectCategory", "type"], fallback: "Uncategorized"),
      title: readFirst(["title", "projectName", "name"], fallback: "Untitled Update"),
      description: readFirst(["description", "address", "subtitle"]),
      thumbnailUrl: readFirst(["thumbnail", "image", "imageUrl", "photoUrl"]).isEmpty
          ? null
          : readFirst(["thumbnail", "image", "imageUrl", "photoUrl"]),
    );
  }


  static List<UpdateModel> dummyData = [
    UpdateModel(
      category: "Foundation",
      title: "Concrete Work Completed",
      description: "The foundation concrete has been successfully poured and cured. Ready for framing phase starting Monday.",
    ),
    UpdateModel(
      category: "Electrical",
      title: "Wiring Installation Ongoing",
      description: "Electrical wiring for ground floor is currently in progress and expected to complete within 2 days.",
    ),
    UpdateModel(
      category: "Interior",
      title: "Wall Painting Started",
      description: "Interior wall base coating has begun using premium matte finish paint for smooth texture.",
    ),
    UpdateModel(
      category: "Plumbing",
      title: "Bathroom Pipeline Installed",
      description: "All bathroom plumbing pipelines are installed and pressure tested successfully.",
    ),
    UpdateModel(
      category: "Finishing",
      title: "Tile Work Completed",
      description: "Floor and kitchen tile work has been completed with high-quality ceramic finish.",
    ),
    UpdateModel(
      category: "Exterior",
      title: "Facade Coating Applied",
      description: "Weather-resistant exterior coating has been applied on the north and west elevations.",
    ),
    UpdateModel(
      category: "Landscaping",
      title: "Garden Path Layout Finalized",
      description: "Stone pathway alignment and softscape zones were finalized for the front yard.",
    ),
    UpdateModel(
      category: "HVAC",
      title: "Duct Routing Completed",
      description: "Main HVAC duct routing is done across both floors and ready for insulation work.",
    ),
    UpdateModel(
      category: "Safety",
      title: "Site Safety Audit Passed",
      description: "Weekly safety audit completed with zero critical findings and all corrective actions closed.",
    ),
    UpdateModel(
      category: "Roofing",
      title: "Waterproof Membrane Installed",
      description: "Primary waterproof membrane installation completed and leak test scheduled tomorrow.",
    ),
  ];
}
