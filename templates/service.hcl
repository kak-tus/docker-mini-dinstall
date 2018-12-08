max_stale = "2m"


template {
  source = "/root/templates/mini-dinstall.template"
  destination = "/etc/mini-dinstall"
}

template {
  source = "/root/templates/passphrase.template"
  destination = "/etc/passphrase"
}

template {
  source = "/root/templates/private_key.gpg.template"
  destination = "/etc/private_key.gpg"
}

template {
  source = "/root/templates/public_key.template"
  destination = "/etc/public_key"
}

exec {
  command = "/usr/local/bin/start.sh"
  splay = "60s"
}
