-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_motcanc_agenda_regra (cd_perfil_p bigint, nr_seq_motivo_cancel_agenda_p bigint, ie_agenda_p text, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_motivo_regra_w	integer;
ds_retorno_w		varchar(1);
qt_regra_w		integer;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	agenda_motivo_canc_regra
where	nr_seq_motivo_cancel_agenda	= nr_seq_motivo_cancel_agenda_p;

if (qt_Regra_w > 0) then
	select	count(*)
	into STRICT	qt_motivo_regra_w
	from	agenda_motivo_canc_regra
	where	coalesce(cd_perfil,cd_perfil_p)	= cd_perfil_p
	and	((cd_estabelecimento		= cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
	and	nr_seq_motivo_cancel_agenda	= nr_seq_motivo_cancel_agenda_p
	and	((coalesce(ie_Agenda, 'T')			= ie_Agenda_p)
	or (coalesce(ie_Agenda, 'T')			= 'T'));

	if (qt_motivo_regra_w	> 0) then
		ds_retorno_w	:= 'N';
	else
		ds_retorno_w	:= 'S';
	end if;
else
	ds_retorno_w	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_motcanc_agenda_regra (cd_perfil_p bigint, nr_seq_motivo_cancel_agenda_p bigint, ie_agenda_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
