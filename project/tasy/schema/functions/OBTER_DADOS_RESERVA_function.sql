-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_reserva ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


cd_setor_atendimento_w	integer;
cd_unidade_basica_w	varchar(10);
cd_unidade_compl_w	varchar(10);


BEGIN

select	cd_setor_atendimento,
	cd_unidade_basica,
	cd_unidade_compl
into STRICT	cd_setor_atendimento_w,
	cd_unidade_basica_w,
	cd_unidade_compl_w
from	unidade_atendimento
where	cd_paciente_reserva	=	cd_pessoa_fisica_p
and	dt_atualizacao		=	(	SELECT	max(dt_atualizacao)
						from	unidade_atendimento
						where	cd_paciente_reserva = cd_pessoa_fisica_p);

return	obter_nome_setor(cd_setor_atendimento_w) || ' ' || cd_unidade_basica_w || ' ' || cd_unidade_compl_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_reserva ( cd_pessoa_fisica_p text) FROM PUBLIC;
