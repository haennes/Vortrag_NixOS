// Get Polylux from the official package repository
#import "term/term.typ": term
#import "@preview/polylux:0.3.1": *
#import "@preview/cades:0.3.0": qr-code
#import themes.metropolis: *

#show: metropolis-theme.with(footer: [NixOS])
// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 25pt)
//#show link: underline

#[
  #show link: set text(blue)
  #title-slide(
  author: link("https://github.com/haennes")[haennes],
  title: link("https://nixos.org/")[Nix(OS)],
  subtitle: "Declarative builds and deployments",
  date: datetime.today().display(),
  extra: "Ansible? Nein Danke!",
)
]

#slide(title: "Inhaltsverzeichnis")[
  #metropolis-outline
]
  #show link: set text(blue)
#slide(title: "Nix vs NixOS")[
  - Nix:
    #only("2-",[
    - funktionale Programmiersprache
    - package manager (wie: apt, pip, appstores, ...)
    ])
  - NixOS:
    #only("3-",[
    - Linux distribution
    - nutzt Nix als:
      - package manager
      - configuration manager
    ])

]

#new-section-slide([Nix])

#slide(title: "Features von Nix")[
  - alle Programme liegen in /nix/store
    #only("2, 4-", [
    - weniger suchen 
    - mehrere Versionen
    ])
  - vollständige dependencies von Paketen / pureness
    #only("3, 5-", [
    - immer die richtige Version einer Biblothek, dank Hash nach Pfad
    - immer alle dependencies (sonst funktioniert die Software nicht)
    ])
    #only("4",[
    - #term(width: 100%, content: text(green)[/nix/store/avg4nfsj9shm81g0v142dfdlifq8j149-pdfpc-0.7.1-tex.drv])
    ])
  - Nutzer können ohne Adminrechte Pakete installieren
  - upgrades und rollbacks #only("6-", alert([später: Demo... also wenn genügend Zeit ist]))
]

#new-section-slide([Nix shells])

#focus-slide([Warum brauch ich das?])

#slide(title: "Warum brauch ich das?")[
   Hey, cooles Projekt, kann ich da mitprogrammieren? 
 #align(right, only("2-", [
   Ja klar gerne, du musst dir nur \
   _build-essential, git, cmake_ und _libsdl2-dev_ installieren \
   dann 2x nen cmake-script laufen lassen \
   nen Ordner erstellen und dann das Compilat ausführen \
 \~ #link("https://github.com/TheOpenSpaceProgram/osp-magnum")[osp-magnum: A spaceship game]])) 
]

#focus-slide([WTF, Nein])

#slide(title: "Wie nutze ich sowas?")[
  + *EINER* schreibt eine "flake.nix" #only("2")[oder "shell.nix"]
  #only("2")[
  #enum.item(2)[
  #grid(columns: 3, gutter: 1em,
    term(content: [ \$ nix develop]), [oder], term(content: [ \$ nix-shell])
  )]
  + Bereit zum Entwickeln
  ]
  #only("3")[
  #enum.item(2)[
    #term(content: [ \$ nix run .\#])
  ]
  + das Programm läuft
  ]
]

#focus-slide[
  #grid(columns: 2, gutter: 1em, [Mega], box(image(height: 1em, "icons/face-grin-stars.svg")))
]
#focus-slide[ Warum nicht Alles so konfigurieren? ]
//#show: metropolis-theme.with(footer: [sh <(curl -L https://nixos.org/nix/install) -\-daemon])

#new-section-slide[Nun zum eigentlichen Thema *NixOS*]

#slide(title: "Features")[
  - alle Programme liegen in /nix/store
  - vollständige dependencies von Paketen / pureness
  - *nicht-Admins* können Pakete installieren
  - upgrades und rollbacks *SYSTEMWIDE* 
  - konfiguriere dein gesamtes System in #link("https://github.com/haennes/dotfiles")[*einer Datei*]
]

#slide(title: "Vorteile")[
    - Ein Dateiformat um Alles zu konfigurieren \ #only("2")[ vom Bootloader über die installierte Software bis hin zu deiner VPN ]
    #only("3-")[
    - Teile deine Konfiguration mit anderen Systemen #only("4-")[oder auch Menschen]
    ]
    - 100% deklarativ und reproducable
    #only("5-")[
    - #only("5-")[System kaputt?] #only("6")[rollbacks]
    ]
    #only("6-")[$=>$ keine Angst vor updates]
  ]
  
#slide(title: "Vorteile")[
  #image(width: 100%, fit: "contain", "pictures/Packages_per_Distro.png")
]

#slide(title: "Nachteile")[
  #side-by-side[ 
  - Lernkurve...
  - dynamische libraries schwieriger
  ][
    #image("pictures/learningcurve.jpg")
  ]
]

#slide(title: "kleiner Auszug aus einer Konfiguration")[
  #side-by-side[
    #figure(caption: text(size: 15pt)[/etc/nixos/configuration.nix], numbering: none,image( "pictures/conf.png"))
  ][
    #figure(caption: text(size: 15pt)[/etc/nixos/hardware-configuration.nix], numbering: none, image("pictures/hardwareconf.png"))
  ]
]


#new-section-slide[Flakes]

#slide(title: [#link("https://nixos.wiki/wiki/Flakes")[Was sind Flakes?]])[
  - spezielle Nix expressions
  - können folgendes beschreiben:
    - Systeme
    - Pakete / Apps 
    - devShells (nix-shell)
    - formatter, templates, checks, overlays, modules, ...

]
#slide(title: [Beispiel])[#image("pictures/flake.png")]
  

#new-section-slide([Wie nutzt man Nix])

#focus-slide[#text(size: 30pt, [sh <(curl -L https://nixos.org/nix/install) -\-daemon])]


#slide(title: "Weiterführende Links")[
 #link("https://nixos.org/")[Nix & NixOS | Declarative builds and deployments]
 #link("https://www.youtube.com/watch?v=CwfKlX3rA6E")[NixOS: Everything Everywhere All At Once - YouTube]
 #link("https://www.youtube.com/watch?v=a67Sv4Mbxmc")[Ultimate NixOS Guide | Flakes | Home-manager - YouTube]
 #link("https://www.youtube.com/watch?v=Ukglm5KJFa8")[NixOS in 60 seconds - YouTube]
 #link("https://nixos.wiki/wiki/Main_Page")[NixOS Wiki]
]


#slide[
  #align(center)[
    #figure(caption: [PDF zum Download], numbering: none)[#qr-code("https://typst.app")]
  ]
]
