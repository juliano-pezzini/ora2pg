-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_doenca_cid_atend ( nr_atendimento_p bigint, nr_seq_ordem_cid_p bigint, ie_tipo_inf_p text) RETURNS varchar AS $body$
DECLARE


/*
	ie_tipo_inf_p
	- MAL = ie_doenca_cronica_mx
	- CD = cd_doenca_cid
	- DS = ds_doenca_cid
*/
ds_retorno_w			varchar(255);
nr_seq_interno_w		diagnostico_doenca.nr_seq_interno%type;
cd_doenca_w			diagnostico_doenca.cd_doenca%type;
ie_doenca_cronica_mx_w		cid_doenca.ie_doenca_cronica_mx%type;
ds_doenca_cid_w			cid_doenca.ds_doenca_cid%type;
cd_doenca_cid_w			cid_doenca.cd_doenca_cid%type;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	if (nr_seq_ordem_cid_p = 1) then
		select 	min(nr_seq_interno)
		into STRICT	nr_seq_interno_w
		from 	diagnostico_doenca
		where 	nr_atendimento = nr_atendimento_p;
	else
		select 	max(nr_seq_interno)
		into STRICT	nr_seq_interno_w
		from 	diagnostico_doenca
		where 	nr_atendimento = nr_atendimento_p;
	end if;

	select	cd_doenca
	into STRICT	cd_doenca_w
	from	diagnostico_doenca
	where	nr_seq_interno 	= nr_seq_interno_w;


	select	ie_doenca_cronica_mx,
		cd_doenca_cid,
		ds_doenca_cid
	into STRICT	ie_doenca_cronica_mx_w,
		cd_doenca_cid_w,
		ds_doenca_cid_w
	from	cid_doenca
	where	cd_doenca_cid = cd_doenca_w;

	if (ie_tipo_inf_p = 'MAL') then
		ds_retorno_w	:= ie_doenca_cronica_mx_w;

	elsif (ie_tipo_inf_p = 'CD') then
		ds_retorno_w	:= cd_doenca_cid_w;

	elsif (ie_tipo_inf_p = 'DS') then
		ds_retorno_w	:= ds_doenca_cid_w;

	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_doenca_cid_atend ( nr_atendimento_p bigint, nr_seq_ordem_cid_p bigint, ie_tipo_inf_p text) FROM PUBLIC;

