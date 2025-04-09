// Get Polylux from the official package repository
#import "@preview/codly:1.3.0": *
#import "term/term.typ": term
#import "@preview/polylux:0.4.0": *
#import "@preview/metropolis-polylux:0.1.0" as metropolis
#import metropolis: new-section, focus
#import toolbox: side-by-side,pdfpc
#import "@preview/cades:0.3.0": qr-code
//#import themes.metropolis: *

#let handout = true
#show: metropolis.setup
//#show: metropolis-theme.with(footer: [NixOS])
// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 25pt)
//#show link: underline
//
#let m-dark-teal = rgb("#23373b")
#let m-light-brown = rgb("#eb811b")
#let alert = text.with(fill: m-light-brown)
#let title-slide(
  title: [],
  subtitle: none,
  author: none,
  date: none,
  extra: none,
) = {
  let content = {
    set text(fill: m-dark-teal)
    set align(horizon)
    block(width: 100%, inset: 2em, {
      text(size: 1.3em, strong(title))
      if subtitle != none {
        linebreak()
        text(size: 0.9em, subtitle)
      }
      line(length: 100%, stroke: .05em + m-light-brown)
      set text(size: .8em)
      if author != none {
        block(spacing: 1em, author)
      }
      if date != none {
        block(spacing: 1em, date)
      }
      set text(size: .8em)
      if extra != none {
        block(spacing: 1em, extra)
      }

    })
  }

  slide(content)
}

#let icon(codepoint) = {
  box(
    height: 0.8em,
    baseline: 0.05em,
    image(codepoint)
  )
  h(0.1em)
}

#show: codly-init.with()
#codly(
  //zebra-color: white,
  languages: (
  nix: (name: "Nix", icon: icon("pictures/nix-snowflake-colours.svg"), color: rgb("#CE412B"))
))


#enable-handout-mode(handout)
#[
  #show link: set text(blue)
  #title-slide(
  author: [#link("https://github.com/haennes")[haennes], Ole (yeet)],
  title: [#link("https://nixos.org/")[Nix(OS)]],
  subtitle: "Declarative builds and deployments",
  date: datetime.today().display(),
  extra: "Ansible? Nein Danke!",

)

  #pdfpc.speaker-note("This is a note that only the speaker will see.")
]
//[#box[#image("./pictures/nix-snowflake-colours.svg", width: 20%)]]
//#slide(title: "Inhaltsverzeichnis")[
//  #metropolis-outline
//]
  #show link: set text(blue)
#slide()[
= Nix vs NixOS
  #side-by-side(columns: (2fr, 1fr))[
  - Nix:
    #only("2-",[
    - funktionale Programmiersprache
    - package manager
    ])
  - NixOS:
    #only("3-",[
    - Linux distribution
    - nutzt Nix als:
      - package manager
      - configuration manager
    ])
  ][
    #align(right)[#box[#image("./pictures/nix-snowflake-colours.svg", width: 100%)]]
  ]

]

#new-section([Nix])

#slide()[
= Features von Nix (package manager)
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

#new-section([Nix shells])

#focus([Warum brauch ich das?])

#slide()[
= Warum brauch ich das?
   Hey, cooles Projekt, kann ich da mitprogrammieren?
 #align(right, only("2-", [
   Ja klar gerne, du musst dir nur \
   _build-essential, git, cmake_ und _libsdl2-dev_ installieren \
   dann 2x nen cmake-script laufen lassen \
   nen Ordner erstellen und dann das Compilat ausführen \
 \~ #link("https://github.com/TheOpenSpaceProgram/osp-magnum")[osp-magnum: A spaceship game]]))
]

#focus([WTF, Nein])

#slide()[
= Wie nutze ich sowas?
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

#focus[
  #grid(columns: 2, gutter: 1em, [Mega], box(image(height: 1em, "icons/face-grin-stars.svg")))
]
#focus[ Warum nicht Alles so konfigurieren? ]
//#show: metropolis-theme.with(footer: [sh <(curl -L https://nixos.org/nix/install) -\-daemon])

#new-section[Nun zum eigentlichen Thema *NixOS*]

#slide()[
= Features
  - alle Programme liegen in /nix/store
  - vollständige dependencies von Paketen / pureness
  - *nicht-Admins* können Pakete installieren
  - upgrades und rollbacks *SYSTEMWIDE*
  - konfiguriere dein gesamtes System in #link("https://github.com/haennes/dotfiles")[*einer Datei*]
]

#slide()[
= Vorteile
    - Ein Dateiformat um Alles zu konfigurieren \ #only("2")[ vom Bootloader über die installierte Software bis hin zu deiner VPN ]
    #only("3-")[
    - Teile deine Konfiguration mit anderen Systemen #only("4-")[oder auch Menschen]
    ]
    - 100% deklarativ und reproducable
    #only("5-")[
    - #only("5-")[System kaputt?] #only("6")[rollbacks]
    ]
    #only("6-")[#sym.arrow.double keine Angst vor updates]
  ]

#slide()[
= Vorteile
  #image(width: 100%, fit: "contain", "pictures/Packages_per_Distro.png")
]

#slide()[
= Nachteile
  #side-by-side[
  - Lernkurve...
  - dynamische libraries schwieriger
  ][
    #image("pictures/difficulty-of-nix.jpeg")
  ]
]

#slide()[
= kleiner Auszug aus einer Konfiguration
  #set text(size: 15pt)
  #side-by-side[
    ```nix
    { config, pkgs, ...}:{
      imports = [./hardware-configuration.nix ];
      bootl.loader.grub.enable = true;
      networking.hostName = "nixos";
      time.timeZone = "Europe/Berlin";
      users.users.hannses = {
        extraGroups = ["networkmanager" "wheel"];
        packages = with pkgs; [ firefox ];
      };
      environment.systemPackages = with pkgs; [
        gcc
      ];
    }
    ```
      ][
    ```nix
    {config, lib, ...}:{
    boot.kernelModules = [ "kvm-amd" "amdgpu"];
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/c4a7f0..4b389";
      fsType = "ext4";
    };
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    }
    ```
    ]
]


#new-section[Flakes]

#slide()[
  #heading([#link("https://nixos.wiki/wiki/Flakes")[Was sind Flakes?]])
  - spezielle Nix expressions
  - können folgendes beschreiben:
    - Systeme
    - Pakete / Apps
    - devShells (nix-shell)
    - formatter, templates, checks, overlays, modules, ...

]
//#slide(title: [Beispiel])[#image("pictures/flake.png")]
#slide()[
= Beispiel
#set text(19pt)
```nix
{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.fnord = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
```
]


#new-section([Wie nutzt man Nix])

#focus[#text(size: 30pt, [sh <(curl -L https://nixos.org/nix/install) -\-daemon])]


#slide()[
= Weiterführende Links
 #link("https://nixos.org/")[Nix & NixOS | Declarative builds and deployments]
 #link("https://www.youtube.com/watch?v=CwfKlX3rA6E")[NixOS: Everything Everywhere All At Once - YouTube]
 #link("https://www.youtube.com/watch?v=a67Sv4Mbxmc")[Ultimate NixOS Guide | Flakes | Home-manager - YouTube]
 #link("https://www.youtube.com/watch?v=Ukglm5KJFa8")[NixOS in 60 seconds - YouTube]
 #link("https://nixos.wiki/wiki/Main_Page")[NixOS Wiki]
]

#slide()[
= :wq
  #align(center)[
    #figure(caption: [PDF zum Download], numbering: none)[#qr-code("https://github.com/haennes/Vortrag_NixOS")]
  ]
]
