-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_id_maquina ( nr_seq_maquina_p bigint, nr_seq_local_atend_p bigint, ie_restringe_local_atend_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (ie_restringe_local_atend_p	= 'S') then
	select	max(id_maquina)
	into STRICT	ds_retorno_w
	from	local_atend_med_maquina
	where	nr_sequencia		= nr_seq_maquina_p
	and	nr_seq_local_atend	= nr_seq_local_atend_p;
elsif (ie_restringe_local_atend_p	= 'N') then
	select	max(id_maquina)
	into STRICT	ds_retorno_w
	from	local_atend_med_maquina
	where	nr_sequencia	= nr_seq_maquina_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_id_maquina ( nr_seq_maquina_p bigint, nr_seq_local_atend_p bigint, ie_restringe_local_atend_p text) FROM PUBLIC;
