-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_obs_albumina ( nr_seq_grupo_p bigint) RETURNS varchar AS $body$
DECLARE

ie_obriga_observacao_w	varchar(1) := 'N';

BEGIN
if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
	begin
	select	coalesce(ie_obriga_obs,'N')
	into STRICT	ie_obriga_observacao_w
	from	grupo_indicacao_albumina
	where 	nr_sequencia = nr_seq_grupo_p;
	end;
end if;
return	ie_obriga_observacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_obs_albumina ( nr_seq_grupo_p bigint) FROM PUBLIC;

