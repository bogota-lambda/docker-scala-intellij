# Run Intellij Idea

    docker run -tdi \
               --net="host" \
               --privileged=true \
               -e DISPLAY=${DISPLAY} \
               intellij-scala                                                                                                                  
