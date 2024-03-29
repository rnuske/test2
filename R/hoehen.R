#===============================================================================
#
#  Wrapper Funktion für Bestandeshöhen
#
#  greift auf die funktionalisierte und klassische Variante zurück
#
#===============================================================================


#' Bestandeshöhen in Abhängigkeit von Baumart, Bonität und Alter
#'
#' Für eine gegebene Baumart, Bonität und Alter wird die Bestandeshöhe als
#' Mittel- oder Oberhöhe bestimmt. Die Mittelhöhe Hg entspricht der Höhe des
#' Grundflächenmittelstamms aller Bäume und die Oberhöhe H100 der Höhe des
#' Grundflächenmittelstamms der 100 durchmesserstärksten Bäume je Hektar. Die
#' Berechnung erfolgt entweder über einen funktionalisierten Bonitätsfächer oder
#' über Inter-/Extrapolation der Ertragstafeln mittels Dreisatz.
#'
#' Die Bestimmung der Bestandeshöhe über die funktionalisierten Bonitätsfächer
#' basiert auf nichtlinearen Modellen, die durch Anpassung an die Ober- und
#' Mittelhöhen über dem Alter bei mäßiger Durchforstung bzw. für
#' Eichen-Oberhöhen bei starker Durchforstung aus der Ertragstafelsammlung von
#' Schober (1995) entstanden. Für die Kiefer wurde hierbei die
#' Chapman-Richards-Funktion (Richards 1959) und für alle anderen Baumarten die
#' Wachstumsfunktion von Sloboda (1971) genutzt. Die Bestandeshöhen der neuen
#' Ertragstafeln (Albert et al. 2021) sind die tabellarisierten Werte eben
#' dieser funktionalisierten Bonitätsfächer.
#'
#' Der entscheidende Vorteil der Bonitätsfächermodelle gegenüber dem klassischen
#' Verfahren der linearen Extrapolation liegt darin, dass sie auch über den
#' Bonitäts- und Altersrahmen der Ertragstafeln hinaus robuste und biologisch
#' plausible Bestandeshöhen liefern. Daher unterscheiden sich die mit der
#' Methode `"funktional"` ermittelten Bonitäten von den der Methode `"klassisch"`
#' v.a. im Extrapolationsbereich der Ertragstafeln, d.h. bei
#' Alter-Bestandeshöhen-Kombination, die durch die Ertragstafeln nicht abgedeckt
#' sind.
#'
#' Für alle Baumarten außer Eiche werden bei hoss=TRUE, als Alternative zu den
#' oben beschriebenen Standardmodellen, Oberhöhen-Verläufe zugrunde gelegt, die
#' auf der Anpassung der Hossfeld IV-Funktion (Hossfeld 1822) beruhen. Diese
#' kann für die Bonitierung sehr junger Buchen-, Fichten- und
#' Douglasien-Bestände (< 15 Jahre) geeigneter sein, da in dem hier
#' standardmäßig genutzten Sloboda-Modell die Höhenwerte in diesem Altersbereich
#' unplausibel langsam ansteigen. Im Gegensatz zum Standardmodell werden die in
#' den Ertragstafeln angegebenen Oberhöhen mit dem Hossfeld-Modell nicht exakt
#' reproduziert.
#'
#' @param art Baumartenbezeichnung entweder als Kürzel, deutscher Name,
#'   lateinischer Name oder in niedersächsischer Kodierung.
#'   Für vorhandene Arten siehe [et_liste()].
#' @param alter Bestandesalter in Jahren. Bei Methode `klassisch` zwischen 5
#'   und max. zulässigem Alter (Ei 220, Bu 180 und Fi, Dgl, Ki 160).
#' @param bon Bonität als Zahlwert. Zulässig sind relative Ertragsklassen im
#'   Interval \[-2,4\] bzw. \[-3,7\] bei Methode `"klassisch"` bzw.
#'   `"funktional"` und absolute Bonitäten entsprechend. Welche Art der Bonität
#'   hier übergeben wird bestimmt der Parameter `bon_typ`.
#' @param bon_typ Die Bonität kann als relative Ertragsklasse (`"relativ"`) oder
#'   absolute Oberhöhenbonität (H100 im Alter 100, `"absolut"`) angegeben werden.
#'   Parameter kann gekürzt werden, solange er eindeutig bleibt.
#' @param hoehe_typ Ausgabe der Bestandeshöhe erfolgt als Mittelhöhe (Höhe des
#'   Grundflächenmittelstamms, `"mittel"`) oder als Oberhöhe (Höhe des
#'   Grundflächenmittelstamms der 100 durchmesserstärksten Bäume je Hektar,
#'   `"ober"`). Parameter kann gekürzt werden, solange er eindeutig bleibt.
#' @param methode Die Berechnung erfolgt über funktionalisierte Bonitätsfächer
#'   (`"funktional"`) oder über Inter-/Extrapolation der Ertragstafelwerte
#'   mittels Dreisatz (`"klassisch"`). Parameter kann gekürzt werden, solange er
#'   eindeutig bleibt.
#' @param ... Weitere Parameter, wie z.B. für funkt. Bonitätsfächermodell auf
#'   Basis der Hossfeld-Funktion (s. Details).
#'
#' @return Numerischer Vektor mit Bestandeshöhen in Meter. Für Werte außerhalb
#'   des zulässigen Alters- und Bonitätsintervalls wird `NA` ausgegeben.
#'   Die klassische Methode kann für sehr junge Alter und schlechte Bonitäten
#'   zu negativen Bestandeshöhen führen, dann wird ebenfalls `NA` ausgegeben.
#'
#' @author Robert Nuske (klassisch), Kai Staupendahl (funktional)
#'
#' @seealso [et_bonitaet] zur Bonitierung, [et_tafel()] zur Ermittlung von
#'   Ertragstafelwerte und [et_bontrans()] zur Umrechnung von Ertragsklasse
#'   in Site Index und vice versa.
#'
#' @references
#' Albert M., Nagel J., Schmidt M., Nagel R.-V., Spellmann H. (2021): Eine neue
#'   Generation von Ertragstafeln für Eiche, Buche, Fichte, Douglasie und Kiefer
#'   \[Datensatz\]. Version 1.0. Zenodo. https://doi.org/10.5281/zenodo.6343906
#'
#' Hossfeld J.W. (1822): Mathematik für Forstmänner, Ökonomen und Cameralisten.
#'   Bd. 4, Gotha
#'
#' Richards F.J. (1959): A flexible growth function for empirical use.
#'   Journal of Experimental Botany (10) 2: 290-301.
#'
#' Schober R. (1995): Ertragstafeln wichtiger Baumarten. 4. Aufl., J. D.
#'   Sauerländer’s Verlag, Frankfurt a.M., 166 S.
#'
#' Sloboda B. (1971): Darstellung von Wachstumsprozessen mit Hilfe von
#'   Differentialgleichungen erster Ordnung. Mitt. d. Baden-Württembergischen
#'   Forstl. Versuchs- und Forschungsanstalt, Heft 32, Freiburg, 109 S.
#'
#' @export
#'
#' @examples
#' et_hoehe('bu', alter=75, bon=1.25, hoehe_typ="mittel")
#' et_hoehe('bu', alter=75, bon=1.25, hoehe_typ="mittel", methode="klassisch")
#'
#' et_hoehe('bu', alter=75, bon=29, bon_typ="absolut", hoehe_typ="mittel")
#' et_hoehe('bu', alter=75, bon=29, bon_typ="absolut", hoehe_typ="ober")
#'
#' arten <- c("fi", "fi", "bu", "dgl")
#' si <- c(34.5, 29.3, 36, 40)
#' et_hoehe(art=arten, alter=80, bon=si, bon_typ="absolut", hoehe_typ="ober")
#'
#' et_hoehe(art="Kiefer", alter=seq(20, 160, by=20), bon=1.5, bon_typ="rel",
#'          hoehe_typ="ober", hoss=TRUE)

