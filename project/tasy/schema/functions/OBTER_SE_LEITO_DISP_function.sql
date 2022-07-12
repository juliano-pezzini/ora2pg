-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_leito_disp (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS varchar AS $body$
DECLARE


ie_temporario_w		varchar(01);
ie_status_unidade_w	varchar(03);
ie_disponivel_w		varchar(01);


BEGIN

select	ie_temporario,
	ie_status_unidade
into STRICT	ie_temporario_w,
	ie_status_unidade_w
from	unidade_atendimento
where	cd_setor_atendimento	= cd_setor_atendimento_p
and	cd_unidade_basica	= cd_unidade_basica_p
and	cd_unidade_compl	= cd_unidade_compl_p;


if (ie_status_unidade_w	in ('I', 'A', 'O', 'H', 'R','M')) then
	ie_disponivel_w		:= 'N';
elsif (ie_temporario_w	= 'S') then
	begin

	if (ie_status_unidade_w	= 'L') then
		ie_disponivel_w		:= 'S';
	elsif (ie_status_unidade_w	= 'P') then
		ie_disponivel_w		:= 'N';
	end if;


	end;
else
	begin

	if (ie_status_unidade_w	= 'L') then
		ie_disponivel_w		:= 'S';
	elsif (ie_status_unidade_w	= 'P') then
		ie_disponivel_w		:= 'N';
	end if;


	end;
end if;

return	ie_disponivel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_leito_disp (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;
