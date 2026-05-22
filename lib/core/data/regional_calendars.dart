// lib/core/data/regional_calendars.dart
// Planting calendars for multiple growing regions.

class GardenRegion {
  final String id;
  final String label;
  final String shortLabel;
  final String emoji;
  final String description;
  const GardenRegion({
    required this.id,
    required this.label,
    required this.shortLabel,
    required this.emoji,
    required this.description,
  });
}

// T&T is first in the list
const List<GardenRegion> gardenRegions = [
  GardenRegion(
    id: 'tt',
    label: 'Trinidad & Tobago',
    shortLabel: 'T&T',
    emoji: '🌴',
    description: 'Tropical — dry season Jan–May, wet season Jun–Dec',
  ),
  GardenRegion(
    id: 'zone_9_10',
    label: 'USDA Zone 9–10',
    shortLabel: 'Zone 9–10',
    emoji: '☀️',
    description: 'Florida, Gulf Coast, SW USA — mild winters, hot summers',
  ),
  GardenRegion(
    id: 'zone_8',
    label: 'USDA Zone 8',
    shortLabel: 'Zone 8',
    emoji: '🌤',
    description: 'Carolinas, Pacific NW, Texas — last frost mid-March to mid-April',
  ),
  GardenRegion(
    id: 'zone_6_7',
    label: 'USDA Zone 6–7',
    shortLabel: 'Zone 6–7',
    emoji: '❄️',
    description: 'Mid-Atlantic, Midwest, New England — last frost April–May',
  ),
];

GardenRegion regionById(String id) =>
    gardenRegions.firstWhere((r) => r.id == id, orElse: () => gardenRegions[0]);

Map<int, Map<String, List<String>>> calendarForRegion(String regionId) {
  switch (regionId) {
    case 'zone_6_7':  return zone67PlantingCalendar;
    case 'zone_8':    return zone8PlantingCalendar;
    case 'zone_9_10': return zone910PlantingCalendar;
    case 'tt':
    default:          return ttPlantingCalendar;
  }
}

// ── Trinidad & Tobago (Tropical — 10°N) ──────────────────────────────────────
const Map<int, Map<String, List<String>>> ttPlantingCalendar = {
  1:  {'Start Indoors': [], 'Direct Sow': ['Tomato', 'Pepper', 'Beans', 'Carrot', 'Radish', 'Lettuce', 'Cucumber'], 'Transplant': ['Tomato', 'Pepper', 'Eggplant'], 'Notes': ['Peak dry season. Ideal for most vegetables. Low humidity and low pest pressure.']},
  2:  {'Start Indoors': [], 'Direct Sow': ['Tomato', 'Pepper', 'Cucumber', 'Squash', 'Corn', 'Okra', 'Beans', 'Melon'], 'Transplant': ['Tomato', 'Pepper', 'Basil', 'Eggplant'], 'Notes': ['Prime growing month. Dry season peak — best yields of the year. Irrigate consistently.']},
  3:  {'Start Indoors': [], 'Direct Sow': ['Cucumber', 'Squash', 'Beans', 'Okra', 'Corn', 'Watermelon', 'Pigeon Peas'], 'Transplant': ['Tomato', 'Pepper', 'Eggplant'], 'Notes': ['Main dry season planting. Excellent for warm-season crops.']},
  4:  {'Start Indoors': ['Tomato (for Jun transplant)'], 'Direct Sow': ['Okra', 'Sweet Potato slips', 'Pigeon Peas', 'Corn', 'Callaloo'], 'Transplant': ['Sweet Potato slips'], 'Notes': ['Heat increasing. Drought-tolerant crops preferred. Rains approaching.']},
  5:  {'Start Indoors': ['Tomato', 'Pepper'], 'Direct Sow': ['Okra', 'Callaloo', 'Pigeon Peas', 'Sweet Potato', 'Dasheen'], 'Transplant': ['Sweet Potato slips'], 'Notes': ['Transition month. Dry season ending. Shift to tropical crops. Ensure drainage.']},
  6:  {'Start Indoors': [], 'Direct Sow': ['Callaloo', 'Dasheen', 'Eddoe', 'Sweet Potato', 'Pigeon Peas', 'Okra'], 'Transplant': ['Dasheen', 'Eddoe'], 'Notes': ['Wet season begins. Heavy rain. Tropical root crops thrive. Watch for fungal disease.']},
  7:  {'Start Indoors': [], 'Direct Sow': ['Dasheen', 'Eddoe', 'Callaloo', 'Pigeon Peas', 'Pumpkin'], 'Transplant': [], 'Notes': ['Heavy rain month. Prioritise drainage. Neem oil for fungal/pest prevention.']},
  8:  {'Start Indoors': ['Tomato (start for Oct/Nov transplant)'], 'Direct Sow': ['Pigeon Peas', 'Callaloo', 'Sweet Potato'], 'Transplant': [], 'Notes': ['Wet season peak. Minimal outdoor planting. Start dry-season crops indoors.']},
  9:  {'Start Indoors': ['Tomato', 'Pepper', 'Cabbage', 'Eggplant'], 'Direct Sow': ['Pigeon Peas', 'Callaloo'], 'Transplant': ['Tomato (if started Aug)'], 'Notes': ['Wet season slowing. Start cool-season crops indoors for Nov/Dec transplant.']},
  10: {'Start Indoors': ['Tomato', 'Pepper', 'Cabbage', 'Lettuce', 'Broccoli'], 'Direct Sow': ['Callaloo', 'Radish', 'Beans'], 'Transplant': ['Tomato', 'Pepper'], 'Notes': ['Rain reducing. Excellent time for seedlings. Prepare raised beds.']},
  11: {'Start Indoors': [], 'Direct Sow': ['Tomato', 'Pepper', 'Carrot', 'Radish', 'Beans', 'Lettuce', 'Cucumber'], 'Transplant': ['Tomato', 'Pepper', 'Eggplant', 'Cabbage'], 'Notes': ['Wet season ending — conditions improving fast. Start main garden push.']},
  12: {'Start Indoors': [], 'Direct Sow': ['Tomato', 'Pepper', 'Cucumber', 'Carrot', 'Radish', 'Lettuce', 'Beans', 'Corn'], 'Transplant': ['Tomato', 'Pepper', 'Basil', 'Eggplant'], 'Notes': ['Dry season arrives. Best month to restart full vegetable garden.']},
};

