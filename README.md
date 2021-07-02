# Booking

## Models

**User**

**Facility** - Individual sport courts. Uses STI for each sport court type

**Timeslot** - Time slots available for users to book. Generated in bulk in advance for each Facility. 

**Booking** - A record of a User having reserved a Timeslot at a Facility

## Services

**TimeSlotSearchService** - allows Users to search for available Timeslots by facility type, date, and / or time

**TimeslotGenerationService** - creates Timeslot records for X days into the future for a specified facility


## Known issues

**Timeslot Generation** - The TimeslotGenerationService isn't really plugged in anywhere at the moment. Ideally this would be run at regular intervals via a scheduled background task for each facility.

**Individual Facility opening hours / excluded days** - The current implementation means that all facilities share opening hours and excluded days as defined in `Facility::Base`. Currently we can override this on a per-facility-type basis in the STI subclasses. Ideally it would also support each facility having its own unique times/dates, too. For example, an outdoor tennis court might have different hours to an indoor one.

**Booking race condition** - There's a potential race condition if multiple users attempt to book the same timeslot at the same time. There's limited mitigation against this at this point.

**Test coverage** - There's lots of room for improvement in the test coverage. Basic functionality and happy-paths are covered in controller and model test, but there's limited coverage of bad routes and edge cases. There are no end-end integration tests.


