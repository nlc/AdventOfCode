btd =: cutopen each (LF , LF) splitstring (1!:1) < 'input.txt' NB. Boxed Tile Data

eb =: (],|."1)@(({.,:{:),({.,:{:)@|:) NB. Edge Bitstrings
pl =: 3 : 0 NB. Process Line
  tts =. > {. y NB. Tile Title String
  tid =. ". > {: ': ' cutopen tts NB. Tile ID
  trs =. > }. y NB. Tile Rows String
  tbd =. '.#' i. trs NB. Tile Binary Data
  ten =. #. eb tbd NB. Tile Edge Numbers

  tid ; tbd ; ten
)

data =: pl each btd
