export const queryHelperPlugin = (schema) => {
  schema.query.paginate = function (page) {
    page = !page || isNaN(page) || page < 1 ? 1 : page;
    const limit = 5;
    const skip = (page - 1) * limit;
    return this.skip(skip).limit(limit);
  };

  schema.query.customFilter = function (filters) {
    if (!filters || Object.keys(filters).length === 0) return this;

    const activeFilters = {};
    Object.keys(filters).forEach((key) => {
      if (
        filters[key] !== undefined &&
        filters[key] !== null &&
        filters[key] !== ""
      ) {
        activeFilters[key] = filters[key];
      }
    });

    return this.where(activeFilters);
  };

  schema.query.customSelect = function (fields) {
    if (!fields || typeof fields !== "string")
      return this.select("-updatedAt -__v");

    const formatFields = fields
      .split(",")
      .map((f) => f.trim())
      .join(" ");
    return this.select(formatFields);
  };
};
