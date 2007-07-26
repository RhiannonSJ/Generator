//____________________________________________________________________________
/*
 Copyright (c) 2003-2007, GENIE Neutrino MC Generator Collaboration
 For the full text of the license visit http://copyright.genie-mc.org
 or see $GENIE/LICENSE

 Author: Costas Andreopoulos <C.V.Andreopoulos@rl.ac.uk>
         STFC, Rutherford Appleton Laboratory - May 03, 2004

 For the class documentation see the corresponding header file.

 Important revisions after version 2.0.0 :

*/
//____________________________________________________________________________

#include <TMath.h>

#include "Algorithm/AlgConfigPool.h"
#include "Base/ELFormFactors.h"
#include "Base/ELFormFactorsModelI.h"
#include "Conventions/Constants.h"
#include "LlewellynSmith/LlewellynSmithModel.h"
#include "Messenger/Messenger.h"

using namespace genie;
using namespace genie::constants;

//____________________________________________________________________________
LlewellynSmithModel::LlewellynSmithModel() :
QELFormFactorsModelI()
{

}
//____________________________________________________________________________
LlewellynSmithModel::LlewellynSmithModel(string name) :
QELFormFactorsModelI(name)
{

}
//____________________________________________________________________________
LlewellynSmithModel::LlewellynSmithModel(string name, string config) :
QELFormFactorsModelI(name, config)
{

}
//____________________________________________________________________________
LlewellynSmithModel::~LlewellynSmithModel()
{

}
//____________________________________________________________________________
double LlewellynSmithModel::F1V(const Interaction * interaction) const
{
  double t   = this->tau(interaction);
  double gve = this->GVE(interaction);
  double gvm = this->GVM(interaction);

  double F1V = (gve - t*gvm) / (1-t);
  return F1V;
}
//____________________________________________________________________________
double LlewellynSmithModel::xiF2V(const Interaction * interaction) const
{
  double t   = this->tau(interaction);
  double gve = this->GVE(interaction);
  double gvm = this->GVM(interaction);

  double xiF2V = (gvm-gve) / (1-t);
  return xiF2V;
}
//____________________________________________________________________________
double LlewellynSmithModel::FA(const Interaction * interaction) const
{
  // get scattering parameters
  const Kinematics & kine = interaction->Kine();
  double q2 = kine.q2();

  // calculate FA(q2)
  double dn = TMath::Power(1.-q2/fMa2, 2);
  double FA = fFA0/dn;
  return FA;
}
//____________________________________________________________________________
double LlewellynSmithModel::Fp(const Interaction * interaction) const
{
  // get momentum transfer
  const Kinematics & kine = interaction->Kine();
  double q2 = kine.q2();

  // get struck nucleon mass & set pion mass
  const InitialState & init_state = interaction->InitState();
  double MN   = init_state.Tgt().HitNucMass();
  double MN2  = TMath::Power(MN, 2);
  double Mpi  = kPionMass;
  double Mpi2 = TMath::Power(Mpi, 2);

  // calculate FA
  double fa = this->FA(interaction);

  // calculate Fp
  double Fp = 2. * MN2 * fa/(Mpi2-q2);
  return Fp;
}
//____________________________________________________________________________
void LlewellynSmithModel::Configure(const Registry & config)
{
  Algorithm::Configure(config);
  this->LoadConfig();
}
//____________________________________________________________________________
void LlewellynSmithModel::Configure(string config)
{
  Algorithm::Configure(config);
  this->LoadConfig();
}
//____________________________________________________________________________
void LlewellynSmithModel::LoadConfig(void)
{
// Load configuration data from its configuration Registry (or global defaults)
// to private data members
	
  fElFFModel = 0;

  AlgConfigPool * confp = AlgConfigPool::Instance();
  const Registry * gc = confp->GlobalParameterList();

  // load elastic form factors model
  RgAlg form_factors_model = fConfig->GetAlgDef(
                 "ElasticFormFactorsModel", gc->GetAlg("ElasticFormFactorsModel"));
  fElFFModel =  dynamic_cast<const ELFormFactorsModelI *> (
                                          this->SubAlg("ElasticFormFactorsModel"));
  assert(fElFFModel);

  fELFF.SetModel(fElFFModel);  

  // axial mass and Fa(q2=0)
  fMa  = fConfig->GetDoubleDef("Ma",  gc->GetDouble("QEL-Ma"));  // Axial mass
  fFA0 = fConfig->GetDoubleDef("FA0", gc->GetDouble("QEL-FA0")); // FA(q2=0)

  fMa2 = TMath::Power(fMa,2);

  // anomalous magnetic moments
  fMuP = fConfig->GetDoubleDef("MuP", gc->GetDouble("AnomMagnMoment-P"));
  fMuN = fConfig->GetDoubleDef("MuN", gc->GetDouble("AnomMagnMoment-N"));

  // weinberg angle
  double thw = fConfig->GetDoubleDef(
                          "WeinbergAngle", gc->GetDouble("WeinbergAngle"));
  fSin28w = TMath::Power(TMath::Sin(thw), 2);
}
//____________________________________________________________________________
double LlewellynSmithModel::tau(const Interaction * interaction) const
{
// computes q^2 / (4 * MNucl^2)

  //-- get kinematics & initial state parameters
  const Kinematics &   kinematics = interaction->Kine();
  const InitialState & init_state = interaction->InitState();
  double q2     = kinematics.q2();
  double Mnucl  = init_state.Tgt().HitNucMass();
  double Mnucl2 = TMath::Power(Mnucl, 2);

  //-- calculate q^2 / (4*Mnuc^2)
  return q2/(4*Mnucl2);
}
//____________________________________________________________________________
double LlewellynSmithModel::GVE(const Interaction * interaction) const
{
  //-- compute GVE using CVC

  fELFF.Calculate(interaction);
  double gve = fELFF.Gep() - fELFF.Gen();
  return gve;
}
//____________________________________________________________________________
double LlewellynSmithModel::GVM(const Interaction * interaction) const
{
  //-- compute GVM using CVC

  fELFF.Calculate(interaction);
  double gvm = fELFF.Gmp() - fELFF.Gmn();
  return gvm;
}
//____________________________________________________________________________

