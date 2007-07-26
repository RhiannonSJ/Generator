//____________________________________________________________________________
/*!

\class   genie::GMCJDriver

\brief   GENIE MC Job Driver (event generation for the input flux & geometry)

\author  Costas Andreopoulos <C.V.Andreopoulos@rl.ac.uk>
         STFC, Rutherford Appleton Laboratory

\created May 25, 2005

\cpright  Copyright (c) 2003-2007, GENIE Neutrino MC Generator Collaboration
          For the full text of the license visit http://copyright.genie-mc.org
          or see $GENIE/LICENSE
*/
//____________________________________________________________________________

#ifndef _GENIE_MC_JOB_DRIVER_H_
#define _GENIE_MC_JOB_DRIVER_H_

#include <string>

#include <TBits.h>

#include "EVGDrivers/PathLengthList.h"
#include "PDG/PDGCodeList.h"

using std::string;

namespace genie {

class EventRecord;
class GFluxI;
class GeomAnalyzerI;
class GENIE;
class GEVGPool;

class GMCJDriver {

public :

  GMCJDriver();
  ~GMCJDriver();

  //-- configure MC job
  void UseFluxDriver      (GFluxI * flux);
  void UseGeomAnalyzer    (GeomAnalyzerI * geom);
  void UseSplines         (bool useLogE = true);
  void UseMaxPathLengths  (string xml_filename);
  void AllowRecursiveMode (bool allow);
  void FilterUnphysical   (const TBits & unphysmask);
  void Configure          (void);

  //-- generate single neutrino event for input flux & geometry
  EventRecord * GenerateEvent (void);

private:

  void   Initialize              (void);
  void   InitEventGeneration     (void);
  void   GetParticleLists        (void);
  void   GetMaxPathLengthList    (void);
  void   GetMaxFluxEnergy        (void);
  void   CreateGEVGDriverPool    (void);
  void   CreateXSecSplines       (void);
  void   CreateXSecSumSplines    (void);
  void   ComputeMaxIntProb       (void);
  bool   GenerateFluxNeutrino    (void);
  bool   ComputePathLengths      (void);
  int    SelectTargetMaterial    (void);
  void   GenerateEventKinematics (void);
  void   GenerateVertex          (void);
  void   ComputeEventProbability (void);

  double PInt(double xsec, double pl, int A);

  GFluxI *        fFluxDriver;       ///< [input] neutrino flux driver
  GeomAnalyzerI * fGeomAnalyzer;     ///< [input] detector geometry analyzer
  GEVGPool *      fGPool;            ///< A pool of available GEVGDrivers objects
  PDGCodeList     fNuList;           ///< list of neutrino codes [taken from flux driver]
  PDGCodeList     fTgtList;          ///< list of target codes [taken from geom driver]
  PathLengthList  fMaxPathLengths;   ///< maximum path length list [for all geometry materials]
  PathLengthList  fCurPathLengths;   ///< path length list for current flux neutrino
  TLorentzVector  fCurVtx;           ///< current interaction vertex
  EventRecord *   fCurEvt;           ///< current generated event
  int             fSelTgtPdg;        ///< selected target material PDG code
  double          fEmax;             ///< maximum neutrino energy [taken from flux driver]
  double          fPmax;             ///< [computed] Pmax(interaction)|<flux/geom>
  string          fMaxPlXmlFilename; ///< [input/opt] max path lengths, all materials|geom
  bool            fUseExtMaxPl;      ///< using external max path length estimate?
  bool            fUseSplines;       ///< compute all needed & not-loaded splines at init
  bool            fUseLogE;          ///< build splines = f(logE) (rather than f(E)) ?
  bool            fAllowRecursMode;  ///< can enter into recursive mode?
  TBits           fUnphysMask;       ///< unphysical events filtering mask
  double          fNFluxNeutrinos;   
};

}      // genie namespace

#endif // _GENIE_MC_JOB_DRIVER_H_
