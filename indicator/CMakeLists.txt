configure_file(kugiigi-indicator-immersive.py ${CMAKE_CURRENT_BINARY_DIR}/kugiigi-indicator-immersive.py)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/kugiigi-indicator-immersive.py DESTINATION ${DATA_DIR}indicator)
install(FILES "kugiigi-indicator-immersive.conf" DESTINATION ${DATA_DIR}indicator)
install(FILES "install.sh" DESTINATION ${DATA_DIR}indicator)
install(FILES "com.kugiigi.indicator.immersive" DESTINATION ${DATA_DIR}indicator)
install(FILES "uninstall.sh" DESTINATION ${DATA_DIR}indicator)
