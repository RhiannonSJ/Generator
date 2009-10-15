#
# This is the main GENIE project Makefile.
# Each package has its own Makefile which is invoked by this one.
# Machine specific flags and locations are read from 'make/Make.include'.
# Configuration options are read from 'make/Make.config' generated by the 'configure' script.
# 
# Author: Costas Andreopoulos <costas.andreopoulos \at stfc.ac.uk>
#

SHELL = /bin/sh
NAME = all
MAKEFILE = Makefile

# Include machine specific flags and locations (inc. files & libs)
#
include $(GENIE)/src/make/Make.include

# define composite targets
#
BUILD_TARGETS =    print-make-info \
		   make-bin-lib-dir \
		   save-build-env \
		   autogenerated-headers \
		   base-framework \
		   utils \
		   evgen-framework \
		   core-medium-energy-range \
		   test-medium-energy-range \
		   vle-extension \
		   vhe-extension \
		   flux-drivers \
		   geom-drivers \
		   reweight \
		   viewer \
		   mueloss \
		   vld-tools \
		   doxygen-doc \
		   generator-test-exe \
		   generator-std-exe \
		   minos-support-softw \
		   t2k-support-softw \
  		   install-scripts
INSTALL_TARGETS =  print-makeinstall-info \
		   check-previous-installation \
		   make-install-dirs \
		   copy-install-files

# define targets

all:     $(BUILD_TARGETS)
install: $(INSTALL_TARGETS)

print-make-info: FORCE
	@echo " "
	@echo " "
	@echo "***** Building GENIE from source tree at: $(GENIE)"
	@echo "***** The source tree corresponds to GENIE version $(GVERSION)"
	@echo " "

print-makeinstall-info: FORCE
	@echo " "
	@echo " "
	@echo "***** Installing GENIE version $(GVERSION) at $(GENIE_INSTALLATION_PATH)"
	@echo " "
	
base-framework: FORCE
	@echo " "
	@echo "** Building base-framework..."
	cd ${GENIE}/src;\
	cd Algorithm;  make; cd ..; \
	cd Messenger;  make; cd ..; \
	cd Registry;   make; \
	cd ${GENIE}

utils: FORCE
	@echo " "
	@echo "** Building utility libraries..."
	cd ${GENIE}/src;\
	cd Numerical;      make; cd ..; \
	cd CrossSections;  make; cd ..; \
	cd PDG;            make; cd ..; \
	cd Utils;          make; \
	cd ${GENIE}

reweight:
	@echo " "
	@echo "** Building event reweighting toolkits..."
	cd ${GENIE}/src;\
	cd ReWeight; \
        make; 

evgen-framework: FORCE
	@echo " "
	@echo "** Building evgen-framework..."
	cd ${GENIE}/src;\
	cd BaryonResonance;    make; cd ..; \
	cd Base;               make; cd ..; \
	cd EVGCore;            make; cd ..; \
	cd EVGDrivers;         make; cd ..; \
	cd Interaction;        make; cd ..; \
	cd GHEP;               make; cd ..; \
	cd Ntuple;             make; 

core-medium-energy-range: FORCE
	@echo " "
	@echo "** Building core medium energy range physics models..."
	cd ${GENIE}/src;\
	cd BodekYang;          make; cd ..; \
	cd Charm;              make; cd ..; \
	cd Coherent;           make; cd ..; \
	cd Decay; 	       make; cd ..; \
	cd Diffractive;        make; cd ..; \
	cd DIS;                make; cd ..; \
	cd Elastic; 	       make; cd ..; \
	cd ElFF; 	       make; cd ..; \
	cd EVGModules;         make; cd ..; \
	cd Fragmentation;      make; cd ..; \
	cd GiBUU;              make; cd ..; \
	cd HadronTransport;    make; cd ..; \
	cd LlewellynSmith;     make; cd ..; \
	cd NuE;                make; cd ..; \
	cd Nuclear;            make; cd ..; \
	cd PartonModel;        make; cd ..; \
	cd Paschos; 	       make; cd ..; \
	cd PDF;                make; cd ..; \
	cd QEL;                make; cd ..; \
	cd ReinSeghal;         make; cd ..; \
	cd RES;                make; cd ..; 

