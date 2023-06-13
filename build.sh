if [! -d "assimp"]
then
    git clone "https://github.com/assimp/assimp" assimp
fi

cd assimp

cmake -GNinja^ \
    -DASSIMP_NO_EXPORT=OFF^
    -DASSIMP_INSTALL_PDB=OFF^ \
    -DASSIMP_BUILD_ASSIMP_TOOLS=OFF^ \
    -DASSIMP_BUILD_TESTS=OFF^ \
    -DASSIMP_BUILD_ALL_EXPORTERS_BY_DEFAULT=OFF^ \
    -DASSIMP_BUILD_ALL_IMPORTERS_BY_DEFAULT=OFF^ \
    -DASSIMP_BUILD_FBX_IMPORTER=ON^ \
    -DASSIMP_BUILD_GLTF_IMPORTER=ON^ \
    -DASSIMP_BUILD_ZLIB=ON^ \
    -DCMAKE_BUILD_TYPE=Release^ \
    .

ninja -j%NUMBER_OF_PROCESSORS%

cp bin/*.so ../libs/assimp.so
cp lib/*.a ../libs/assimp.a

cd ..