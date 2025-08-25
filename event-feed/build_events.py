import requests, codecs
from icalendar import Calendar
import json

URL = "https://students.usask.ca/events-calendar/index.ics"

def fetch_events():
    r = requests.get(URL, timeout=20)
    r.raise_for_status()

    # --- sanitize bytes: strip UTF-8 BOM and any leading whitespace/newlines ---
    data = r.content
    if data.startswith(codecs.BOM_UTF8):
        data = data[len(codecs.BOM_UTF8):]
    data = data.lstrip()  # remove leading spaces / \r\n that break the parser

    cal = Calendar.from_ical(data)

    events = []
    for component in cal.walk("vevent"):
        dtstart = component.get("DTSTART")
        dtend = component.get("DTEND")
        events.append({
            "title": str(component.get("SUMMARY", "")),
            "location": str(component.get("LOCATION", "")),
            "start": dtstart.dt.isoformat() if dtstart else None,
            "end": dtend.dt.isoformat() if dtend else None,
            "description": str(component.get("DESCRIPTION", "")),
            "url": str(component.get("URL") or ""),
        })
    return events

if __name__ == "__main__":
    evs = fetch_events()
    with open("usask.json", "w", encoding="utf-8") as f:
        json.dump(evs, f, ensure_ascii=False, indent=2)
    print(f"Saved {len(evs)} events to usask.json")
