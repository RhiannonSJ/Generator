//____________________________________________________________________________
/*
 Copyright (c) 2003-2007, GENIE Neutrino MC Generator Collaboration
 For the full text of the license visit http://copyright.genie-mc.org
 or see $GENIE/LICENSE

 Author: Costas Andreopoulos <C.V.Andreopoulos@rl.ac.uk>
         STFC, Rutherford Appleton Laboratory - September 27, 2005

 For the class documentation see the corresponding header file.

 Important revisions after version 2.0.0 :

*/
//____________________________________________________________________________

#include "EVGCore/EVGThreadException.h"
#include "Messenger/Messenger.h"

using std::endl;
using namespace genie::exceptions;

//___________________________________________________________________________
namespace genie {
 namespace exceptions {
  ostream & operator<< (ostream& stream, const EVGThreadException & exc)
  {
   exc.Print(stream);
   return stream;
  }
 }
}
//___________________________________________________________________________
EVGThreadException::EVGThreadException()
{
  this->Init();
}
//___________________________________________________________________________
EVGThreadException::EVGThreadException(const EVGThreadException & exc)
{
  this->Copy(exc);
}
//___________________________________________________________________________
EVGThreadException::~EVGThreadException()
{

}
//___________________________________________________________________________
void EVGThreadException::Init(void)
{
  fReason     = "";
  fFastFwd    = false;
  fStepBack   = false;
  fReturnStep = 999999;
}
//___________________________________________________________________________
void EVGThreadException::Copy(const EVGThreadException & exc)
{
  fReason     = exc.fReason;
  fFastFwd    = exc.fFastFwd;
  fStepBack   = exc.fStepBack;
  fReturnStep = exc.fReturnStep;
}
//___________________________________________________________________________
void EVGThreadException::Print(ostream & stream) const
{
  stream << "**EXCEPTION Reason: " << this->ShowReason() << endl;
}
//___________________________________________________________________________
