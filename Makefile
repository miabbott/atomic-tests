.PHONY: rpm
rpm: aht-dummy.spec
	rpmbuild -ba \
		--define "_sourcedir $$PWD" \
		--define "_specdir $$PWD" \
		--define "_builddir $$PWD/.build" \
		--define "_srcrpmdir $$PWD/rpms" \
		--define "_rpmdir $$PWD/rpms" \
		--define "_buildrootdir $$PWD/.buildroot" "$<"
	mv $$PWD/rpms/*/*.rpm $$PWD
	rm -rf $$PWD/.build $$PWD/.buildroot $$PWD/rpms