et_hoehe <- function(art, alter, bon, bon_typ="relativ",
                      hoehe_typ="ober", methode="funktional", ...) {

  if(missing(art) | missing(alter) | missing(bon))
    stop("art, alter und bon m\u00fcssen angegeben werden.")
  if(!is.numeric(bon) || !is.numeric(alter))
    stop("bon und alter m\u00fcssen numerisch sein.")
  bon_typ <- match.arg(bon_typ, c("relativ", "absolut"))
  hoehe_typ <- match.arg(hoehe_typ, c("mittel", "ober"))
  methode <- match.arg(methode, c("funktional", "klassisch"))

  if(methode == "funktional"){

    if(hoehe_typ == "mittel"){
      h <- funk_hg(art, alter, bon,
                   bon_als_ekl=isTRUE(bon_typ == "relativ"))
    } else { # ober

      # behandle dot-dot-dot auf der Suche nach hoss
      if(...length()){
        if(n <- match("hoss", ...names(), nomatch=0)){
          hoss <- ...elt(n)
          if(!is.logical(hoss)) stop("hoss ist nicht Boolean.")
        } else { stop("Unbekannte Parameter in ... \u00fcbergeben.") }
      } else { hoss <- FALSE }

      h <- funk_h100(art, alter, bon,
                     bon_als_ekl=isTRUE(bon_typ == "relativ"), hoss)
    }
  } else { # klassisch
    h <- klas_hoehe(art, alter, bon, bon_typ, hoehe_typ)
  }
  return(round(h, 1))
}