// ── Zone 9–10 (Florida / Gulf Coast) ─────────────────────────────────────────
const Map<int, Map<String, List<String>>> zone910PlantingCalendar = {
  1:  {'Start Indoors': ['Tomato', 'Pepper', 'Eggplant'], 'Direct Sow': ['Radish', 'Carrot', 'Lettuce', 'Spinach', 'Onion (sets)'], 'Transplant': ['Broccoli', 'Cabbage', 'Kale', 'Collards'], 'Notes': ['Late January: last chance for cool-season starts in N.Florida.']},
  2:  {'Start Indoors': ['Tomato', 'Pepper', 'Basil', 'Cucumber', 'Squash'], 'Direct Sow': ['Radish', 'Carrot', 'Beans', 'Beet', 'Lettuce'], 'Transplant': ['Tomato (S.Florida)', 'Broccoli', 'Kale'], 'Notes': ['Transition month. Frost possible in N.Florida until mid-Feb.']},
  3:  {'Start Indoors': ['Basil', 'Okra'], 'Direct Sow': ['Beans', 'Corn', 'Cucumber', 'Squash', 'Radish'], 'Transplant': ['Tomato', 'Pepper', 'Eggplant', 'Basil'], 'Notes': ['Main spring planting month. Soil warms quickly.']},
  4:  {'Start Indoors': [], 'Direct Sow': ['Okra', 'Sweet Potato', 'Beans', 'Corn', 'Watermelon', 'Cantaloupe'], 'Transplant': ['Okra', 'Sweet Potato slips', 'Tomato (last chance)', 'Pepper'], 'Notes': ['Heat increasing. Focus on warm-season crops.']},
  5:  {'Start Indoors': [], 'Direct Sow': ['Okra', 'Sweet Potato slips', 'Lemongrass'], 'Transplant': ['Sweet Potato slips'], 'Notes': ['Summer begins. Cool-season crops done. Heat lovers only.']},
  6:  {'Start Indoors': [], 'Direct Sow': ['Okra', 'Sweet Potato', 'Malabar Spinach'], 'Transplant': [], 'Notes': ['Hot and humid. Rainy season starts. Minimal planting. Focus on okra.']},
  7:  {'Start Indoors': ['Tomato (fall crop)', 'Pepper'], 'Direct Sow': ['Okra'], 'Transplant': [], 'Notes': ['Start fall tomatoes/peppers indoors. Keep seeds cool.']},
  8:  {'Start Indoors': ['Tomato', 'Pepper', 'Broccoli', 'Kale', 'Eggplant'], 'Direct Sow': ['Beans', 'Corn'], 'Transplant': ['Tomato (S.Florida)', 'Malabar Spinach'], 'Notes': ['Key fall prep month. Start many crops indoors for Sept transplant.']},
  9:  {'Start Indoors': ['Broccoli', 'Cabbage', 'Cauliflower', 'Kale'], 'Direct Sow': ['Beans', 'Radish', 'Cucumber', 'Squash'], 'Transplant': ['Tomato', 'Pepper', 'Eggplant', 'Basil'], 'Notes': ['Fall planting season begins! Major planting month.']},
  10: {'Start Indoors': ['Onion (seeds)', 'Parsley'], 'Direct Sow': ['Radish', 'Carrot', 'Beet', 'Spinach', 'Lettuce', 'Kale', 'Garlic'], 'Transplant': ['Broccoli', 'Cabbage', 'Cauliflower', 'Tomato (last)'], 'Notes': ['Best fall planting month. Cooler weather = pest reduction.']},
  11: {'Start Indoors': ['Onion'], 'Direct Sow': ['Garlic', 'Spinach', 'Lettuce', 'Radish', 'Carrot', 'Cilantro'], 'Transplant': ['Onion transplants', 'Kale', 'Collards'], 'Notes': ['Cool season in full swing. Strawberries time to plant!']},
  12: {'Start Indoors': ['Onion', 'Tomato (S.Florida indoor start)'], 'Direct Sow': ['Radish', 'Lettuce', 'Spinach', 'Carrots'], 'Transplant': ['Blueberry (bare root)', 'Strawberry', 'Onion transplants'], 'Notes': ['Many greens doing well. Start planning spring garden.']},
};

