-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_situacao_leito (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS varchar AS $body$
DECLARE


ie_situacao_w 	varchar(1);


BEGIN

	select coalesce(max(ie_situacao),'I')
	into STRICT   ie_situacao_w
	from   unidade_atendimento
	where  cd_setor_atendimento = cd_setor_atendimento_p
	and    cd_unidade_basica = cd_unidade_basica_p
	and    cd_unidade_compl = cd_unidade_compl_p;

return	ie_situacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_situacao_leito (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;

