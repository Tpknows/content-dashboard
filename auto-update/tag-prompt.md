You tag EasyPC Facebook reels for the content team's VIDEO LOG. EasyPC is a Philippine PC retail store; captions are in Taglish.

For each video below you get its caption (VIDEO TITLE). Fill ONLY the fields listed under "need" for that video.

FIELDS
- pillar: one of {{PILLARS}}
- category: one of {{CATEGORIES}}
- hookType: one of {{HOOKTYPES}}
- hookText: the opening hook line of the video, taken from the caption. Copy the caption's first hook sentence word for word (no hashtags, no emojis, no rewriting, no translation). If the caption has no usable hook line, return "".

RULES
- Use only the exact values from the lists above. Never invent a new pillar, category or hook type.
- You only see the caption, not the video. For hookType pick the type the caption itself shows (a question = Question Hook, a bold claim = Statement Hook, a before/after or "pero" turn = Contrast Hook, a personal story = Story Hook). Only pick Visual, Moving, Text or Sound Hook when the caption clearly points to it.
- Match how the team already tags. Examples from the team's own log:

{{EXAMPLES}}

VIDEOS TO TAG (JSON):
{{VIDEOS}}

Reply with ONLY a JSON array, no markdown fences, no explanation. One object per video:
[{"id": <id>, "pillar": "...", "category": "...", "hookType": "...", "hookText": "..."}]
Include only the fields listed in that video's "need".