// ── Zone 8 (Carolinas, Pacific NW, Texas, Northern GA/AL) ────────────────────
const Map<int, Map<String, List<String>>> zone8PlantingCalendar = {
  1:  {'Start Indoors': ['Onion', 'Leeks', 'Celery'], 'Direct Sow': ['Spinach', 'Kale', 'Peas (mild areas)'], 'Transplant': [], 'Notes': ['Mild winters in Zone 8. Cold-hardy greens can go direct in sheltered spots.']},
  2:  {'Start Indoors': ['Tomato', 'Pepper', 'Eggplant', 'Broccoli', 'Cabbage'], 'Direct Sow': ['Peas', 'Spinach', 'Radish', 'Lettuce'], 'Transplant': [], 'Notes': ['Last frost ~mid-March to mid-April. Start warm-season crops 6–8 wks early.']},
  3:  {'Start Indoors': ['Basil', 'Cucumber', 'Squash'], 'Direct Sow': ['Carrot', 'Beet', 'Radish', 'Lettuce', 'Peas', 'Onion (sets)'], 'Transplant': ['Broccoli', 'Cabbage', 'Kale'], 'Notes': ['Spring getting started. Last frost approaching.']},
  4:  {'Start Indoors': [], 'Direct Sow': ['Beans', 'Lettuce', 'Carrot', 'Radish', 'Beet', 'Corn'], 'Transplant': ['Tomato (late Apr)', 'Pepper', 'Broccoli', 'Kale'], 'Notes': ['After last frost: main spring planting.']},
  5:  {'Start Indoors': [], 'Direct Sow': ['Beans', 'Corn', 'Cucumber', 'Squash', 'Okra', 'Watermelon'], 'Transplant': ['Sweet Potato slips', 'Tomato', 'Pepper', 'Basil', 'Eggplant'], 'Notes': ['Full planting season. Warm soil — all crops viable.']},
  6:  {'Start Indoors': [], 'Direct Sow': ['Beans', 'Corn', 'Okra', 'Sweet Potato', 'Cucumber (succession)'], 'Transplant': [], 'Notes': ['Summer heat building. Ensure irrigation. Succession sow for fall harvest.']},
  7:  {'Start Indoors': ['Broccoli', 'Kale', 'Cabbage (fall)', 'Tomato (fall)'], 'Direct Sow': ['Beans', 'Okra'], 'Transplant': [], 'Notes': ['Start fall garden indoors now. Manage water closely.']},
  8:  {'Start Indoors': [], 'Direct Sow': ['Radish', 'Carrot', 'Beet'], 'Transplant': ['Tomato (fall)', 'Broccoli', 'Kale', 'Cabbage'], 'Notes': ['Fall planting in earnest. Transplant fall starters out.']},
  9:  {'Start Indoors': [], 'Direct Sow': ['Spinach', 'Lettuce', 'Kale', 'Radish', 'Carrot'], 'Transplant': ['Broccoli', 'Cabbage', 'Kale'], 'Notes': ['Excellent month. Cooler temps reduce pest pressure.']},
  10: {'Start Indoors': ['Onion'], 'Direct Sow': ['Garlic', 'Spinach', 'Lettuce', 'Radish', 'Kale'], 'Transplant': ['Onion transplants', 'Kale'], 'Notes': ['Plant garlic now. Leafy greens into winter in Zone 8.']},
  11: {'Start Indoors': ['Onion'], 'Direct Sow': ['Garlic', 'Spinach', 'Lettuce (cold-hardy)'], 'Transplant': [], 'Notes': ['Cool-season crops continue. Use row covers for frost protection.']},
  12: {'Start Indoors': ['Onion (late Dec)'], 'Direct Sow': ['Spinach', 'Radish', 'Lettuce'], 'Transplant': [], 'Notes': ['Light planting continues in mild areas. Plan spring seed orders.']},
};

