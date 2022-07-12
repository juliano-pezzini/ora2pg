-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_se_exibe_lib_pend ( ie_tipo_item_p text, ie_lib_pend_p text, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_item_w		varchar(15);
ie_lib_medico_w		varchar(1);
ie_lib_enfermagem_w	varchar(1);
ie_lib_farmacia_w	varchar(1);
ie_exibe_w		varchar(1) := 'S';


BEGIN

select	case	ie_tipo_item_p
	when 'D'   then '2'
	when 'O'   then '3'
	when 'HM'  then '4'
	when 'J'   then '5'
	when 'MAT' then '6'
	when 'M'   then '7'
	when 'NAN' then '8'
	when 'NPN' then '9'
	when 'P'   then '12'
	when 'R'   then '13'
	when 'SNE' then '14'
	when 'S'   then '15'
	when 'SOL' then '16'
	when 'G'   then '18'
	when 'C'   then '18'
	when 'I'   then '19'
	when 'L'   then '20'
	when 'LD'  then '21' else ''
	end
into STRICT	ie_tipo_item_w
;

if (ie_tipo_item_w IS NOT NULL AND ie_tipo_item_w::text <> '') then

	select	coalesce(max(ie_lib_medico),'S'),
		coalesce(max(ie_lib_enfermagem),'S'),
		coalesce(max(ie_lib_farmacia),'S')
	into STRICT	ie_lib_medico_w,
		ie_lib_enfermagem_w,
		ie_lib_farmacia_w
	from	regra_lib_rep_pt
	where	ie_tipo_item = ie_tipo_item_w
	and	((coalesce(cd_perfil::text, '') = '') or (cd_perfil = cd_perfil_p));

	if (ie_lib_pend_p	= 'M') then
		ie_exibe_w	:= ie_lib_medico_w;
	elsif (ie_lib_pend_p	= 'E') then
		ie_exibe_w	:= ie_lib_enfermagem_w;
	elsif (ie_lib_pend_p	= 'F') then
		ie_exibe_w	:= ie_lib_farmacia_w;
	else
		ie_exibe_w	:= 'S';
	end if;

end if;

return	ie_exibe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_se_exibe_lib_pend ( ie_tipo_item_p text, ie_lib_pend_p text, cd_perfil_p bigint) FROM PUBLIC;

