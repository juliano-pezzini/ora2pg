-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_atend_pac_unid.get_next_unit (P_NR_ATEND bigint, P_DT_EXIT timestamp, P_CD_SETOR bigint) RETURNS bigint AS $body$
DECLARE


    CD integer;
    DT timestamp;

  
BEGIN
    CD := NULL;

    IF (P_NR_ATEND IS NOT NULL AND P_NR_ATEND::text <> '') AND (P_DT_EXIT IS NOT NULL AND P_DT_EXIT::text <> '') AND (P_CD_SETOR IS NOT NULL AND P_CD_SETOR::text <> '') THEN
      --
      DT := pkg_atend_pac_unid.get_min_entry_next_unit(P_NR_ATEND, P_DT_EXIT, P_CD_SETOR);

      IF (DT IS NOT NULL AND DT::text <> '') THEN
        DT := DT + 1/(24*60*60);
        --
        SELECT U.CD_SETOR_ATENDIMENTO
          INTO STRICT CD
          FROM ATEND_PACIENTE_UNIDADE U
         WHERE U.NR_ATENDIMENTO = P_NR_ATEND
           AND U.DT_ENTRADA_UNIDADE = DT;
        --
      END IF;
      --
    END IF;

    RETURN CD;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_atend_pac_unid.get_next_unit (P_NR_ATEND bigint, P_DT_EXIT timestamp, P_CD_SETOR bigint) FROM PUBLIC;