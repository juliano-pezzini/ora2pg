-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_conversao_obter_parentesco ( cd_ptu_dependencia_p bigint, ie_sexo_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_parenteco_w		bigint;


BEGIN

select	max(nr_seq_parentesco)
into STRICT	nr_seq_parenteco_w
from	ptu_regra_parentesco
where	CD_DEPENDENCIA	= cd_ptu_dependencia_p
and	ie_sexo		= ie_sexo_p;

return	nr_seq_parenteco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_conversao_obter_parentesco ( cd_ptu_dependencia_p bigint, ie_sexo_p text) FROM PUBLIC;