// ── Zone 6–7 (Mid-Atlantic / Midwest / New England) ──────────────────────────
const Map<int, Map<String, List<String>>> zone67PlantingCalendar = {
  1:  {'Start Indoors': ['Onion', 'Leeks', 'Celery'], 'Direct Sow': [], 'Transplant': [], 'Notes': ['Coldest month. Indoor sowing only. Onions need 12–14 weeks.']},
  2:  {'Start Indoors': ['Tomato', 'Pepper', 'Eggplant', 'Onion'], 'Direct Sow': [], 'Transplant': [], 'Notes': ['Start tomatoes/peppers 8–10 weeks before last frost (late Apr/May).']},
  3:  {'Start Indoors': ['Basil', 'Squash', 'Cucumber', 'Melon', 'Broccoli', 'Kale'], 'Direct Sow': ['Peas', 'Spinach', 'Lettuce', 'Kale', 'Radish'], 'Transplant': [], 'Notes': ['Direct sow cold-hardy crops. Last frost still likely in April.']},
  4:  {'Start Indoors': [], 'Direct Sow': ['Peas', 'Lettuce', 'Spinach', 'Kale', 'Radish', 'Carrot', 'Beet'], 'Transplant': ['Broccoli', 'Cabbage', 'Kale (after frost)'], 'Notes': ['Spring in full swing. Wait for last frost before warm-season transplants.']},
  5:  {'Start Indoors': [], 'Direct Sow': ['Beans', 'Corn', 'Cucumber', 'Squash', 'Radish', 'Carrot', 'Beet'], 'Transplant': ['Tomato', 'Pepper', 'Eggplant', 'Basil', 'Squash', 'Cucumber'], 'Notes': ['After last frost — main outdoor planting month!']},
  6:  {'Start Indoors': [], 'Direct Sow': ['Beans', 'Corn', 'Cucumber', 'Squash', 'Okra', 'Beet'], 'Transplant': ['Sweet Potato slips', 'Basil'], 'Notes': ['Peak planting season. Succession-sow every 2 weeks.']},
  7:  {'Start Indoors': ['Broccoli', 'Kale', 'Cabbage (fall)'], 'Direct Sow': ['Beans', 'Radish', 'Beet', 'Summer Squash'], 'Transplant': [], 'Notes': ['Start fall brassicas indoors for August transplant.']},
  8:  {'Start Indoors': [], 'Direct Sow': ['Radish', 'Lettuce', 'Spinach', 'Kale', 'Carrot', 'Beet'], 'Transplant': ['Broccoli', 'Kale', 'Cabbage'], 'Notes': ['Fall planting window begins.']},
  9:  {'Start Indoors': [], 'Direct Sow': ['Spinach', 'Lettuce', 'Radish', 'Garlic (late month)'], 'Transplant': ['Kale', 'Broccoli (if started)'], 'Notes': ['Short window. Quick-maturing crops only before first frost.']},
  10: {'Start Indoors': [], 'Direct Sow': ['Garlic (cloves)', 'Spinach (overwintering)'], 'Transplant': [], 'Notes': ['Plant garlic for spring harvest. Mulch beds for winter.']},
  11: {'Start Indoors': [], 'Direct Sow': ['Garlic (if not done)'], 'Transplant': [], 'Notes': ['Season over. Amend beds with compost. Plan spring garden.']},
  12: {'Start Indoors': ['Onion (late month — 16 wks head start)'], 'Direct Sow': [], 'Transplant': [], 'Notes': ['Plan and order seeds. Start onions late December for May transplant.']},
};

const List<String> regionMonthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];


