# Auto-update ng Content Dashboard

**DASHBOARD DATA_2026.xlsx lang ang gagalawin mo.** Paste ng Meta exports at lagay ng POSTED BY gaya ng dati, tapos save. Ang script na ang bahala sa tracker, sa tags at sa Google Sheet.

## Ano ang ginagawa nito

1. Binabasa ang FB DATA (yung na-save na values).
2. Ina-update ang VIDEO LOG ng tracker, **October 2026 pataas lang** (`startDate` sa config.json). Hindi ginagalaw ang mas lumang rows.
   - Match by VIDEO LINK. Kapag na-shift ang paste (magkaiba ang video sa title, date at link), sinusunod ang title kasi doon naka-base ang tags mo.
   - Bagong video: papasok lang kapag may POSTED BY na sa DASHBOARD DATA. Hindi sinasama ang X, Marketing at #N/A.
3. Pinupunan ng AI ang blank na PILLAR, CATEGORY, HOOK TYPE at HOOK TEXT. **Naka-yellow ang lahat ng nilagay ng AI.** I-check mo, tapos alisin ang yellow kapag okay na. Hindi nito ginagalaw ang tags na nilagay mo.
   - Caption lang ang nababasa ng AI, hindi ang video. Kaya ang HOOK TEXT ay galing sa caption, at hula lang ang HOOK TYPE na Visual, Moving o Sound.
4. May backup muna bago mag-save (`backups\`, huling 15 lang ang tinatago).
5. Pinu-push ang tracker sa Google Sheet (kapag naka-setup na, tingnan sa baba).

Lahat ng nangyari ay nasa `logs\update-YYYY-MM-DD.log`. Ang AI tags ay nasa `logs\ai-tags.csv`.

## Paano patakbuhin

- **Manual:** double-click ang `UPDATE DASHBOARD.bat`. Isara muna ang tracker sa Excel.
- **Automatic:** patakbuhin minsan ang `Setup-AutoRun.ps1`. Every 15 minutes, chine-check nito kung na-save ang DASHBOARD DATA. Kapag oo at sarado ang dalawang file, tatakbo na siya mag-isa. Pang-off: `Setup-AutoRun.ps1 -Remove`.

Kapag nilipat ang folder sa OneDrive, hahanapin ito ng script at ia-update ang `dataFolder` sa config.json.

## Kapag lumipat ka ng PC

Nasa OneDrive ang folder na ito, kaya kasama nang lilipat ang scripts, config.json at upload-token.txt. Ang hindi sumasama ay ang auto-update schedule, ang Excel at ang Claude Code login.

1. **Sa lumang PC muna:** patakbuhin ang `Setup-AutoRun.ps1 -Remove`. Kapag sabay na naka-on sa dalawang PC, pwedeng magka-conflict ang files sa OneDrive. Kung wala na ang lumang PC, okay lang na laktawan ito.
2. **Sa bagong PC:**
   - Mag-sign in sa OneDrive at hintaying matapos ang sync.
   - I-install ang desktop Excel.
   - I-install ang Claude Code, buksan ang terminal, i-type ang `claude` at mag-login.
3. I-double-click ang `SETUP NEW PC.bat`. Iche-check nito ang lahat, at kapag puro [OK], i-o-on na nito ang auto-update. Kapag may [AYUSIN], gawin ang nakasulat tapos ulitin.

Hindi na kailangang galawin ang Google Sheet o ang Apps Script. Pareho pa rin ang URL at token.

## Setup ng Google Sheet (isang beses lang)

1. Buksan ang script.google.com, tapos New project. Pangalanan ng "Tracker Upload".
2. I-paste ang buong laman ng `Tracker Upload Backend.txt` (nasa CONTENT DASHBOARD folder).
3. Services (+), tapos Drive API, tapos Add.
4. Project Settings, tapos Script Properties. Mag-add ng `UPLOAD_TOKEN`, at ang value ay yung laman ng `upload-token.txt` dito sa folder. Huwag i-share ang token na ito.
5. I-run ang `testAccess` at i-allow ang permissions. Dapat lumabas sa log ang pangalan at tabs ng Google Sheet.
6. Deploy, New deployment, Web app. Execute as: Me. Who has access: Anyone.
7. Kopyahin ang /exec URL at ilagay sa `"uploadUrl"` sa config.json.

Pagkatapos nito, kada update ay papalitan na nito ang laman ng bawat tab sa Google Sheet, kapareho ng manual na "replace all". Hindi nagbabago ang tab IDs kaya gagana pa rin ang dashboard.
