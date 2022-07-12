-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION can_release_cancel_verified_sp () RETURNS varchar AS $body$
DECLARE

can_release_verified_sp_w varchar(1) := 'N';
count_w bigint;


BEGIN
  select count(1) into STRICT count_w
  from MAN_SERVICE_PACK_VERSAO
  where ie_status_build = 'G';

  if (count_w > 0) then
    can_release_verified_sp_w := 'S';
  end if;

  RETURN can_release_verified_sp_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION can_release_cancel_verified_sp () FROM PUBLIC;

