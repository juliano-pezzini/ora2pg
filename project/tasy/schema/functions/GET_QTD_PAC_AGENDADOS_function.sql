-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_qtd_pac_agendados ( NR_SEQ_AG_CONSULTA_P bigint) RETURNS bigint AS $body$
DECLARE

  CD_PESSOA_FISICA_W AGENDA_CONSULTA.CD_PESSOA_FISICA%TYPE;
  IE_STATUS_AGENDA_W AGENDA_CONSULTA.IE_STATUS_AGENDA%TYPE;
  QTD_PAC_AGENDAMENTO_W bigint;
  QTD_PAC_ATENDIDO_W bigint;
  QTD_PAC_AGENDADO_W bigint;


BEGIN

   SELECT MAX(AC.IE_STATUS_AGENDA)
   INTO STRICT IE_STATUS_AGENDA_W
   FROM AGENDA_CONSULTA AC
   WHERE AC.NR_SEQUENCIA =  NR_SEQ_AG_CONSULTA_P
   AND	IE_STATUS_AGENDA  IN ('C','L','B','LF');

   IF (IE_STATUS_AGENDA_W IS NOT NULL AND IE_STATUS_AGENDA_W::text <> '') THEN 
    RETURN 0;
   END IF;

   SELECT MAX(AC.CD_PESSOA_FISICA)
   INTO STRICT CD_PESSOA_FISICA_W
   FROM AGENDA_CONSULTA AC
   WHERE AC.NR_SEQUENCIA =  NR_SEQ_AG_CONSULTA_P;

   IF (CD_PESSOA_FISICA_W IS NOT NULL AND CD_PESSOA_FISICA_W::text <> '')THEN
    RETURN 1;
   END IF;

      
   SELECT COUNT(C.NR_SEQUENCIA) QTD_PAC_AGENDAMENTO
    INTO STRICT QTD_PAC_AGENDAMENTO_W
    FROM AGENDA_INTEGRADA A,
    AGENDA_INTEGRADA_ITEM AI,
    AGENDA_CONSULTA B,
    AGENDAMENTO_COLETIVO C
   WHERE
     B.NR_SEQUENCIA = NR_SEQ_AG_CONSULTA_P
     AND AI.NR_SEQ_AGENDA_CONS = B.NR_SEQUENCIA
     AND A.NR_SEQUENCIA  = AI.NR_SEQ_AGENDA_INT 
     AND C.NR_SEQ_AG_INTEGRADA = A.NR_SEQUENCIA;

   SELECT COUNT(*) QTD_PAC_ATENDIDOS
   INTO STRICT QTD_PAC_ATENDIDO_W
   FROM agenda_consulta X
   WHERE X.nr_seq_agend_coletiva IN (SELECT C.NR_SEQUENCIA QTD_PAC_AGENDAMENTO
          FROM AGENDA_INTEGRADA A,
          AGENDA_INTEGRADA_ITEM AI,
          AGENDA_CONSULTA B,
          AGENDAMENTO_COLETIVO C
        WHERE 
          B.NR_SEQUENCIA = NR_SEQ_AG_CONSULTA_P
          AND AI.NR_SEQ_AGENDA_CONS = B.NR_SEQUENCIA
          AND A.NR_SEQUENCIA  = AI.NR_SEQ_AGENDA_INT 
          AND C.NR_SEQ_AG_INTEGRADA = A.NR_SEQUENCIA);

   SELECT QTD_PAC_AGENDAMENTO_W - QTD_PAC_ATENDIDO_W
   INTO STRICT QTD_PAC_AGENDADO_W
;

   RETURN QTD_PAC_AGENDADO_W;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_qtd_pac_agendados ( NR_SEQ_AG_CONSULTA_P bigint) FROM PUBLIC;
