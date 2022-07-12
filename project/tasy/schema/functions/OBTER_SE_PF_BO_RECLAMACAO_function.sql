-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_bo_reclamacao ( cd_pessoa_fisica_p bigint, nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p	= utilizado para o parâmetro [197] da ocupação hospitalar.
*/
ds_retorno_w 		varchar(1) 	:= null;
qt_reclamacao_w		double precision 	:= 0;
nr_seq_w		double precision 	:= 0;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_opcao_p = 'N' or coalesce(ie_opcao_p::text, '') = '') then
	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from   	sac_classif_ocorrencia c,
		sac_boletim_ocorrencia a,
		sac_resp_bol_ocor b
	where  	a.nr_sequencia 		= b.nr_seq_bo
	and	b.nr_seq_classif	= c.nr_sequencia
	and	c.ie_tipo_classif	= 'R'
	and	a.cd_pessoa_fisica 	= cd_pessoa_fisica_p
	and	a.nr_atendimento	= nr_atendimento_p;
end if;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_opcao_p = 'S')then
	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from   	sac_classif_ocorrencia c,
		sac_boletim_ocorrencia a,
		sac_resp_bol_ocor b
	where  	a.nr_sequencia 		= b.nr_seq_bo
	and	b.nr_seq_classif	= c.nr_sequencia
	and	c.ie_tipo_classif	= 'R'
	and	a.cd_pessoa_fisica 	= cd_pessoa_fisica_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_bo_reclamacao ( cd_pessoa_fisica_p bigint, nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

