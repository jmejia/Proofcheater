##Proofcheater
A simple command line app designed to automate proof sheet generation
for photoshoots.

Images are renamed and organized following a consistent nomenclature.
Corresponding proof sheets (contact sheets) are generated as PDFs using Prawn.
The end result is very specific to my needs but provides an interesting
use of Prawn. Proofs are only available as 3x3 grid.


###Requirements
- Ruby 1.9 
- Prawn
- Imagemagick
- Shoulda for tests
- Built for Mac OS X


How to Use:
1. Run ruby -I lib bin/proofcheater
2. Follow prompt within the terminal.

###TO DO
- Write tests for batch.rb
