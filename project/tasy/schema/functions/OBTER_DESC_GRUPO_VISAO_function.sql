-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_grupo_visao ( nr_seq_visao_grupo_p tabela_visao_grupo.nr_sequencia%type, nr_seq_visao_subgrupo_p tabela_visao_grupo.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    dic_expressao_idioma.ds_expressao%type;
ds_subgrupo_w   dic_expressao_idioma.ds_expressao%type;


BEGIN

	if (nr_seq_visao_grupo_p IS NOT NULL AND nr_seq_visao_grupo_p::text <> '') then

		select	max(obter_desc_expressao(cd_exp_titulo))
		into STRICT	ds_retorno_w
		from	tabela_visao_grupo
		where	nr_sequencia = nr_seq_visao_grupo_p;
	
    end if;

    if (nr_seq_visao_subgrupo_p IS NOT NULL AND nr_seq_visao_subgrupo_p::text <> '') then

        select      max(obter_desc_expressao(cd_exp_titulo))
        into STRICT        ds_subgrupo_w
        from        tabela_visao_grupo
        where       nr_sequencia = nr_seq_visao_subgrupo_p;

        ds_retorno_w := ds_retorno_w || ' - ' || ds_subgrupo_w;

    end if;

	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_grupo_visao ( nr_seq_visao_grupo_p tabela_visao_grupo.nr_sequencia%type, nr_seq_visao_subgrupo_p tabela_visao_grupo.nr_sequencia%type default null) FROM PUBLIC;

