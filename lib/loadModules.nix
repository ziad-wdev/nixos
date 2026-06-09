# Helper function to load all .nix files from module categories
# Usage: loadModules ./modules [ "system" "desktop" ]
modulesPath: categories:
builtins.concatMap
  (category:
    let
      categoryPath = modulesPath + "/${category}";
    in
    if builtins.pathExists categoryPath then
      map
        (file: categoryPath + "/${file}")
        (builtins.filter (f: builtins.match ".*\\.nix$" f != null)
          (builtins.attrNames (builtins.readDir categoryPath)))
    else
      []
  )
  categories
