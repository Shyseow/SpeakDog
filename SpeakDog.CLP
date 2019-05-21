;;;======================================================
;;;   ICT319 Assignment 2
;;;
;;;   SpeakDog: The Dog Body Language Expert System
;;;
;;;     This system returns the dog emotion
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;; This is the template definition for the dog emotion. The fact has the following form:
;;; (dog (name ?STRING)(kind ?STRING)(ears ?NUMBER)(heads $?SYMBOL)(tail SYMBOL)(mouth $?SYMBOL)(body $?SYMBOL)(posture $?SYMBOL)(fur $?SYMBOL)(eyes $?SYMBOL))
;;; Better explained in the decision table include in Appendix B
	
(deftemplate dog "Template holding the characteristics of a dog emotion."	
	;;; Name, kind and ears. All three are required fields (default ?NONE). 
	(multislot name (type STRING) (default ?NONE))
	(multislot kind (type STRING) (default ?NONE))	
	(multislot ears (type SYMBOL) (default ?NONE)
		(allowed-symbols forward back))
	
	;;; Descripion in three seperate parts. Head is required, tail and mouth are optional.
	(multislot heads (type SYMBOL) (default ?NONE)
		(allowed-symbols held-high held-low normal stare tilted looking-away)
	)
	(slot tail (type SYMBOL) (default false) (allowed-symbols false true))
	(multislot mouth (type SYMBOL) (default ?DERIVE)
		(allowed-symbols nil wide-open snarl lips-drawn-back closed tongue-exposed lip-nose-licking relaxed)
	)
	
	;;; Body, optional field.
	(multislot body (type SYMBOL) (default ?NONE)
		(allowed-symbols wags-soft tense stiff lowered front-end-down crouching lean-forward hunched)
	)
	
	;;; Posture, optional field.
	(multislot posture (type SYMBOL) (default ?DERIVE)
		(allowed-symbols nil weight-balance tall-rigid paw-lifted weight-forward grovelling elbow-touching-floor weight-backward stand-tall-on-toes stiff-leg loose-stance paw-licking)
	)
	
	;;; Fur, optional field.
	(multislot fur (type SYMBOL) (default ?DERIVE)
		(allowed-symbols nil normal shedding raised-hackle)
	)
	
	;;; Eyes, optional field.
	(multislot eyes (type SYMBOL) (default ?DERIVE)
		(allowed-symbols nil big-soft dilated-whale-eyes whale-eyes big-intense-eyes normal wide-open soft-squinty squint partly-close)
	)
)

	
(deffacts dog-database "Adding dog database to the facts."
	;;; Happy and Joy
	(dog (name "Happy and Joy")
			(kind "It's a good day! I'm happy")
			(ears forward)
			(heads normal)
			(mouth wide-open)
			(posture weight-balance)
			(body wags-soft)
			(fur normal)
			(eyes big-soft)
	)
	
	;;; Alert
	(dog (name "Alert")
			(kind "I'm in charge!!")
			(ears forward)
			(heads stare)
			(mouth closed)
			(posture weight-forward)
			(body stiff)
			(fur normal)
			(eyes big-intense-eyes)
	)	
	;;; Curious
	(dog (name "Curious")
			(kind "What's that sound? It's that a cat??")
			(ears forward)
			(heads tilted)
			(mouth closed)
			(posture paw-lifted)
			(body lean-forward)
			(fur normal)
			(eyes wide-open)
	)		
	;;; Playfulness
	(dog (name "Playfulness")
			(kind "Oh, please throw the ball!!")
			(ears forward)
			(heads held-high)
			(tail true)
			(mouth tongue-exposed)
			(posture elbow-touching-floor)
			(body front-end-down)
			(fur normal)
			(eyes normal)
	)	
	;;; Neutral and Relax
	(dog (name "Neutral and Relax")
			(kind "I'm so relax and want to take a nap")
			(ears forward)
			(heads held-high)
			(mouth tongue-exposed)
			(posture loose-stance)
			(body wags-soft)
			(fur normal)
			(eyes soft-squinty)
	)		
	;;; Interest
	(dog (name "Interest")
			(kind "I'm interested in what's going on! OH HUMAN!!")
			(ears forward)
			(heads held-high)
			(mouth relaxed)
			(posture stand-tall-on-toes)
			(body lean-forward)
			(fur normal)
			(eyes big-intense-eyes)
	)	
	;;; Angry
	(dog (name "Angry")
			(kind "Just go away! I don't want to hurt you, I just need time to calm down")
			(ears back)
			(heads looking-away)
			(mouth snarl)
			(posture tall-rigid)
			(body tense)
			(fur normal)
			(eyes dilated-whale-eyes)
	)
	;;; Anxiety and Stress
	(dog (name "Anxiety and Stress")
			(kind "I'm not comfortable and I doesn't know what's going on...")
			(ears back)
			(heads looking-away)
			(mouth lip-nose-licking)
			(posture weight-backward)
			(body crouching)
			(fur raised-hackle)
			(eyes whale-eyes)
	)	
	;;; Warning
	(dog (name "Warning")
			(kind "I warning you,don't come near to me,I will bite you!")
			(ears back)
			(heads looking-away)
			(mouth closed)
			(posture stiff-leg)
			(body lowered)
			(fur raised-hackle)
			(eyes dilated-whale-eyes)
	)		
	;;; Fear and Defensive
	(dog (name "Fear and Defensive")
			(kind "I am frightened and defensive...")
			(ears back)
			(heads held-low)
			(mouth lips-drawn-back)
			(posture paw-lifted)
			(body lowered)
			(fur raised-hackle)
			(eyes whale-eyes)
	)	
	;;; Sad
	(dog (name "Sad")
			(kind "I'm not interested in going for walks, I'm worry and not happy... ")
			(ears back)
			(heads held-low)
			(mouth closed)
			(posture paw-licking)
			(body hunched)
			(fur shedding)
			(eyes squint)
	)
	;;; Submissive
	(dog (name "Submissive")
			(kind "I give up, don't hurt me please...")
			(ears back)
			(heads held-low)
			(mouth closed)
			(posture grovelling)
			(body lowered)
			(fur normal)
			(eyes partly-close)
	)		
)