test-medium-energy-range: FORCE
	@echo " "
	@echo "** Building tested medium energy range physics models..."
	cd ${GENIE}/src;\
	cd MEC;                make; cd ..; \
	cd NuGamma;            make; cd ..; 

vle-extension: FORCE
ifeq ($(strip $(GOPT_ENABLE_VLE_EXTENSION)),YES)
	@echo " "
	@echo "** Building VLE extension..."
	cd ${GENIE}/src/VLE; \
	make; \
	cd ${GENIE}
else
	@echo " "
	@echo "** The VLE extension was not enabled. Skipping..."
endif

vhe-extension: FORCE
ifeq ($(strip $(GOPT_ENABLE_VLE_EXTENSION)),YES)
	@echo " "
	@echo "** Building VHE extension..."
	cd ${GENIE}/src/VHE; \
	make; \
	cd ${GENIE}
else
	@echo " "
	@echo "** The VHE extension was not enabled. Skipping..."
endif

flux-drivers: FORCE
ifeq ($(strip $(GOPT_ENABLE_FLUX_DRIVERS)),YES)
	@echo " "
	@echo "** Building flux-drivers..."
	cd ${GENIE}/src/FluxDrivers; \
	make; \
	cd ${GENIE}
else
	@echo " "
	@echo "** Building flux-drivers was not enabled. Skipping..."
endif

geom-drivers: FORCE
ifeq ($(strip $(GOPT_ENABLE_GEOM_DRIVERS)),YES)
	@echo " "
	@echo "** Building geometry-drivers..."
	cd ${GENIE}/src/Geo; \
	make; \
	cd ${GENIE}
else
	@echo " "
	@echo "** Building geometry-drivers was not enabled. Skipping..."
endif

viewer: FORCE
ifeq ($(strip $(GOPT_ENABLE_VIEWER)),YES)
	@echo " "
	@echo "** Buidling viewer..."
	cd ${GENIE}/src/Viewer; \
	make; \
	cd ${GENIE}
else
	@echo " "
	@echo "** Viewer was not enabled. Skipping..."
endif

mueloss: FORCE
ifeq ($(strip $(GOPT_ENABLE_MUELOSS)),YES)
	@echo " "
	@echo "** Building mueloss utility package..."
	cd ${GENIE}/src/MuELoss; \
	make; \
	cd ${GENIE}
else
	@echo "** Mueloss was not enabled. Skipping..."
endif

#dummy-neugen: FORCE
#ifeq ($(strip $(GOPT_ENABLE_NEUGEN)),NO)
#	@echo " "
#	@echo "** Neugen was not enabled. Building dummy-neugen..."
#	cd ${GENIE}/src;\
#	cd NuValidator; make dummy-neugen; \
#	cd ${GENIE}
#else
#	@echo " "
#	@echo "** Neugen was enabled. Will not build dummy version..."
#endif

#neugen: FORCE
#ifeq ($(strip $(GOPT_ENABLE_NUVALIDATOR)),YES)
#	@echo " "
#	@echo "** Building nuvalidator's neugen interface..."
#	cd ${GENIE}/src;\
#	cd NuValidator; make neugen; \
#	cd ${GENIE}
#else
#endif

#nuvld-libs: FORCE
#ifeq ($(strip $(GOPT_ENABLE_NUVALIDATOR)),YES)
#	@echo " "
#	@echo "** Building nuvalidator libraries..."
#	cd ${GENIE}/src/NuValidator; \
#	make libs; \
#	cd ${GENIE}
#else
#	@echo " "
#	@echo "** Nuvalidator was not enabled. Skipping..."
#endif

#nuvld-exe: FORCE
#ifeq ($(strip $(GOPT_ENABLE_NUVALIDATOR)),YES)
#	@echo " "
#	@echo "** Building nuvalidator executables..."
#	cd ${GENIE}/src/NuValidator; \
#	make exe; \
#	cd ${GENIE}
#else
#endif

