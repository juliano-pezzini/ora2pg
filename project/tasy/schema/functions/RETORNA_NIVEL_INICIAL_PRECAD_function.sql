-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_nivel_inicial_precad (ie_tipo_precadastro_p text, cd_tipo_pessoa_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


retorno_w smallint := null;


BEGIN

	if (ie_tipo_precadastro_p != 'MAT') then
		select min(pa.nr_nivel)
		into STRICT retorno_w
		from processo_avaliacao pa 
		where pa.CD_TIPO_PESSOA = cd_tipo_pessoa_p
		and   pa.IE_TIPO_PROCESSO = ie_tipo_precadastro_p
		and exists (SELECT nr_sequencia 
						from USUARIO_PROCESSO_AVAL usu
						where pa.nr_sequencia = USU.NR_PROCESSO_AVAL);
	else
		select min(pa.nr_nivel)
		into STRICT retorno_w
		from processo_avaliacao pa 
		where   pa.IE_TIPO_PROCESSO = ie_tipo_precadastro_p
		and exists (SELECT nr_sequencia 
						from USUARIO_PROCESSO_AVAL usu
						where pa.nr_sequencia = USU.NR_PROCESSO_AVAL);
	end if;

	
	return retorno_w;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_nivel_inicial_precad (ie_tipo_precadastro_p text, cd_tipo_pessoa_p bigint, nm_usuario_p text) FROM PUBLIC;
