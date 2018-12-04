max_stale = "2m"


template {
  source = "/root/templates/mini-dinstall.template"
  destination = "/etc/mini-dinstall"
}

exec {
  command = "/usr/local/bin/start.sh"
  splay = "60s"
}
