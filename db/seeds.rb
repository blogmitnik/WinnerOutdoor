# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create(
  name: 'Hiking & Trekking',
)

Category.create(
  name: 'Long-distance Hiking',
)

Category.create(
  name: 'Alpine Climbing',
)

Category.create(
  name: 'Overseas Ｍountaineering',
)

Event.create(
  title: "The Little Foxes",
  content: "Avocado's neutral flavour and creamy texture makes it a wonderful substitute for dairy in desserts or smoothies. These little pots will keep for a few days in the fridge - a great make-ahead dessert!",
  slug: "the_little_foxes",
  category_id: 1,
  user_id: 1,
  cover_image: "https://robohash.org/autsapienterepellat.png?size=300x300&set=set1"
)

Event.create(
  title: "Great Work of Time",
  content: "A healthy breakfast of oats and quinoa with fresh ripe peach. Almond milk makes its suitable for dairy-free and vegan diets.",
  slug: "great_work_of_time",
  category_id: 2,
  user_id: 3,
  cover_image: "https://robohash.org/doloribussednesciunt.png?size=300x300&set=set1"
)

Event.create(
  title: "Wildfire at Midnight",
  content: "Those Barren Leaves, Thrones, Dominations. The Heart Is Deceitful Above All Things. By Grand Central Station I Sat Down and Wept",
  slug: "wildfire_at_midnight",
  category_id: 3,
  user_id: 6,
  cover_image: "https://robohash.org/assumendaetmagnam.png?size=300x300&set=set1"
)

Event.create(
  title: "A Swiftly Tilting Planet",
  content: "Scoop the avocado flesh into a food processor. Add the chopped banana, prunes, almond or coconut milk, smooth peanut butter and cacao powder. Blend until smooth, adding a little more milk if the blade gets stuck.",
  slug: "a_swiftly_tilting_planet",
  category_id: 4,
  user_id: 6,
  cover_image: "https://robohash.org/assumendaetmagnam.png?size=300x300&set=set1"
)