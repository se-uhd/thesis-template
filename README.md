[![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

# Thesis Template SE@UHD

This template can be used for theses and seminar reports written in the Software Engineering Group at Heidelberg University.
Students are free to modify the template or use a different template.
However, they need to consider the formatting requirements for [bachelor's](https://www.informatik.uni-heidelberg.de/studium/bachelor/bsc-arbeit) and [master's](https://www.informatik.uni-heidelberg.de/studium/master/msc-thesis) theses.

## Seminar Reports

To use the template for a seminar report, run the following script once in the root directory of your copy of the template (on Windows, use Git Bash or WSL):

```bash
./convert-to-seminar-report.sh
```

The script changes `thesis.tex` as follows:

* Sets the document type on the cover page to "Seminar Report".
* Switches to a one-sided layout.
* Removes the German abstract ("Zusammenfassung") and the acknowledgments.
* Adapts the Declaration of Originality ("Eigenständigkeitserklärung") to seminar reports.
* Replaces the thesis chapters with the [outline for seminar reports](https://se-uhd.de/theses/q+a#is-there-a-reportthesis-template).

The script relies on the `% seminar-report` comments in `thesis.tex`, so run it before you edit that file.
The chapters are a starting point.
Adjust them to your topic and discuss the outline with your supervisor.

Pull requests with updates and fixes for this template are appreciated!

To get access to example theses written using this template, please reach out to [Prof. Dr. Sebastian Baltes](https://se-uhd.de/people/).

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg
