-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mostra_item_sae ( nr_seq_modelo_p bigint, nr_seq_item_p bigint, cd_setor_paciente_p bigint default null) RETURNS varchar AS $body$
DECLARE


qt_registros_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	PE_SAE_MOD_ITEM
where	nr_seq_modelo	= nr_seq_modelo_p;

if (qt_registros_w	> 0) then

	select	count(*)
	into STRICT	qt_registros_w
	from	PE_SAE_MOD_ITEM
	where	nr_seq_modelo	= nr_seq_modelo_p
	and	nr_seq_item	= nr_seq_item_p
	and	((coalesce(cd_setor_pac::text, '') = '') or ((cd_setor_pac = cd_setor_paciente_p) or (coalesce(cd_setor_paciente_p::text, '') = '')));

	if (qt_registros_w	> 0) then
		return	'S';
	else
		return	'N';
	end if;

else
	return	'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mostra_item_sae ( nr_seq_modelo_p bigint, nr_seq_item_p bigint, cd_setor_paciente_p bigint default null) FROM PUBLIC;

