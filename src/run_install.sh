#!/bin/bash -w

# Helper for staging REAL and NonLinLoc binaries after you compile them.
# Run this script from the src directory.

mkdir -p ../bin

# REAL: compile the REAL repository cloned under src/REAL first.
if [[ -d REAL/bin ]]
then
    cp REAL/bin/* ../bin/
else
    echo "REAL/bin not found; compile src/REAL before copying REAL binaries"
fi

# NonLinLoc: compile the NonLinLoc repository cloned under src/NonLinLoc first.
if [[ -d NonLinLoc/src/bin ]]
then
    cp \
        NonLinLoc/src/bin/Vel2Grid \
        NonLinLoc/src/bin/Grid2Time \
        NonLinLoc/src/bin/NLLoc \
        NonLinLoc/src/bin/LocSum \
        NonLinLoc/src/bin/Grid2GMT \
        NonLinLoc/src/bin/Time2EQ \
        NonLinLoc/src/bin/Loc2ssst \
        ../bin/
else
    echo "NonLinLoc/src/bin not found; compile src/NonLinLoc before copying NonLinLoc binaries"
fi

echo "Add this repository's bin directory to PATH, for example:"
echo "export PATH=/path/to/SeisBench-REAL-NonLinLoc-SSST/bin:\$PATH"
