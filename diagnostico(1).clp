; ***********************
; * SISTEMA DE DIAGNÓSTICO MÉDICO BÁSICO 
; LUIS ENRIQUE HERNÁNDEZ TORRES
; MARCELO LINARES GONZÁLEZ
; ALEJANDRO ROSAS URDAPILLETA
; ***********************

; (load"C:\\Users\\luis1\\OneDrive\\Documentos\\4sem\\diagnostico.clp")
; (reset)
; (run)

(deffacts inicio
   (estado actual)
   (sin-diagnostico))

; INICIO
(defrule iniciar
   (estado actual)
   =>
   (println crlf "=== SISTEMA DE DIAGNÓSTICO MÉDICO BÁSICO ===" crlf)
   (println crlf " LUIS ENRIQUE HERNÁNDEZ TORRES " crlf)
   (println crlf " MARCELO LINARES GONZÁLEZ " crlf)
   (println crlf " ALEJANDRO ROSAS URDAPILLETA " crlf)
   (println crlf "=== ES IMPORTANTE ESCRIBIR SOLO EN MINUSCULAS ===" crlf)
   (println crlf "=== CONSULTE A SU MÉDICO ===" crlf)
   (println "¿El paciente tiene fiebre? (s/n)")
   (assert (fiebre (read))))
;Hacemos la primera pregunta que es si es que se tiene fiebre
; FIEBRE SÍ
(defrule tiene-fiebre
   (fiebre s)
   =>
   (println "¿Tiene síntomas respiratorios (tos, estornudos, rinorrea, dolor de garganta, disnea)? (s/n)")
   (assert (respiratorio (read))))
;Luego pasamos a la pregunta de que si es que se tienen sintomas respiratorios
(defrule infeccion-respiratoria
   (respiratorio s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Infección respiratoria aguda ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))
;Mostramos el posible diagnostico que es infeccion respiratoria
(defrule otitis
   (oido s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Otitis media aguda ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))
; De la misma forma preguntamos y descartamos si se trata de covid
(defrule covid-si
   (covid s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: COVID-19 ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))
;En caso de que no sea ninguna de las enfermedades anteriores pasamos a las enfermedades con respiratorias
(defrule no-respiratorio
   (respiratorio n)
   =>
   (println "¿Tiene diarrea, vómito o dolor abdominal? (s/n)")
   (assert (abdominal (read))))
;Damos los sintomas de infeccion intestinal
(defrule infeccion-intestinal
   (abdominal s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Infección intestinal ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))
;Damos los sintomas de una infeccion urinaria
(defrule infeccion-urinaria
   (urinario s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Infección de vías urinarias")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))
;Tambien descartamos que no se trate de una enfermedad bucal como la gingivitis
; FIEBRE NO
(defrule no-fiebre
   (fiebre n)
   =>
   (println "¿Tiene sangrado de encías, inflamación, mal aliento o movilidad dental? (s/n)")
   (assert (boca (read))))

(defrule gingivitis
   (boca s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Gingivitis o enfermedad periodontal")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))

(defrule gastritis
   (gastrico s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Úlceras, gastritis o duodenitis ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))

(defrule conjuntivitis
   (ojos s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Conjuntivitis")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))
; Por ultimo pasamos a las enfermedades cronicas mas comunes en México como lo es la diabetes y la hipertension
(defrule obesidad
   (obesidad s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Obesidad")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))

(defrule hipertension-si
   (presion s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Hipertensión arterial ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))

(defrule vulvovaginitis
   (vulva s)
   ?f <- (sin-diagnostico)
   =>
   (println "→ Diagnóstico probable: Vulvovaginitis ")
   (retract ?f)
   (assert (diagnosticado))
   (assert (fin)))

; RAMAS INTERMEDIAS
(defrule preguntar-urinario
   (abdominal n)
   =>
   (println "¿Dolor o ardor al orinar, urgencia urinaria o fiebre sin foco? (s/n)")
   (assert (urinario (read))))

(defrule preguntar-gastrico
   (boca ?)
   =>
   (println "¿Dolor epigástrico, acidez, náuseas o toma AINES? (s/n)")
   (assert (gastrico (read))))

(defrule preguntar-ojos
   (gastrico ?)
   =>
   (println "¿Enrojecimiento ocular, secreción o picor en los ojos? (s/n)")
   (assert (ojos (read))))

(defrule cronico
   (or (fiebre ?) (boca ?))
   =>
   (println "¿Quiere hacer una evaluación general del estado de salud? (s/n)")
   (assert (general (read))))

(defrule evaluacion-general
   (general s)
   =>
   (println "¿Tiene sobrepeso visible o IMC elevado? (s/n)")
   (assert (obesidad (read))))

(defrule hipertension
   (obesidad ?)
   =>
   (println "¿Presión alta (>140/90), dolor de cabeza o mareos? (s/n)")
   (assert (presion (read))))

(defrule vaginal
   (presion ?)
   =>
   (println "¿Es niña o mujer con flujo vaginal anormal, prurito o dolor? (s/n)")
   (assert (vulva (read))))
;Por ultimo preguntamos si se quiere terminar o repetir las preguntas
; FINALIZACIÓN
(defrule preguntar-repetir
   (diagnosticado)
   (fin)
   =>
   (println crlf "¿Desea realizar otro diagnóstico? (s/n)")
   (assert (repetir (read))))

(defrule repetir-si
   (repetir s)
   =>
   (reset)
   (run))

(defrule repetir-no
   (repetir n)
   =>
   (println "Gracias por usar el sistema de diagnóstico.")
   (clear))

