-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_gestao_vaga_local ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS varchar AS $body$
DECLARE


dt_retorno_w 		varchar(255);
cd_paciente_reserva_w	varchar(10);
nm_pac_reserva_w	varchar(255);


BEGIN

dt_retorno_w := null;

select 	max(cd_paciente_reserva),
	max(nm_pac_reserva)
into STRICT	cd_paciente_reserva_w,
	nm_pac_reserva_w
from 	unidade_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p
and	cd_unidade_basica = cd_unidade_basica_p
and	cd_unidade_compl = cd_unidade_compl_p;


if (cd_paciente_reserva_w IS NOT NULL AND cd_paciente_reserva_w::text <> '') or (nm_pac_reserva_w IS NOT NULL AND nm_pac_reserva_w::text <> '') then

	select	max(coalesce(obter_nome_setor(CD_SETOR_ATUAL),obter_valor_dominio(1492,IE_LOCAL_AGUARDA)))
	into STRICT	dt_retorno_w
	from 	gestao_vaga
	where	cd_setor_desejado 	= cd_setor_atendimento_p
	and		cd_unidade_basica 	= cd_unidade_basica_p
	and		cd_unidade_compl 	= cd_unidade_compl_p
	and 	ie_status in ('A','R');
end if;


return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_gestao_vaga_local ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;

