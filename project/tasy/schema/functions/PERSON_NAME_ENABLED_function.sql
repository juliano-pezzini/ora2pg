-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION person_name_enabled () RETURNS varchar AS $body$
DECLARE


name_feature_enabled varchar(1) := 'N';

BEGIN
name_feature_enabled := pkg_name_utils.get_name_feature_enabled;

return	name_feature_enabled;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION person_name_enabled () FROM PUBLIC;
