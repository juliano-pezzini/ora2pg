-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_regra_ordem_servico ( ie_opcao_p text, cd_estab_regra_p bigint) RETURNS varchar AS $body$
DECLARE


/*
NR_GRUPO_PLANEJ - GP
NR_GRUPO_TRABALHO  -  GT
NR_SEQ_EQUIPAMENTO - NE
NR_SEQ_LOCALIZACAO - NL
NR_SEQ_ESTAGIO - NT
*/
nr_grupo_planej_w		pcs_regra_ordem_servico.nr_grupo_planej%type;
nr_grupo_trabalho_w		pcs_regra_ordem_servico.nr_grupo_trabalho%type;
nr_seq_equipamento_w		pcs_regra_ordem_servico.nr_seq_equipamento%type;
nr_seq_localizacao_w		pcs_regra_ordem_servico.nr_seq_localizacao%type;
nr_seq_estagio_w		pcs_regra_ordem_servico.nr_seq_estagio%type;
ds_retorno_w			varchar(255);


BEGIN

if (ie_opcao_p = 'GP')  then

	select	max(nr_grupo_planej)
	into STRICT	nr_grupo_planej_w
	from	pcs_regra_ordem_servico
	where	cd_estab_regra = cd_estab_regra_p;

	ds_retorno_w := nr_grupo_planej_w;

elsif (ie_opcao_p = 'GT') then

	select	max(nr_grupo_trabalho)
	into STRICT	nr_grupo_trabalho_w
	from	pcs_regra_ordem_servico
	where	cd_estab_regra = cd_estab_regra_p;

	ds_retorno_w := nr_grupo_trabalho_w;

elsif (ie_opcao_p = 'NE') then

	select	max(nr_seq_equipamento)
	into STRICT	nr_seq_equipamento_w
	from	pcs_regra_ordem_servico
	where	cd_estab_regra = cd_estab_regra_p;

	ds_retorno_w := nr_seq_equipamento_w;

elsif (ie_opcao_p = 'NL') then

	select	max(nr_seq_localizacao)
	into STRICT	nr_seq_localizacao_w
	from	pcs_regra_ordem_servico
	where	cd_estab_regra = cd_estab_regra_p;

	ds_retorno_w := nr_seq_localizacao_w;

elsif (ie_opcao_p = 'NT') then

	select	max(nr_seq_estagio)
	into STRICT	nr_seq_estagio_w
	from	pcs_regra_ordem_servico
	where	cd_estab_regra = cd_estab_regra_p;

	ds_retorno_w := nr_seq_estagio_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_regra_ordem_servico ( ie_opcao_p text, cd_estab_regra_p bigint) FROM PUBLIC;

