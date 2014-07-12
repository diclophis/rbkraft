server:
	touch /tmp/minecraft-wrapper.sock && rm /tmp/minecraft-wrapper.sock && ruby server.rb java -d64 -XX:UseSSE=2 -Xmx8096M -Xms8096M -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -server -jar ~/Desktop/minecraft_server.1.7.10.jar nogui

client:
	ruby client.rb
