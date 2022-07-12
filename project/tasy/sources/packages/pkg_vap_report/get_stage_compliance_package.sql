-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_vap_report.get_stage_compliance (P_NR_ATEND bigint, P_ESTAB bigint, P_DT_START timestamp, P_DT_END timestamp, P_STAGE bigint) RETURNS bigint AS $body$
DECLARE


    NR bigint;

  
BEGIN
  
    SELECT COUNT(DISTINCT DT_FIM)
      INTO STRICT NR
      FROM GQA_PROTOCOLO_PAC P, GQA_PROTOCOLO_ETAPA_PAC E
     WHERE P.NR_SEQ_PROTOCOLO = PKG_REPORT_DATA.GET_PROTOCOL(1)
       AND P.IE_SITUACAO = 'A'
       AND P.NR_ATENDIMENTO = P_NR_ATEND
       AND E.NR_SEQ_PROT_PAC = P.NR_SEQUENCIA
       AND E.NR_SEQ_ETAPA = PKG_REPORT_DATA.GET_STAGE(P_STAGE)
       AND pkg_vap_report.get_estab_dt(P_ESTAB, E.DT_INICIO) BETWEEN P_DT_START AND P_DT_END
       AND (E.DT_FIM IS NOT NULL AND E.DT_FIM::text <> '');

    RETURN NR;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_vap_report.get_stage_compliance (P_NR_ATEND bigint, P_ESTAB bigint, P_DT_START timestamp, P_DT_END timestamp, P_STAGE bigint) FROM PUBLIC;
