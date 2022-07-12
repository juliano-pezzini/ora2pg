-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_atend_pac_unid.get_min_entry_next_unit (P_NR_ATEND bigint, P_DT_ENTRY timestamp, P_CD_SETOR bigint) RETURNS timestamp AS $body$
DECLARE

  DT timestamp;


BEGIN

    SELECT MIN(DT_ENTRADA_UNIDADE)
      INTO STRICT DT
      FROM ATEND_PACIENTE_UNIDADE U
     WHERE U.NR_ATENDIMENTO = P_NR_ATEND
       AND U.DT_ENTRADA_UNIDADE > P_DT_ENTRY
       AND U.CD_SETOR_ATENDIMENTO <> P_CD_SETOR
       AND U.IE_PASSAGEM_SETOR NOT IN ('S', 'L')
       AND NOT EXISTS (SELECT 1 
                  FROM SETOR_ATENDIMENTO S
                 WHERE S.CD_SETOR_ATENDIMENTO = U.CD_SETOR_ATENDIMENTO
                   AND S.CD_CLASSIF_SETOR IN ('6', '7', '10'));

     IF (DT IS NOT NULL AND DT::text <> '') THEN
       DT := DT - 1/(24*60*60);
     END IF;

    RETURN DT;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_atend_pac_unid.get_min_entry_next_unit (P_NR_ATEND bigint, P_DT_ENTRY timestamp, P_CD_SETOR bigint) FROM PUBLIC;
