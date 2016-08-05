# Run Intellij Idea

1. First time

    `docker run -tdi --net="host" --privileged=true -e DISPLAY=${DISPLAY} --name intellij-idea-scala ftrianakast/intellij-idea-scala`    

2. The next time

    `docker start intellij-idea-scala`