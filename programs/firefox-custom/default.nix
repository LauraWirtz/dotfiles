{ lib, pkgs, config, ...}:
let
	cfg = config.programs.firefox-custom;
	extensions = [
		"FirefoxColor@mozilla.com"					# Firefox Color
		"{3c078156-979c-498b-8990-85f7987dd929}"	# Sidebery
		"sponsorBlocker@ajay.app"					# SponsorBlock
		"uBlock0@raymondhill.net"					# uBlock Origin
		"{6b733b82-9261-47ee-a595-2dda294a4d08}"    # Yomitan
	];
in {
	options.programs.firefox-custom = {
		enable = lib.mkEnableOption "Enable custom firefox";
		arch.enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
		};
		arch.c = lib.mkOption {
			type = lib.types.str;
			default = "x86-64-v3";
		};
		arch.rust = lib.mkOption {
			type = lib.types.str;
			default = "x86_64-unknown-linux-gnu";
		};
	};

	config = lib.mkIf cfg.enable {
		#config contents
		nixpkgs.overlays = lib.mkIf cfg.arch.enable [
			(final: prev: {
				firefox-unwrapped = prev.firefox-unwrapped.overrideAttrs (previousAttrs: rec {
					rustFlags = previousAttrs.makeFlags ++ [
						"-C"
						"target-cpu=${cfg.arch.rust}"
					];
					makeFlags = previousAttrs.makeFlags ++ [
						"CXXFLAGS+=-O3"
						"CXXFLAGS+=-mtune=${cfg.arch.c}"
						"CXXFLAGS+=-march=${cfg.arch.c}"
						"CFLAGS+=-O3"
						"CFLAGS+=-mtune=${cfg.arch.c}"
						"CFLAGS+=-march=${cfg.arch.c}"
						"KCFLAGS+=-O3"
						"KCFLAGS+=-mtune=${cfg.arch.c}"
						"KCFLAGS+=-march=${cfg.arch.c}"
# 						"KCFLAGS+=-Wno-unused-command-line-argument"
# 						"CC=${pkgs.llvmPackages.clang-unwrapped}/bin/clang"
# 						"AR=${pkgs.llvm}/bin/llvm-ar"
# 						"NM=${pkgs.llvm}/bin/llvm-nm"
# 						"LD=${pkgs.lld}/bin/ld.lld"
# 						"LLVM=1"
					];
				});
			})
		];
		programs.firefox = {
			enable = true;
			languagePacks = [ "en-US" "de" "en-GB" ];
			package = pkgs.firefox.override {
				cfg.speechSynthesisSupport=false;
			};

			# Check about:policies#documentation for options.
			policies = {
				AIControls = {
					Default = {
						Value = "blocked";
						Locked = true;
					};
				};
				AutofillAddressEnabled = false;
				AutofillCreditCardEnabled = false;
				DisableAppUpdate = true;
				DisableFirefoxScreenshots = true;
				DisableFirefoxStudies = true;
				DisableFormHistory = true;
				DisablePocket = true;
				DisableSetDesktopBackground = true;
				DisableTelemetry = true;
				DisplayBookmarksToolbar = "always";
				DontCheckDefaultBrowser = true;
				EnableTrackingProtection = {
					Value = true;
					Locked = true;
					Category = "strict";
					Cryptomining = true;
					EmailTracking = true;
					Fingerprinting = true;
					SuspectedFingerprinting = true;
				};
				FirefoxSuggest = {
					WebSuggestions = false;
					SponsoredSuggestions = false;
					ImproveSuggest = false;
					Locked = true;
				};
				GenerativeAI = {
					Enabled = false;
					Locked = true;
				};
				Homepage = "previous-session";
				HttpAllowlist = [
					"http://localhost"
					"http://127.0.0.1"
				];
				HttpsOnlyMode = "force_enabled";
				NetworkPrediction = false;
				NewTabPage = false;
				NoDefaultBookmarks = true;
				Permissions = {
					Camera = {
						BlockNewRequests = true;
						Locked = true;
					};
					Microphone = {
						BlockNewRequests = true;
						Locked = true;
					};
					Location = {
						Allow = ["https://www.google.com/maps" "https://connect.garmin.com"];
						BlockNewRequests = true;
						Locked = true;
					};
					Notifications = {
						BlockNewRequests = true;
						Locked = true;
					};
					Autoplay = {
						Allow = ["https://www.youtube.com"];
						Default = "block-audio";
						BlockNewRequests = true;
						Locked = true;
					};
					VirtualReality = {
						BlockNewRequests = true;
						Locked = true;
					};
					ScreenShare = {
						BlockNewRequests = true;
						Locked = true;
					};
				};
				PostQuantumKeyAgreementEnabled = true;
				SanitizeOnShutdown = {
					Cache = true;
					FormData = true;
# 					History = true;
					Locked = true;
				};
				SSLVersionMin = "tls1.2";
				TranslateEnabled = false;
				UserMessaging = {
					ExtensionRecommendations = false;
					FeatureRecommendations = false;
					UrlbarInterventions = false;
					SkipOnboarding = true;
					MoreFromMozilla = false;
					FirefoxLabs = false;
					Locked = true;
				};

				SearchEngines = {
					Remove = [
						"Bing"
						"eBay"
						"Ecosia"
						"Perplexity"
						"Tagesschau"
						"Wikipedia"
					];
					Add = [
						{
							Name = "DuckDuckGo";
							URLTemplate = "https://duckduckgo.com/?q={searchTerms}&ia=web&assist=false";
							SuggestURLTemplate = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
							IconURL = "https://duckduckgo.com/favicon.ico";
							Alias = "ddg";
							Description = "Duckduckgo without AI integrations";
						}
# 						{
# 							"Name" = "Wikipedia";
# 							"URLTemplate" = "https://en.wikipedia.org/wiki/Special:Search?go=Go&search={searchTerms}";
# 							"IconURL" = "https://en.wikipedia.org/favicon.ico";
# 							"Alias" = "wiki";
# 						}
					];
					Default = "DuckDuckGo";
				};

				ExtensionSettings = builtins.listToAttrs (builtins.map (id: {
					name = id;
					value = {
						install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
						installation_mode = "force_installed";
					};
				}) extensions);
			};

			preferencesStatus = "locked";
			preferences = {

				#### FEATURES ###
# 				"layout.spellcheckDefault" = 1;
				# Use the systems native filechooser portal
				"widget.use-xdg-desktop-portal.file-picker" = 1;
				# allow adblockers to act everywhere. WARNING this is a security hole.
	# 			"extensions.webextensions.restrictedDomains" = "";
# 				"media.webrtc.camera.allow-pipewire" = true;
# 				"browser.download.always_ask_before_handling_new_types" = true;


				#### DEBLOAT ###
				"browser.discovery.enabled" = false;
				"app.shield.optoutstudies.enabled" = false;
				"browser.topsites.contile.enabled" = false;
				"browser.urlbar.suggest.addons" = false;
				"browser.urlbar.suggest.amp" = false;
				"browser.urlbar.suggest.bookmark" = false;
				"browser.urlbar.suggest.calculator" = false;
				"browser.urlbar.suggest.clipboard" = false;
				"browser.urlbar.suggest.engines" = false;
				"browser.urlbar.suggest.history" = false;
				"browser.urlbar.suggest.importantDates" = false;
				"browser.urlbar.suggest.mdn" = false;
				"browser.urlbar.suggest.openpage" = false;
				"browser.urlbar.suggest.quickactions" = false;
				"browser.urlbar.suggest.quicksuggest.sponsored" = false;
				"browser.urlbar.suggest.remotetab" = false;
				"browser.urlbar.suggest.sports" = false;
				"browser.urlbar.suggest.topsites" = false;
				"browser.urlbar.suggest.trending" = false;
				"browser.urlbar.suggest.weather" = false;
				"browser.urlbar.suggest.wikipedia" = false;
				"browser.urlbar.suggest.yelp" = false;
				"browser.urlbar.suggest.yelpRealtime" = false;
				"browser.urlbar.trending.featureGate" = false;
# 				"browser.newtabpage.activity-stream.feeds.section.topstories" = false;
# 				"browser.newtabpage.activity-stream.feeds.snippets" = false;
# 				"browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
# 				"browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
# 				"browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
# 				"browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
# 				"browser.newtabpage.activity-stream.showSponsored" = false;
# 				"browser.newtabpage.activity-stream.system.showSponsored" = false;
# 				"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
				# Privacy: Disable automatic opening in new windows (manually still works)
				# https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/9881
				"browser.link.open_newwindow" = 3;
				# Privacy: Set all window open modes to abide above method
				"browser.link.open_newwindow.restriction"= 0;

				"browser.tabs.inTitlebar"=0;
				"toolkit.legacyUserProfileCustomizations.stylesheets"=true;

				#### PRIVACY ###
				"privacy.resistFingerprinting" = "true";
				# disable sending downloaded files to the internet
				"browser.safebrowsing.downloads.remote.enabled" = false;
				"network.dns.disablePrefetch" = true;
				# redundancy: disable network prefetching
				"network.predictor.enabled" = false;
				# disable preloading websites when hovering over links
				"network.http.speculative-parallel-limit" = 0;
				# disable connecting to bookmarks when hovering over them
				"browser.places.speculativeConnect.enabled" = "false";
				"privacy.globalprivacycontrol.enabled" = true;
				"privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
				"privacy.fingerprintingProtection" = true;

				"browser.contentblocking.category" = "strict";
				"extensions.pocket.enabled" = false;
				# store media in cache only on private browsing
				"browser.privatebrowsing.forceMediaMemoryCache" = true;
				"network.http.referer.XOriginTrimmingPolicy" = 2;
				# Privacy: Disable CSP reporting
				# https://bugzilla.mozilla.org/show_bug.cgi?id=1964249
				"security.csp.reporting.enabled" = false;

				#### SECURITY ###
				#"browser.formfill.enable" = false;
				"pdfjs.enableScripting" = false;
				#"signon.autofillForms" = false
				# UNCLEAR
				"signon.formlessCapture.enabled" = false;
				# prevent scripts from moving or resizing windows
				"dom.disable_window_move_resize" = true;
				# Security: Disable remote debugging feature
				# https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/16222
# 				"devtools.debugger.remote-enabled" = false;
				# Security: Restrict directories from which extensions can be loaded (Unclear)
				# https://archive.is/DYjAM
				"extensions.enabledScopes" = 5;

				#### SSL ###
				# Security: Require safe SSL negotiation to avoid potentially MITMed sites
				"security.ssl.require_safe_negotiation" = true;
				# Security: Disable TLS1.3 0-RTT as key encryption may not be forward secret
				# https://github.com/tlswg/tls13-spec/issues/1001
				"security.tls.enable_0rtt_data" = 2;
				# Security: Enable strict public key pinning, prevents some MITM attacks
				"security.cert_pinning.enforcement_level" = 2;
				# Security: Enable CRLite to ensure that revoked certificates are detected
				"security.pki.crlite_mode" = 2;
				# Security: Treat unsafe negotiation as broken
				# https://wiki.mozilla.org/Security:Renegotiation
				# https://bugzilla.mozilla.org/1353705
				"security.ssl.treat_unsafe_negotiation_as_broken" = true;
				#  Security: Display more information on Insecure Connection warning pages
				# Test: https://badssl.com
				"browser.xul.error_pages.expert_bad_cert" = true;
			};
		};
	};
}