vld-tools: FORCE
ifeq ($(strip $(GOPT_ENABLE_VALIDATION_TOOLS)),YES)
	@echo " "
	@echo "** Building GENIE validation tools..."
	cd ${GENIE}/src/ValidationTools/NuVld; \
	make; \
	cd ${GENIE}/src/ValidationTools/NuVld/app; \
	make; \
	cd ${GENIE}/src/ValidationTools/Basic; \
	make; \
	cd ${GENIE}/src/ValidationTools/CrossSections; \
	make; \
	cd ${GENIE}/src/ValidationTools/Hadronization; \
	make; \
	cd ${GENIE}/src/ValidationTools/Merenyi; \
	make; \
	cd ${GENIE}
else
	@echo " "
	@echo "** GENIE validation tools were disabled. Skipping..."
endif

# This target is used for generating the doxygen documentation
# during the genie build. 
# It only does so if the option has been enabled explicitly by the user.
doxygen-doc: FORCE
ifeq ($(strip $(GOPT_ENABLE_DOXYGEN_DOC)),YES)
	@echo " "
	@echo "** Building doxygen documentation..."
	cd ${GENIE}/src/scripts;\
	make doxygen; \
	cd ${GENIE};
else
endif

# Use this target  to generate the doxygen documentation at any
# point, independently of your local genie build.
doxygen: FORCE
	@echo " "
	@echo "** Building doxygen documentation..."
	cd ${GENIE}/src/scripts \
	make doxygen; \
	cd ${GENIE}

generator-std-exe: FORCE
	@echo " "
	@echo "** Building GENIE applications..."
	cd ${GENIE}/src/stdapp;\
	make all; \
	cd ${GENIE}

generator-test-exe: FORCE
ifeq ($(strip $(GOPT_ENABLE_TEST)),YES)
	@echo " "
	@echo "** Building test applications..."
	cd ${GENIE}/src/test;\
	make all; \
	cd ${GENIE}
else
endif

minos-support-softw: FORCE
	@echo " "
	@echo "** Building MINOS-specific support software..."
ifeq ($(strip $(GOPT_ENABLE_MINOS)),YES)
	@echo "* Building MINOS-specific GENIE tools"
	cd ${GENIE}/src/support/minos/EventServer/;\
	make all; \
	cd ${GENIE}
else
endif

t2k-support-softw: FORCE
	@echo " "
	@echo "** Building T2K-specific support software..."
ifeq ($(strip $(GOPT_ENABLE_T2K)),YES)
	@echo "* Building T2K-specific GENIE tools"
	cd ${GENIE}/src/support/t2k/EvGen/;\
	make all; \
	cd ${GENIE}/src/support/t2k/SKNorm/;\
	make all; \
	cd ${GENIE}
else
endif

install-scripts: FORCE
	@echo " "
	@echo "** Installing scripts..."
	cd ${GENIE}/src/scripts;\
	make install; \
	cd ${GENIE}

all-libs: base-framework \
	  utils \
	  physics-models-modules \
	  event-generation-modules \
	  flux-drivers \
	  geom-drivers \
	  viewer \
	  mueloss 

save-build-env: FORCE
	@echo " "
	@echo "** Taking a snapshot of the build environment..."
	perl ${GENIE}/src/scripts/setup/genie-build-env-snapshot

autogenerated-headers: FORCE
	@echo " "
	@echo "** Adding automatically generated code..."
	perl ${GENIE}/src/scripts/setup/genie-write-gbuild
	perl ${GENIE}/src/scripts/setup/genie-write-gversion

make-bin-lib-dir: FORCE
	@echo " "
	@echo "** Creating GENIE lib and bin directories..."
	cd ${GENIE}; \
	[ -d bin ] || mkdir bin; chmod 755 bin;\
	[ -d lib ] || mkdir lib; chmod 755 lib;

check-previous-installation: FORCE
	@echo " "
	@echo "** Testing for existing GENIE installation at specified installation location..."
ifeq ($(strip $(GENIE_PREVIOUS_INSTALLATION)),YES)
	$(error Previous installation exists at your specified installation path: $(GENIE_INSTALLATION_PATH). Trgy 'gmake distclean' first)
endif