;;; A global variable that holds the number of avaliable dog emotion.
(defglobal ?*counter* = 12)

;;; The variable above is being modified with this function each time we exclude an emotion from
;;; the possible solutions. (minusOne) decreases the global counter by one.
(deffunction minusOne ()
	(bind ?*counter* (- ?*counter* 1))
)

;;; This function is used for every question made to the user.
;;; The question that is printed to the user is broken into three arguments (?qBEG ?qMID ?qEND) for flexibility, as we may need to include a printable in the middle.
;;; The argument $?allowed-values is a list that holds the allowed values that the program accepts.
;;; If the user enters a non-acceptable value, the program asks the question again until the answer is valid.
(deffunction ask-question (?qBEG ?qMID ?qEND $?allowed-values)
	(printout t ?qBEG ?qMID ?qEND)
	(bind ?answer (read))
	(if (lexemep ?answer)
		then (bind ?answer (lowcase ?answer))
	)
	(while (not (member ?answer ?allowed-values)) do
		(printout t ?qBEG ?qMID ?qEND)
		(bind ?answer (read))
		(if (lexemep ?answer)
			then (bind ?answer (lowcase ?answer)))
	)
?answer)


;;; The first main question made to the user. We ask for the ears of the dog, expecting back or forward as the answer.
;;; The result is stored as the following fact: (theScale ?ears)
(defrule mainQuestion-Ears
	?x <- (initial-fact)
	=>
	(retract ?x)
	(printout t "*----------------------------------------------------------------*"crlf)
	(printout t "*   Welcome to SpeakDog Expert System                            *"crlf)
	(printout t "*   This is a simple expert system to identify a DOG EMOTION     *"crlf)
	(printout t "*   Wants to know more about your FURKIDS                        *"crlf)
	(printout t "*   Let's Start!                                                 *"crlf)
	(printout t "*----------------------------------------------------------------*"crlf)
	(bind ?ears (ask-question crlf "### How does the ears looks like - (back or forward?) ### " "" "" back forward))
	(assert (theScale ?ears))	
)

;;; Given that the fact (theScale ?ears) exists, this rule gets triggered.
;;; This rule filters by ear, and deletes those that are not in the given ears group.
;;; In addition, every time we retract an emotion, we substract one from the global variable ?*counter* calling the (minusOne) function.
(defrule filterBy-Ears
	(theScale ?s)
	?ani <- (dog (ears $?ears))
	=>
	(if (not (member$ ?s $?ears))
		then (retract ?ani) (minusOne)
	)
)


