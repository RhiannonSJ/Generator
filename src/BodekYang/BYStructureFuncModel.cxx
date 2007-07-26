//____________________________________________________________________________
/*
 Copyright (c) 2003-2007, GENIE Neutrino MC Generator Collaboration
 For the full text of the license visit http://copyright.genie-mc.org
 or see $GENIE/LICENSE

 Author: Costas Andreopoulos <C.V.Andreopoulos@rl.ac.uk>
         STFC, Rutherford Appleton Laboratory - October 03, 2004

 For the class documentation see the corresponding header file.

 Important revisions after version 2.0.0 :

*/
//____________________________________________________________________________

#include <TMath.h>

#include "Algorithm/AlgFactory.h"
#include "Algorithm/AlgConfigPool.h"
#include "BodekYang/BYStructureFuncModel.h"
#include "Conventions/Constants.h"
#include "Messenger/Messenger.h"

using namespace genie;
using namespace genie::constants;

//____________________________________________________________________________
BYStructureFuncModel::BYStructureFuncModel(string name) :
DISStructureFuncModel(name)
{
  this->Init();
}
//____________________________________________________________________________
BYStructureFuncModel::BYStructureFuncModel(string name, string config):
DISStructureFuncModel(name, config)
{
  this->Init();
}
//____________________________________________________________________________
BYStructureFuncModel::~BYStructureFuncModel()
{

}
//____________________________________________________________________________
void BYStructureFuncModel::Configure(const Registry & config)
{
// Overload Algorithm::Configure() to read the config. registry and set
// private data members.
// DISStructureFuncModel::Configure() creates the owned PDF object that gets
// configured with the specified PDFModelI
// For the ReadBYParams() method see below

  DISStructureFuncModel::Configure(config);
  this->ReadBYParams();
}
//____________________________________________________________________________
void BYStructureFuncModel::Configure(string param_set)
{
  DISStructureFuncModel::Configure(param_set);
  this->ReadBYParams();
}
//____________________________________________________________________________
void BYStructureFuncModel::ReadBYParams(void)
{
// Get the Bodek-Yang model parameters A,B,Csea,Cv1,Cv2 from the config.
// registry and set some private data members so as not to accessing the
// registry at every calculation.
//
  AlgConfigPool * confp = AlgConfigPool::Instance();
  const Registry * gc = confp->GlobalParameterList();

  fA    = fConfig->GetDoubleDef( "A",    gc->GetDouble("BY-A")    );
  fB    = fConfig->GetDoubleDef( "B",    gc->GetDouble("BY-B")    );
  fCsU  = fConfig->GetDoubleDef( "CsU",  gc->GetDouble("BY-CsU")  );
  fCsD  = fConfig->GetDoubleDef( "CsD",  gc->GetDouble("BY-CsD")  );
  fCv1U = fConfig->GetDoubleDef( "Cv1U", gc->GetDouble("BY-Cv1U") );
  fCv2U = fConfig->GetDoubleDef( "Cv2U", gc->GetDouble("BY-Cv2U") );
  fCv1D = fConfig->GetDoubleDef( "Cv1D", gc->GetDouble("BY-Cv1D") );
  fCv2D = fConfig->GetDoubleDef( "Cv2D", gc->GetDouble("BY-Cv2D") );
}
//____________________________________________________________________________
void BYStructureFuncModel::Init(void)
{
  fA    = 0;
  fB    = 0;
  fCsU  = 0;
  fCsD  = 0;
  fCv1U = 0;
  fCv2U = 0;
  fCv1D = 0;
  fCv2D = 0;
}
//____________________________________________________________________________
double BYStructureFuncModel::ScalingVar(const Interaction * interaction) const
{
// Overrides DISStructureFuncModel::ScalingVar() to compute the BY scaling var

  const Kinematics & kine  = interaction->Kine();
  double x  = kine.x();
  double Q2 = this->Q2(interaction);
  //Q2 = TMath::Max(Q2,fQ2min);
  LOG("BodekYang", pDEBUG) << "Q2 at scaling var calculation = " << Q2;

  double a  = TMath::Power( 2*kProtonMass*x, 2 ) / Q2;
  double xw =  2*x*(Q2+fB) / (Q2*(1.+TMath::Sqrt(1+a)) +  2*fA*x);
  return xw;
}
//____________________________________________________________________________
void BYStructureFuncModel::KFactors(const Interaction * interaction, 
	         double & kuv, double & kdv, double & kus, double & kds) const
{
// Overrides DISStructureFuncModel::KFactors() to compute the BY K factors for
// u(valence), d(valence), u(sea), d(sea);

  double Q2  = this->Q2(interaction);
  double GD  = 1. / TMath::Power(1.+Q2/0.71, 2); // p elastic form factor
  double GD2 = TMath::Power(GD,2);

  kuv = (1.-GD2)*(Q2+fCv2U)/(Q2+fCv1U); // K - u(valence)
  kdv = (1.-GD2)*(Q2+fCv2D)/(Q2+fCv1D); // K - d(valence)
  kus = Q2/(Q2+fCsU);                   // K - u(sea)
  kds = Q2/(Q2+fCsD);                   // K - d(sea)
}
//____________________________________________________________________________