make-install-dirs: FORCE
	@echo " "
	@echo "** Creating directory structure for GENIE installation..."
	[ -d ${GENIE_INSTALLATION_PATH} ] || mkdir ${GENIE_INSTALLATION_PATH}
	cd ${GENIE_INSTALLATION_PATH}
	[ -d ${GENIE_BIN_INSTALLATION_PATH}     ] || mkdir ${GENIE_BIN_INSTALLATION_PATH}
	[ -d ${GENIE_LIB_INSTALLATION_PATH}     ] || mkdir ${GENIE_LIB_INSTALLATION_PATH}
	[ -d ${GENIE_INCBASE_INSTALLATION_PATH} ] || mkdir ${GENIE_INCBASE_INSTALLATION_PATH}
	mkdir ${GENIE_INC_INSTALLATION_PATH}
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Algorithm
	mkdir ${GENIE_INC_INSTALLATION_PATH}/BaryonResonance
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Base
	mkdir ${GENIE_INC_INSTALLATION_PATH}/BodekYang
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Charm
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Coherent
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Conventions
	mkdir ${GENIE_INC_INSTALLATION_PATH}/CrossSections
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Decay
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Diffractive
	mkdir ${GENIE_INC_INSTALLATION_PATH}/DIS
	mkdir ${GENIE_INC_INSTALLATION_PATH}/EVGCore
	mkdir ${GENIE_INC_INSTALLATION_PATH}/EVGDrivers
	mkdir ${GENIE_INC_INSTALLATION_PATH}/EVGModules
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Elastic
	mkdir ${GENIE_INC_INSTALLATION_PATH}/ElFF
	mkdir ${GENIE_INC_INSTALLATION_PATH}/FluxDrivers
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Fragmentation
	mkdir ${GENIE_INC_INSTALLATION_PATH}/GHEP
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Geo
	mkdir ${GENIE_INC_INSTALLATION_PATH}/GiBUU
	mkdir ${GENIE_INC_INSTALLATION_PATH}/HadronTransport
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Interaction
	mkdir ${GENIE_INC_INSTALLATION_PATH}/LlewellynSmith
	mkdir ${GENIE_INC_INSTALLATION_PATH}/MEC
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Messenger
	mkdir ${GENIE_INC_INSTALLATION_PATH}/MuELoss
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Ntuple
	mkdir ${GENIE_INC_INSTALLATION_PATH}/NuE
	mkdir ${GENIE_INC_INSTALLATION_PATH}/NuGamma
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Nuclear
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Numerical
	mkdir ${GENIE_INC_INSTALLATION_PATH}/PDF
	mkdir ${GENIE_INC_INSTALLATION_PATH}/PDG
	mkdir ${GENIE_INC_INSTALLATION_PATH}/PartonModel
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Paschos
	mkdir ${GENIE_INC_INSTALLATION_PATH}/QEL
	mkdir ${GENIE_INC_INSTALLATION_PATH}/RES
	mkdir ${GENIE_INC_INSTALLATION_PATH}/ReWeight
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Registry
	mkdir ${GENIE_INC_INSTALLATION_PATH}/ReinSeghal
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Utils
	mkdir ${GENIE_INC_INSTALLATION_PATH}/VLE
	mkdir ${GENIE_INC_INSTALLATION_PATH}/VHE
	mkdir ${GENIE_INC_INSTALLATION_PATH}/ValidationTools/
	mkdir ${GENIE_INC_INSTALLATION_PATH}/ValidationTools/NuVld/
	mkdir ${GENIE_INC_INSTALLATION_PATH}/Viewer

