$default_pkg_config_libdir = "/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig"
$override_pkg_config_libdir = $env:PKG_CONFIG_PATH
$env:PKG_CONFIG_LIBDIR = $override_pkg_config_libdir
