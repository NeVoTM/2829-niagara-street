# Fort Myers Direct Stay

Simple direct-booking website for the first short-term rental location: a Fort Myers, Florida apartment positioned as a 2 bedroom, 2 bath, 1,200 square foot three-night stay with a $100 cleaning charge.

## What is included

- Static GitHub Pages homepage in `index.html`
- Property overview for the Fort Myers apartment
- Three-night price calculator with a fixed $100 cleaning fee
- Fort Myers guest guide for beaches, fishing, entertainment, food, and shopping
- Travel planning section for Western New York guests
  - Allegiant Air from Niagara Falls International Airport (IAG) to Punta Gorda Airport (PGD)
  - Estimated ground transportation from PGD to Fort Myers
  - Backup airport estimate from Southwest Florida International Airport (RSW)
- Optional white-glove local host / concierge service positioning
- Simple itinerary builder for automated guest planning
- Direct email and phone inquiry calls to action

## Files changed for this site

```text
index.html       Main rental website
_config.yml      GitHub Pages title and description
README.md        This operating guide
```

## Information still needed before launch

1. Exact apartment address and confirmed legal sublease / short-term rental approval.
2. Final nightly rate, seasonal rates, deposits, taxes, and payment rules.
3. Real unit photos, parking details, guest capacity, pet policy, and house rules.
4. Confirmed local host / white-glove service pricing and availability.
5. Booking calendar, payment processor, and signed rental agreement workflow.

## Travel copy notes

The site currently positions Niagara Falls/Buffalo travelers around pre-booked Allegiant Air service from IAG to PGD because this is the low-fare route the owner wants to study first. All airfare and ground transportation amounts are described as planning estimates because airline fares, baggage fees, rideshare surge pricing, tolls, and seasonal demand change frequently.

## Future location model

The Fort Myers page is designed as the first repeatable location page. Future destinations can reuse the same sections:

- Property facts
- Photos
- Rates and cleaning fees
- Local food / shopping / entertainment guide
- Airport and travel-cost planning
- Local host or companion-style concierge options
- Automated inquiry and itinerary workflow

## Local development

This is a static site. Open `index.html` directly in a browser, or serve the folder with any static web server.

```bash
python3 -m http.server 8000
```

Then open `http://localhost:8000`.
