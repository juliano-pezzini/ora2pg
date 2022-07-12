-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION anzics_pck.get_care_type (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

    nr_reterno_w       bigint := 1;
    is_exists_w varchar(1) := 'N';

BEGIN

    select CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END 
    into STRICT is_exists_w
    from ATEND_ANZICS_CARETYPE  
    where nr_atendimento = nr_atendimento_p;

    if (is_exists_w ='S') then
    select ie_care_type
    into STRICT nr_reterno_w
    from ATEND_ANZICS_CARETYPE  
    where nr_atendimento = nr_atendimento_p;

    end if;

    RETURN nr_reterno_w;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION anzics_pck.get_care_type (nr_atendimento_p bigint) FROM PUBLIC;
