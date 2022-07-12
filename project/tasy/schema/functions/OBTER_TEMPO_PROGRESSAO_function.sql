-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_progressao ( cd_pessoa_fisica_p text, cd_cid_doenca_p text, dt_diagnostico_p timestamp, ie_progressao_p bigint) RETURNS varchar AS $body$
DECLARE


dt_diag_anterior_w	timestamp;
ds_retorno_w		varchar(25);


BEGIN

select	max(DT_AVALIACAO)
into STRICT	dt_diag_anterior_w
from	can_loco_regional
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	CD_DOENCA_CID		= cd_cid_doenca_p
and	coalesce(dt_inativacao::text, '') = ''
and	((ie_progressao		= ie_progressao_p - 1)	or (ie_progressao_p	= 0));

if (dt_diag_anterior_w IS NOT NULL AND dt_diag_anterior_w::text <> '') then
	ds_retorno_w	:= Obter_Idade(dt_diag_anterior_w,dt_diagnostico_p,'AM');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_progressao ( cd_pessoa_fisica_p text, cd_cid_doenca_p text, dt_diagnostico_p timestamp, ie_progressao_p bigint) FROM PUBLIC;
