from plexapi.server import PlexServer

# CONFIGURATION
PLEX_URL = 'http://INSERT_IP_ADDRESS_HERE:32400'
PLEX_TOKEN ='INSERT_PLEX_TOKEN_HERE'

# Duration limit in seconds (4 minutes)
MAX_DURATION_SECONDS = 4 * 60

def main():
    plex = PlexServer(PLEX_URL, PLEX_TOKEN)
    print("Connected to Plex Server:", plex.friendlyName)

    for section in plex.library.sections():
        if section.type in ['movie', 'show', 'music']:
            print(f"\nScanning library section: {section.title}")
            for item in section.all():
                try:
                    duration = getattr(item, 'duration', None)
                    if not duration:
                        continue

                    duration_sec = duration / 1000  # Plex gives duration in milliseconds
                    if duration_sec < MAX_DURATION_SECONDS:
                        print(f"  - {item.title} ({round(duration_sec)}s) in '{section.title}'")
                except Exception as e:
                    print(f"    Skipped item due to error: {e}")

if __name__ == '__main__':
    main()
