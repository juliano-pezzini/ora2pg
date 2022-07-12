-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_inicia_servico ( cd_estabelecimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_w			bigint;
ie_retorno_w			varchar(1);


BEGIN

begin
	select	count(*)
	into STRICT	qt_registro_w
	from	unidade_atendimento a,
			sl_unid_atend b
	where	b.nr_seq_unidade 		= a.nr_seq_interno
	and	b.cd_estabelecimento 		= cd_estabelecimento_p
	and	a.cd_unidade_basica		= cd_unidade_basica_p
	and	a.cd_unidade_compl		= cd_unidade_compl_p
	and	a.cd_setor_atendimento		= cd_setor_atendimento_p
	and	(b.dt_inicio IS NOT NULL AND b.dt_inicio::text <> '')
	and	coalesce(b.dt_fim::text, '') = ''
	and	b.ie_status_serv <> 'C';
exception
	when others then
	qt_registro_w			:= 0;
end;

if (qt_registro_w > 0) then
	ie_retorno_w	:= 'S';
else
	ie_retorno_w	:= 'N';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_inicia_servico ( cd_estabelecimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint) FROM PUBLIC;

