# Author: Micah Elliott <mde@MicahElliott.com>

pkgname=flickpapr-git
pkgver=20150225
pkgrel=1
pkgdesc="randomly choose an “interesting” flickr photo for desktop wallpaper"
arch=('any')
url="https://github.com/MicahElliott/flickpapr"
license=('WTFPL')
depends=('zsh' 'ruby' 'ruby-nokogiri' 'libnotify' 'feh' 'imagemagick' 'daemonize' 'dunst')
provides=('flickpapr' 'flickd')
makedepends=('git')
source=("git://github.com/MicahElliott/flickpapr"
        'flickpapr'
        'flickd'
        'README.md'
)
md5sums=('SKIP'
         '8016dc63720efe012aff077e191d7a9d'
         'ba2d7f3f270e8dd81024772e826f1a4b'
         '812c130dd3d52cc36c182580cd35a5ca')

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
  install -Dm755 flickd $pkgdir/usr/bin/flickd
  install -Dm644 flickpapr.1.gz $pkgdir/usr/share/man/man1/flickpapr.1.gz
}

# vim:set ts=2 sw=2 et:
