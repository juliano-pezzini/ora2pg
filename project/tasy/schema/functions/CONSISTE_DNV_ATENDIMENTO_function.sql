-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_dnv_atendimento ( nr_atendimento_p bigint, nr_dnv_p text, ie_tipo_nascimento_p text, qt_peso_p bigint, ie_unico_nasc_vivo_p text) RETURNS varchar AS $body$
DECLARE

nr_total_w	smallint;
ds_returno_w	varchar(256);
ie_natmorto_w	varchar(1)	:= 'N';
cd_dnv_nat_morto_w	varchar(255);
nr_atendimento_w	bigint;


BEGIN

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	nascimento
where	nr_dnv = nr_dnv_p
and 	coalesce(dt_inativacao::text, '') = ''
and	nr_atendimento <> nr_atendimento_p;

cd_dnv_nat_morto_w := Obter_Param_Usuario(281, 459, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, 0, cd_dnv_nat_morto_w);

if (nr_dnv_p	= cd_dnv_nat_morto_w) and (ie_tipo_nascimento_p in ('5','7') or (coalesce(ie_unico_nasc_vivo_p,'S') = 'N')) and (coalesce(qt_peso_p,500)	>= 500) then
	begin
	ie_natmorto_w	:= 'S';
	end;
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (ie_natmorto_w	= 'N') then
	
	ds_returno_w := wheb_mensagem_pck.get_texto(791660) || wheb_mensagem_pck.get_texto(791662) || ' '||nr_atendimento_w;
	
end if;

return	ds_returno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_dnv_atendimento ( nr_atendimento_p bigint, nr_dnv_p text, ie_tipo_nascimento_p text, qt_peso_p bigint, ie_unico_nasc_vivo_p text) FROM PUBLIC;
