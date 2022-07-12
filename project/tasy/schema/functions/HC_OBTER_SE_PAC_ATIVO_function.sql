-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hc_obter_se_pac_ativo ( nr_seq_paciente_hc_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN
ds_retorno_w	:= 'A';
if (nr_seq_paciente_hc_p IS NOT NULL AND nr_seq_paciente_hc_p::text <> '') then
	select	max(ie_situacao)
	into STRICT	ds_retorno_w
	from	paciente_home_care
	where	nr_sequencia = nr_seq_paciente_hc_p;
elsif (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	coalesce(max(ie_situacao),'A')
	into STRICT	ds_retorno_w
	from	paciente_home_care
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	dt_inicio = (	SELECT	max(dt_inicio)
				from	paciente_home_care
				where	cd_pessoa_fisica = cd_pessoa_fisica_p);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hc_obter_se_pac_ativo ( nr_seq_paciente_hc_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

