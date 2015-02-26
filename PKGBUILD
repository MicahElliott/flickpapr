# Author: Micah Elliott <mde@MicahElliott.com>

pkgname=flickpapr-git
pkgver=20150225
pkgrel=1
pkgdesc="randomly choose an “interesting” flickr photo for desktop wallpaper"
arch=('any')
url="https://github.com/MicahElliott/flickpapr"
license=('WTFPL')
depends=('zsh' 'ruby' 'ruby-nokogiri' 'libnotify' 'feh' 'imagemagick' 'daemonize' 'dunst')
provides=('flickpapr' 'flickloop' 'flickd')
makedepends=('git')
source=("git://github.com/MicahElliott/flickpapr"
        'flickpapr'
        'flickloop'
        'flickd'
        'README.md'
)
md5sums=('SKIP'
         '27514fb6d509ccfef32b42f3aab76ab2'
         'da06c7dc65247a86d0ad0a97e2c6476c'
         'd4985dc9a718332491c89ef72171dea4'
         '588e9ea9f870e14e1be83faf40ca7c73')

_gitroot="git://github.com/MicahElliott/flickpapr"
_gitname=flickpapr-git

build() {
  cd "$srcdir"
  msg "Connecting to GIT server…"

  if [[ -d "$_gitname" ]]; then
    cd "$_gitname" && git pull origin
    msg "The local files are updated."
  else
    git clone "$_gitroot" "$_gitname"
  fi

  msg "GIT checkout done or server timeout"
  msg "Starting build…"

  rm -rf "$srcdir/$_gitname-build"
  git clone "$srcdir/$_gitname" "$srcdir/$_gitname-build"
  cd "$srcdir/$_gitname-build"
}

package() {
  cd "$srcdir/$_gitname-build"
  install -Dm755 flickpapr $pkgdir/usr/bin/flickpapr
  install -Dm755 flickloop $pkgdir/usr/bin/flickloop
  install -Dm755 flickd $pkgdir/usr/bin/flickd
  #install -Dm644 flickpapr.1.gz $pkgdir/usr/share/man/man1/flickpapr.1.gz
}

# vim:set ts=2 sw=2 et:
