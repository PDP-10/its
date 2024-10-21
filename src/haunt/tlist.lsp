(SETQ MUM-ATN
      '((5. |tense| |flaming| |mumbling| |awesome| |foo| )
	(4. |mumble| |action| |baz| |nanos|)))

(SETQ GHOST-ATN
      '(|although | (15.
                     |wasted|
                     |strung out|
                     |soused|
                     |drunk|
                     |bombed|
                     |plastered|
                     |intoxicated|
                     |inebriated|
                     |temulent|
                     |inebrious|
                     |crapulous|
                     |sozzled|
                     |polluted|
                     |potted|
                     |ripped|)
                    |, the |
                    (9.
                     |fiend|
                     |poltergeist|
                     |apparition|
                     |spirit|
                     |ghost|
                     |spook|
                     |ghoul|
                     |spectre|
                     |wraith|)
                    | |
                    (8. |halts| |hinders| |prevents| |stops| |blocks| |stymies| |arrests| |stays|)
                    | your attempt to|))

(SETQ BAD-INPUT-ATN
      '((13.
         |that's a bit over my head.|
         |no way buster.|
         |try something different.|
         |ich verstehe nicht.|
         |yo no comprendo.|
         |I don't grok that.|
         |was that in Greek?|
         |that's easy for you to say.|
         |that does not compute.|
         |try something else.|
         |stop mumbling.|
         |I don't understand that.|
         |huh?|)))

(SETQ BAD-DIRECTION-ATN
      '((5.
         |watch where you're going!|
         |that direction is blocked.|
         |ain't no way you gonna go that way.|
         |try another direction.|
         |not that way, you don't.|)))

(SETQ NO-INPUT-ATN
      '((7.
         |insufficient data.|
         |I didn't hear you.|
         |speak up!|
         |that's easy for you not to say.|
         |don't try the silent treatment on me.|
         |come on, lets do something.|
         |talk! I need some attention.|)))

(SETQ HELP-ATN
      '((8.
         |I don't feel like helping you|
         |you don't deserve any help|
         |first you have to prove you're worth it|
         |so the big bad ghost hunter needs help|
         |what have you ever done for me|
         |you got yourself into this mess|
         |I'm not the Salvation Army|
         |help yourself|)
        |, you |
        (18.
         |filthy|
         |disgusting|
         |vile|
         |stupid|
         |lousy|
         |rotten|
         |half-wit|
         |incompetent|
         |back-biting|
         |dim-witted|
         |moronic|
         |degenerate|
         |hard-core|
         |flea-bitten|
         |poor excuse for a|
         |nano-brain|
         |sexually depraved|
         |dirty|)
        | |
        (24.
         |nerd|
         |rutabaga|
         |tuna|
         |nauga|
         |armadillo|
         |penguin|
         |camel|
         |moose|
         |turkey|
         |aardvark|
         |flamer|
         |asshole|
         |jerk|
         |heathen|
         |skunk|
         |vermin|
         |hacker|
         |cretin|
         |NIL hacker|
         |cockroach|
         |insect|
         |hacker|
         |Pennsylvanian|
         |Pittsburgher|)))

(SETQ HAVE-ATN '((3. |you now own| |you just got| |you now have|)))

(SETQ HOMER-ATN
      '((4.
         |think!|
         |keep trying, something might work.|
         |nothing happens.|
         |the bust stays as it is.|)))

(SETQ NOTCLOSED-ATN
      '((4.
         |if there is a secret panel near-by, this is not the way to open it.|
         |you need to have your eyes examined.|
         |I don't see anything closed.|
         |there is nothing that is closed.|)))
