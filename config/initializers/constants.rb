# CLAN SPECIFIC
CLAN_SHORT_NAME               = "FTF"
CLAN_NAME                     = "Fear the Fallen"
CLAN_DISQUS                   = "fearthefallenelderscrollsonline"
CLAN_GENERIC_EMAIL_SUFFIX     = "fearthefallen.com"
CLAN_EMAIL                    = "ftf-eso@outlook.com"
CLAN_NO_REPLAY                = "noreply@fearthefallen.net"
CLAN_WEBSITE                  = "https://fearthefallen-eso.herokuapp.com"
CLAN_TEAMSPEAK_SERVER         = "199.167.19.50:9170"
CLAN_TEAMSPEAK_PASSWORD       = "pancakes"
CLAN_TSVIEW_ID                = 1033593
CLAN_GOOGLE_PLUS_ID           = 103259274594875534773


# ROLE VALUES
UserPending           = 0
UserRecruit           = 100
UserSoldier           = 200
UserA                 = 300
UserB                 = 400
UserGuildMaster       = 900

if Rails.env.development?
  ENV['DISQUS_SECRET'] = 'DjIG0dUGqxUvRYOQDGAcEdFzcVsugsoEoBnwXN6CROh7MLBjO7wMzhgJyhYXFY6i' 
  ENV['DISQUS_PUBLIC'] = 'zKKxA72ahFTMjQJbS1fTd0GN8D8p1p4WDpwBoygMz5eiwMtwxVC54fG1OIry8R7v'
end