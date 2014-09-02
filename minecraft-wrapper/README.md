Minecraft Wrapper
=================

* start and stop server gracefully
* Only run 1 command at a time
* mutex safely
* respond with values for command


Client
======

    echo "/tp diclophis 10000 65 0" | ruby client.rb

Server
======

The minecraft-wraper server lives in `server2.rb`. It is initially started with the `DYNASTY_FORCE=1` to ensure it removes any left over sockets and creates new ones

    DYNASTY_FORCE=1 ruby server2.rb ruby blocker.rb java -jar ~/workspace/mavencraft/craftbukkit-beta.jar

To hot reload the server just execute

    ruby server2.rb 

