-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_atend_pac_unid.get_estab_dt (P_ESTAB bigint, P_DT timestamp) RETURNS timestamp AS $body$
DECLARE


    ESTAB_TZ_V varchar(15);
    SYS_TZ_V   varchar(15);
    DT_V       timestamp;
    TZ_V       TIMESTAMP WITH TIME ZONE;
    CMD        varchar(255);

  
BEGIN
  
    IF coalesce(P_DT::text, '') = '' THEN 
    --
      DT_V := NULL;
    --
    ELSIF coalesce(P_ESTAB::text, '') = '' THEN
      DT_V := P_DT;
    --
    ELSE
    --  
      ESTAB_TZ_V := pkg_atend_pac_unid.get_estab_tz(P_ESTAB, P_DT);
      SYS_TZ_V   := TO_CHAR(CURRENT_TIMESTAMP, 'TZR');

      IF ESTAB_TZ_V = SYS_TZ_V THEN
      --
        DT_V := P_DT;
      --
      ELSE
      --
        BEGIN

          CMD := 'SELECT TO_TIMESTAMP_TZ(TO_CHAR(:1,''DD/MM/YYYY HH24:MI:SS'')||'''||SYS_TZ_V||''',''DD/MM/YYYY HH24:MI:SSTZH:TZM'') AT TIME ZONE '''|| ESTAB_TZ_V ||''' FROM DUAL';
          
          EXECUTE CMD INTO STRICT TZ_V USING P_DT;

          DT_V := TO_DATE(TO_CHAR(TZ_V, 'DD/MM/YYYY HH24:MI:SS'), 'DD/MM/YYYY HH24:MI:SS');

        EXCEPTION WHEN OTHERS THEN
          
          DT_V := P_DT;

        END;
      --
      END IF;
    --
    END IF;

    RETURN DT_V;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_atend_pac_unid.get_estab_dt (P_ESTAB bigint, P_DT timestamp) FROM PUBLIC;