;;; The second main question is about the head of the dog. The user can type any head from the acceptable list in the parentheses.
;;; The result is stored as the following fact: (theHead ?head)
(defrule mainQuestion-Head
	(theScale ?s)
	=>
	(bind ?head (ask-question crlf 
	"### How does the head looks like? 
	Please select -
	 ~~~~~~~~~~~~~~~~~~~~~~~~
	 held-high
	 held-low 
	 normal 
	 stare 
	 tilted 
	 looking-away
	 ~~~~~~~~~~~~~~~~~~~~~~~~
	 *Your selection: " "" "" held-high held-low normal stare tilted looking-away))
	(assert (theHead ?head))
)	

	
;;; Given that the fact (theHead ?head) exists, this rule gets triggered. 
;;; This rule filters the animals by head, and deletes those that do not have this head in the list of heads.
;;; In addition, every time we retract an emotion, we substract one from the global variable ?*counter* calling the (minusOne) function.
(defrule filterBy-head
	(theHead ?c)
	?ani <- (dog (heads $?heads))
	=>
	(if (not (member$ ?c $?heads))
		then (retract ?ani) (minusOne)
	)
)


;;; After the Scale and head filtering process, we check the global variable ?*counter*.
;;; If we have 1 emotion left, this is the result and we assert (found true) in order to trigger the success print rule below.
;;; If we have 0 emotion left, we assert (found false) as there are no emotions that passed the filtering.
;;; If we got more than one, we need more facts to reach a conclusion, so we assert (needMoreFacts ?scale ?head) for the program to continue asking.
(defrule postFilteringEvaluation
    ?scale <- (theScale ?s)
	?head <- (theHead ?c)
	=>
	(retract ?scale ?head)
	(if (eq ?*counter* 1)
		then (assert (found true))
	else (if (eq ?*counter* 0)
			then (assert (found false))
		 ) 
	else (if (> ?*counter* 1)
			then (assert (needMoreFacts ?s ?c))
		 ) 
	)	
)	

;;; Given the fact (needMoreFacts ?s ?c) where ?s is the ears and ?c is the head the user has asked, we ask a more specific question about the dog
;;; that we are searching. We then assert a fact in the following form: (ask X Y) where X is a field of the dog emotion template and Y is what we are searching in X.
;;; This rule is based on the table that is included in the decision table.
(defrule needMoreFacts
	?q <-(needMoreFacts ?s ?c)
	=>
	(retract ?q)
	(if (and (eq ?s forward) (eq ?c held-high))
		then (assert (ask tail true))
	)
	(if (and (eq ?s back) (eq ?c looking-away))
		then (assert (ask mouth snarl))
	)
	(if (and (eq ?s back) (eq ?c held-low))
		then (assert (ask eyes whale-eyes))
	)
)

;;; This rule follows the same idea as the rule above, but instead of two emotions we have three.
;;; We ask the dog's mouth . Based on the decision table, if the answer is yes, we get a solution and we assert (found true).
;;; Otherwise, answering no, we get two possible emotions and we need to ask one more question. Thus, we assert (ask body crouching)
;;; in order to trigger the rule that follows.
(defrule askMouth
	?q <-(ask mouth snarl)
	?ani1 <- (dog (mouth snarl))
	?ani2 <- (dog (mouth $?content1))
	?ani3 <- (dog (mouth $?content2))
	(test (neq ?ani2 ?ani3))
	=>
	(retract ?q)
	(bind ?a (ask-question "### Does the dogs snarl - " mouth "? (yes/no) ### " yes no))
	(if (eq ?a yes)
		then (retract ?ani2) (minusOne)(retract ?ani3) (minusOne)
		else (retract ?ani1) (minusOne)(assert (ask body crouching))
	)
	(if (eq ?*counter* 1)
		then (assert (found true))
	)
)


;;; This rule gets triggered if the previous one (askMouth) was triggered and the fact (ask body crouching) is present.
;;; Other than that, it follows the same idea as the rules above where we only have two possible emotions.
;;; One of them gets filtered out and we got a solution, asserting (found true).
(defrule askBody
	?q <-(ask body ?ans)
	?ani1 <- (dog (body $?content1))
	(test (member$ ?ans $?content1))
	?ani2 <- (dog (body $?content2))
	(test (neq ?ani1 ?ani2))
	=>
	(retract ?q)
	(bind ?a (ask-question  "### Is the body " ?ans "? (yes/no) ### " yes no))
	(if (eq ?a yes)
		then (retract ?ani2) (minusOne)
		else (retract ?ani1) (minusOne)
	)
	(if (eq ?*counter* 1)
		then (assert (found true))
	)
)

;;; This rule follows the same idea as the rule above, but instead of two emotions we have three.
;;; We ask the dog's eyes. Based on the decision table, If the answer is yes, we get a solution and we assert (found true).
;;; Otherwise, answering no, we get two possible emotions and we need to ask one more question. Thus, we assert (ask shedding)
;;; in order to trigger the rule that follows.
(defrule askEyes
	?q <-(ask eyes whale-eyes)
	?ani1 <- (dog (eyes whale-eyes))
	?ani2 <- (dog (eyes $?content1))
	?ani3 <- (dog (eyes $?content2))
	(test (neq ?ani2 ?ani3))
	=>
	(retract ?q)
	(bind ?a (ask-question "### Is the dog has whale-" eyes "? (yes/no) ### " yes no))
	(if (eq ?a yes)
		then (retract ?ani2) (minusOne)(retract ?ani3) (minusOne)
		else (retract ?ani1) (minusOne)(assert (ask fur shedding))
	)
	(if (eq ?*counter* 1)
		then (assert (found true))
	)
)

;;; This rule gets triggered if the previous one (askEyes) was triggered and the fact (ask fur shedding) is present.
;;; Other than that, it follows the same idea as the rules above where we only have two possible emotions.
;;; One of them gets filtered out and we got a solution, asserting (found true).
(defrule askFur
	?q <-(ask fur ?ans)
	?ani1 <- (dog (fur $?content1))
	(test (member$ ?ans $?content1))
	?ani2 <- (dog (fur $?content2))
	(test (neq ?ani1 ?ani2))
	=>
	(retract ?q)
	(bind ?a (ask-question "### Is the fur " ?ans "? (yes/no) ### " yes no))
	(if (eq ?a yes)
		then (retract ?ani2) (minusOne)
		else (retract ?ani1) (minusOne)
	)
	(if (eq ?*counter* 1)
		then (assert (found true))
	)
)

;;; This rule follows the same idea as the rule above, but instead of two emotinos we have three.
;;; We ask the dog's tail . Based on the decision table, If the answer is yes, we get a solution and we assert (found true).
;;; Otherwise, answering no, we get two possible emotions and we need to ask one more question. Thus, we assert (ask loose-stance)
;;; in order to trigger the rule that follows.
(defrule askTail
	?q <-(ask tail  true)
	?ani1 <- (dog (tail  true))
	?ani2 <- (dog (tail  false))
	?ani3 <- (dog (tail  false))
	(test (neq ?ani2 ?ani3))
	=>
	(retract ?q)
	(bind ?a (ask-question "### Does the dogs high wagging " tail "? (yes/no) ### " yes no))
	(if (eq ?a yes)
		then (retract ?ani2) (minusOne) (retract ?ani3) (minusOne)
		else (retract ?ani1) (minusOne) (assert (ask posture loose-stance))
	)
	(if (eq ?*counter* 1)
		then (assert (found true))
	)
)	

;;; This rule gets triggered if the previous one (askTail) was triggered and the fact (ask posture loose-stance) is present.
;;; Other than that, it follows the same idea as the rules above where we only have two possible emotions.
;;; One of them gets filtered out and we got a solution, asserting (found true).
(defrule askPosture
	?q <-(ask posture ?ans)
	?ani1 <- (dog (posture $?content1))
	(test (member$ ?ans $?content1))
	?ani2 <- (dog (posture $?content2))
	(test (neq ?ani1 ?ani2))
	=>
	(retract ?q)
	(bind ?a (ask-question "### Does the dog " ?ans "? (yes/no) ### " yes no))
	(if (eq ?a yes)
		then (retract ?ani2) (minusOne)
		else (retract ?ani1) (minusOne)
	)
	(if (eq ?*counter* 1)
		then (assert (found true))
	)
)

;;; If the fact (found true) is present, it means that we have only one (emotion) fact in memory, thus we have concluded to
;;; the one the user searches for. We assign this emotion to the variable ?ani and print it's name and message to convey to the user.
(defrule matchFound
	?f <- (found true)
	?ani <- (dog (name ?n) (kind ?k))
	=>
	(retract ?f ?ani)
	(printout t "******************************************" crlf)
	(printout t "* Emotion Found!" crlf)
	(printout t "* I am " ?n  crlf)
	(printout t "* " ?k crlf)
	(printout t "******************************************" crlf)
)

;;; Just like the rule above, if the fact (found false) is present, we have no (emotion) facts in memory. This means we have
;;; no results with the given criteria. 
(defrule matchNotFound
	?f <- (found false)
	=>
	(retract ?f)
	(printout t "***************************************************************" crlf)
	(printout t "* Emotion can't be found!" crlf)
    (printout t "* This is not a normal dog behaviour, maybe I'm sick..." crlf)
	(printout t "* Bring me to the vet, I need to see a doctor" crlf)
	(printout t "***************************************************************" crlf)
)