copy-install-files: FORCE
	@echo " "
	@echo "** Copying libraries/binaries/headers to installation location..."
	cp ${GENIE_BIN_PATH}/* ${GENIE_BIN_INSTALLATION_PATH};\
	cd ${GENIE}/src;\
	cd Algorithm;              make install; cd ..; \
	cd BaryonResonance;        make install; cd ..; \
	cd Base;                   make install; cd ..; \
	cd BodekYang;              make install; cd ..; \
	cd Charm;                  make install; cd ..; \
	cd Coherent;               make install; cd ..; \
	cd Conventions;            make install; cd ..; \
	cd CrossSections;          make install; cd ..; \
	cd Decay; 	           make install; cd ..; \
	cd Diffractive; 	   make install; cd ..; \
	cd DIS; 		   make install; cd ..; \
	cd Elastic; 	           make install; cd ..; \
	cd ElFF; 	           make install; cd ..; \
	cd EVGCore;                make install; cd ..; \
	cd EVGModules;             make install; cd ..; \
	cd EVGDrivers;             make install; cd ..; \
	cd FluxDrivers;            make install; cd ..; \
	cd Fragmentation;          make install; cd ..; \
	cd GHEP;                   make install; cd ..; \
	cd Geo;                    make install; cd ..; \
	cd GiBUU;                  make install; cd ..; \
	cd HadronTransport;        make install; cd ..; \
	cd Interaction;            make install; cd ..; \
	cd LlewellynSmith;         make install; cd ..; \
	cd MEC;	                   make install; cd ..; \
	cd Messenger;	           make install; cd ..; \
	cd MuELoss;	           make install; cd ..; \
	cd Nuclear;                make install; cd ..; \
	cd Ntuple;                 make install; cd ..; \
	cd NuE;                    make install; cd ..; \
	cd NuGamma;                make install; cd ..; \
	cd Numerical;              make install; cd ..; \
	cd PartonModel;            make install; cd ..; \
	cd Paschos;                make install; cd ..; \
	cd PDF;                    make install; cd ..; \
	cd PDG;                    make install; cd ..; \
	cd QEL;                    make install; cd ..; \
	cd RES;                    make install; cd ..; \
	cd Registry;               make install; cd ..; \
	cd ReinSeghal;             make install; cd ..; \
	cd ReWeight;               make install; cd ..; \
	cd Utils;                  make install; cd ..; \
	cd VLE;                    make install; cd ..; \
	cd VHE;                    make install; cd ..; \
	cd ValidationTools/NuVld;  make install; cd ../../; \
	cd Viewer;                 make install; \
	cd ${GENIE}

purge: FORCE
	@echo " "
	@echo "** Purging..."
	cd ${GENIE}/src;\
	cd Algorithm;                     make purge; cd ..; \
	cd BaryonResonance;               make purge; cd ..; \
	cd Base;                          make purge; cd ..; \
	cd BodekYang;                     make purge; cd ..; \
	cd Charm;                         make purge; cd ..; \
	cd Coherent;                      make purge; cd ..; \
	cd CrossSections;                 make purge; cd ..; \
	cd Decay; 	                  make purge; cd ..; \
	cd Diffractive;                   make purge; cd ..; \
	cd DIS; 	                  make purge; cd ..; \
	cd Elastic; 	                  make purge; cd ..; \
	cd ElFF; 	                  make purge; cd ..; \
	cd EVGCore;                       make purge; cd ..; \
	cd EVGModules;                    make purge; cd ..; \
	cd EVGDrivers;                    make purge; cd ..; \
	cd FluxDrivers;                   make purge; cd ..; \
	cd Fragmentation;                 make purge; cd ..; \
	cd GHEP;                          make purge; cd ..; \
	cd Geo;                           make purge; cd ..; \
	cd GiBUU;                         make purge; cd ..; \
	cd HadronTransport;               make purge; cd ..; \
	cd Interaction;                   make purge; cd ..; \
	cd LlewellynSmith;                make purge; cd ..; \
	cd MEC;	                          make purge; cd ..; \
	cd Messenger;	                  make purge; cd ..; \
	cd MuELoss;	                  make purge; cd ..; \
	cd Nuclear;                       make purge; cd ..; \
	cd Ntuple;                        make purge; cd ..; \
	cd NuGamma;                       make purge; cd ..; \
	cd NuE;                           make purge; cd ..; \
	cd Numerical;                     make purge; cd ..; \
	cd PartonModel;                   make purge; cd ..; \
	cd Paschos;                       make purge; cd ..; \
	cd PDF;                           make purge; cd ..; \
	cd PDG;                           make purge; cd ..; \
	cd QEL;                           make purge; cd ..; \
	cd RES;                           make purge; cd ..; \
	cd Registry;                      make purge; cd ..; \
	cd ReinSeghal;                    make purge; cd ..; \
	cd ReWeight;                      make purge; cd ..; \
	cd Utils;                         make purge; cd ..; \
	cd VLE;                           make purge; cd ..; \
	cd VHE;                           make purge; cd ..; \
	cd ValidationTools/NuVld;         make purge; cd ../../; \
	cd ValidationTools/NuVld/app;     make purge; cd ../../../; \
	cd ValidationTools/Basic;         make purge; cd ../../; \
	cd ValidationTools/CrossSections; make purge; cd ../../; \
	cd ValidationTools/Hadronization; make purge; cd ../../; \
	cd ValidationTools/Merenyi;       make purge; cd ../../; \
	cd Viewer;                        make purge; \
	cd ${GENIE}

clean: clean-files clean-dir clean-etc

clean-files: FORCE
	@echo " "
	@echo "** Cleaning..."
	cd ${GENIE}/src;\
	cd Algorithm;                     make clean; cd ..; \
	cd BaryonResonance;               make clean; cd ..; \
	cd Base;                          make clean; cd ..; \
	cd BodekYang;                     make clean; cd ..; \
	cd Charm;                         make clean; cd ..; \
	cd Coherent;                      make clean; cd ..; \
	cd CrossSections;                 make clean; cd ..; \
	cd Decay; 	                  make clean; cd ..; \
	cd Diffractive; 	          make clean; cd ..; \
	cd DIS;	 		          make clean; cd ..; \
	cd Elastic; 	                  make clean; cd ..; \
	cd ElFF; 	                  make clean; cd ..; \
	cd EVGCore;                       make clean; cd ..; \
	cd EVGModules;                    make clean; cd ..; \
	cd EVGDrivers;                    make clean; cd ..; \
	cd FluxDrivers;                   make clean; cd ..; \
	cd Fragmentation;                 make clean; cd ..; \
	cd GHEP;                          make clean; cd ..; \
	cd Geo;                           make clean; cd ..; \
	cd GiBUU;                         make clean; cd ..; \
	cd HadronTransport;               make clean; cd ..; \
	cd Interaction;                   make clean; cd ..; \
	cd LlewellynSmith;                make clean; cd ..; \
	cd MEC;                           make clean; cd ..; \
	cd Messenger;	                  make clean; cd ..; \
	cd MuELoss;	                  make clean; cd ..; \
	cd Nuclear;                       make clean; cd ..; \
	cd Ntuple;                        make clean; cd ..; \
	cd NuGamma;                       make clean; cd ..; \
	cd NuE;                           make clean; cd ..; \
	cd Numerical;                     make clean; cd ..; \
	cd PartonModel;                   make clean; cd ..; \
	cd Paschos;                       make clean; cd ..; \
	cd PDF;                           make clean; cd ..; \
	cd PDG;                           make clean; cd ..; \
	cd QEL;                           make clean; cd ..; \
	cd RES;                           make clean; cd ..; \
	cd Registry;                      make clean; cd ..; \
	cd ReinSeghal;                    make clean; cd ..; \
	cd ReWeight;                      make clean; cd ..; \
	cd Utils;                         make clean; cd ..; \
	cd ValidationTools/NuVld;         make clean; cd ../../; \
	cd ValidationTools/NuVld/app;     make clean; cd ../../../; \
	cd ValidationTools/Basic;         make clean; cd ../../; \
	cd ValidationTools/CrossSections; make clean; cd ../../; \
	cd ValidationTools/Hadronization; make clean; cd ../../; \
	cd ValidationTools/Merenyi;       make clean; cd ../../; \
	cd Viewer;                        make clean; cd ..; \
	cd VLE;                           make clean; cd ..; \
	cd VHE;                           make clean; cd ..; \
	cd stdapp;                        make clean; cd ..; \
	cd support/minos/EventServer/;    make clean; cd ../../../; \
	cd support/t2k/EvGen/;            make clean; cd ../../../; \
	cd support/t2k/SKNorm/;           make clean; cd ../../../; \
	cd test;                          make clean; cd ..; \
	cd scripts;	                  make clean; \
	cd ${GENIE}

clean-dir: FORCE
	@echo "Deleting GENIE lib and bin directories...";\
	cd $(GENIE);\
	[ ! -d ./bin ] || rmdir ./bin;\
	[ ! -d ./lib ] || rmdir ./lib 

clean-etc: FORCE
	cd $(GENIE); \
	rm -f ./*log; \
	cd ${GENIE}

distclean: FORCE
	@echo " "
	@echo "** Cleaning GENIE installation... "
	[ ! -d ${GENIE_INSTALLATION_PATH}/include/GENIE ] || rm -rf ${GENIE_INSTALLATION_PATH}/include/GENIE/
	cd ${GENIE}/src/;\
	cd Algorithm;                      make distclean; cd ..; \
	cd BaryonResonance;                make distclean; cd ..; \
	cd Base;                           make distclean; cd ..; \
	cd BodekYang;                      make distclean; cd ..; \
	cd Charm;                          make distclean; cd ..; \
	cd Coherent;                       make distclean; cd ..; \
	cd CrossSections;                  make distclean; cd ..; \
	cd Decay; 	                   make distclean; cd ..; \
	cd Diffractive; 	           make distclean; cd ..; \
	cd DIS;		 	           make distclean; cd ..; \
	cd Elastic; 	                   make distclean; cd ..; \
	cd ElFF; 	                   make distclean; cd ..; \
	cd EVGCore;                        make distclean; cd ..; \
	cd EVGModules;                     make distclean; cd ..; \
	cd EVGDrivers;                     make distclean; cd ..; \
	cd FluxDrivers;                    make distclean; cd ..; \
	cd Fragmentation;                  make distclean; cd ..; \
	cd GHEP;                           make distclean; cd ..; \
	cd Geo;                            make distclean; cd ..; \
	cd GiBUU;                          make distclean; cd ..; \
	cd HadronTransport;                make distclean; cd ..; \
	cd Interaction;                    make distclean; cd ..; \
	cd LlewellynSmith;                 make distclean; cd ..; \
	cd MEC;                            make distclean; cd ..; \
	cd Messenger;	                   make distclean; cd ..; \
	cd MuELoss;	                   make distclean; cd ..; \
	cd Nuclear;                        make distclean; cd ..; \
	cd Ntuple;                         make distclean; cd ..; \
	cd NuGamma;                        make distclean; cd ..; \
	cd NuE;                            make distclean; cd ..; \
	cd Numerical;                      make distclean; cd ..; \
	cd PartonModel;                    make distclean; cd ..; \
	cd Paschos;                        make distclean; cd ..; \
	cd PDF;                            make distclean; cd ..; \
	cd PDG;                            make distclean; cd ..; \
	cd QEL;                            make distclean; cd ..; \
	cd RES;                            make distclean; cd ..; \
	cd Registry;                       make distclean; cd ..; \
	cd ReinSeghal;                     make distclean; cd ..; \
	cd ReWeight;                       make distclean; cd ..; \
	cd Utils;                          make distclean; cd ..; \
	cd ValidationTools/NuVld;          make distclean; cd ../../; \
	cd ValidationTools/NuVld/app;      make distclean; cd ../../../; \
	cd ValidationTools/Basic;          make distclean; cd ../../; \
	cd ValidationTools/CrossSections;  make distclean; cd ../../; \
	cd ValidationTools/Hadronization;  make distclean; cd ../../; \
	cd ValidationTools/Merenyi;        make distclean; cd ../../; \
	cd Viewer;                         make distclean; cd ..; \
	cd VLE;                            make distclean; cd ..; \
	cd VHE;                            make distclean; cd ..; \
	cd stdapp;                         make distclean; cd ..; \
	cd support/minos/EventServer/;     make distclean; cd ../../../; \
	cd support/t2k/EvGen/;             make distclean; cd ../../../; \
	cd support/t2k/SKNorm/;            make distclean; cd ../../../; \
	cd test;                           make distclean; cd ..; \
	cd scripts;	                   make distclean; \
	cd ${GENIE}

FORCE:

