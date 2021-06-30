class FacilitySearchService
  def search(_search_params)
    @facilities = Facility::Base.all
  end
end
