FILE ?=
URL ?=
ISOLATE ?= 0
SHIFT ?=
BASE ?= x

base := $(BASE)

title_file := $(base).txt

stamped_suffix := -stamped

ifneq ($(ISOLATE),0)
isolated_suffix := -isolated
endif

ifneq ($(SHIFT),)
shifted_suffix := -shifted
endif

half_speed_suffix := -half-speed
quarter_speed_suffix := -quarter-speed

v := .webm
a := .wav

or_empty = $(if $(filter _,$(1)),,$(1))

all_targets := \
	$(title_file) \
	$(addsuffix $(v), \
		$(foreach maybe_isolated_suffix, _ $(isolated_suffix), \
			$(foreach maybe_shifted_suffix, _ $(shifted_suffix), \
				$(foreach speed_suffix, _ $(half_speed_suffix) $(quarter_speed_suffix), \
					$(base)$(stamped_suffix)$(call or_empty,$(maybe_isolated_suffix))$(call or_empty,$(maybe_shifted_suffix))$(call or_empty,$(speed_suffix)) \
				) \
			) \
		) \
	)

all: $(all_targets)

ifneq ($(FILE),)

$(title_file):
	echo $(abspath $(FILE)) > $@

$(base)$(v):
	echo $(FILE) | grep -qF $(v)
	cp $(FILE) $@

else ifneq ($(URL),)

$(title_file):
	yt-dlp --print '%(title)s [%(id)s]' $(URL) > $@

$(base)$(v):
	yt-dlp -o $(base) $(URL)
	@stat $@

endif

%$(stamped_suffix)$(v): %$(v)
	ffmpeg \
		-i $< \
		-vf \
			"drawtext=fontfile=FreeSansBold.ttf:fontcolor=black:fontsize=40:box=1:boxborderw=10:boxcolor=white:x=(w-10-30-text_w):y=(h-10-100-text_h):text='%{pts\:gmtime\:0\:%M\\\\\:%S}'" \
		$@

%$(stamped_suffix)$(a): %$(stamped_suffix)$(v)
	ffmpeg -i $< $@

add_video_rule = \
	ffmpeg \
		-i $*$(v) \
		-i $< \
		-c:v copy \
		-map 0:v:0 \
		-map 1:a:0 \
		$@

ifneq ($(isolated_suffix),)

%$(isolated_suffix)$(a): %$(a)
	demucs --two-stems=vocals $<
	mv separated/*/$*/no_vocals$(a) $@
	rm -r separated

%$(isolated_suffix)$(v): %$(isolated_suffix)$(a) %$(v)
	$(add_video_rule)

endif

ifneq ($(shifted_suffix),)

%$(shifted_suffix)$(a): %$(a)
	sox $< $@ pitch $(SHIFT)

%$(shifted_suffix)$(v): %$(shifted_suffix)$(a) %$(v)
	$(add_video_rule)

endif

half_speed_rule = \
	ffmpeg \
		-i $< \
		-vf "setpts=(PTS-STARTPTS)*2" \
		-af atempo=0.5 \
		$@

%$(half_speed_suffix)$(v): %$(v)
	$(half_speed_rule)

%$(quarter_speed_suffix)$(v): %$(half_speed_suffix)$(v)
	$(half_speed_rule)
