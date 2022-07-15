-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pepo_justif_cir_ag_anest_ocor (DS_JUSTIFICATIVA_P CIRURGIA_AGENTE_ANEST_OCOR.DS_JUSTIFICATIVA%TYPE, NR_SEQUENCIA_P CIRURGIA_AGENTE_ANEST_OCOR.NR_SEQUENCIA%TYPE) AS $body$
BEGIN

  IF coalesce(NR_SEQUENCIA_P, 0) > 0 AND (trim(both DS_JUSTIFICATIVA_P) IS NOT NULL AND (trim(both DS_JUSTIFICATIVA_P))::text <> '') THEN
    UPDATE CIRURGIA_AGENTE_ANEST_OCOR
       SET DS_JUSTIFICATIVA = DS_JUSTIFICATIVA_P
     WHERE NR_SEQUENCIA = NR_SEQUENCIA_P;
  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pepo_justif_cir_ag_anest_ocor (DS_JUSTIFICATIVA_P CIRURGIA_AGENTE_ANEST_OCOR.DS_JUSTIFICATIVA%TYPE, NR_SEQUENCIA_P CIRURGIA_AGENTE_ANEST_OCOR.NR_SEQUENCIA%TYPE) FROM PUBLIC;

