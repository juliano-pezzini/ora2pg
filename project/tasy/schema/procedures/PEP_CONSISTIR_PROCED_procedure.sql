-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_consistir_proced ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ds_retorno_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

ie_situacao_w	varchar(1) := 'A';

BEGIN

if (consistir_idade_paciente_proc(cd_pessoa_fisica_p, cd_procedimento_p, ie_origem_proced_p) = 'N') then
	--A idade do paciente está fora do período mín/máx do procedimento. - 326062
	ds_retorno_p := obter_texto_tasy(326062,wheb_usuario_pck.get_nr_seq_idioma);
else
	select 	coalesce(max(ie_situacao),'A') ie_situacao
	into STRICT	ie_situacao_w
	from 	procedimento
	where	cd_procedimento 	= cd_procedimento_p
	and   	ie_origem_proced 	= ie_origem_proced_p;
	if (ie_situacao_w = 'I') then
		--Este procedimento está inativo. Não pode ser prescrito. - 326063
		ds_retorno_p := obter_texto_tasy(326063,wheb_usuario_pck.get_nr_seq_idioma);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_consistir_proced ( cd_pessoa_fisica_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ds_retorno_p INOUT text, nm_usuario_p text) FROM PUBLIC;
