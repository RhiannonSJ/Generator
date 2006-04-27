//____________________________________________________________________________
/*!

\namespace  genie::utils::clap

\brief      Simple utility methods for Command Line Argument Parsing in GENIE
            standalone applications

\author     Costas Andreopoulos <C.V.Andreopoulos@rl.ac.uk>
            CCLRC, Rutherford Appleton Laboratory

\created    October 3, 2005

\cpright    Copyright (c) 2003-2006, GENIE Neutrino MC Generator Collaboration
            All rights reserved.
            For the licensing terms see $GENIE/USER_LICENSE.
*/
//____________________________________________________________________________

#ifndef _CLAP_UTILS_H_
#define _CLAP_UTILS_H_

#include <string>

using std::string;

namespace genie {
namespace utils {

namespace clap
{
  string CmdLineArgAsString (int argc, char ** argv, char opt);
  double CmdLineArgAsDouble (int argc, char ** argv, char opt);
  int    CmdLineArgAsInt    (int argc, char ** argv, char opt);
  bool   CmdLineArgAsBool   (int argc, char ** argv, char opt);
  char * CmdLineArg         (int argc, char ** argv, char opt);

}      // clap  namespace

}      // utils namespace
}      // genie namespace

#endif // _CLAP_UTILS_H_
