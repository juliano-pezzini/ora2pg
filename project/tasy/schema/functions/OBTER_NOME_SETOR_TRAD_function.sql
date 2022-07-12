-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_setor_trad ( cd_setor_p bigint, nr_seq_localizacao_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(100)	:= '';
cd_cnpj_w			man_localizacao.cd_cnpj%type;
nr_seq_idioma_w			pessoa_juridica.nr_seq_idioma%type;
cd_expressao_w			setor_atendimento.cd_exp_setor_atend%type;


BEGIN
if (cd_setor_p IS NOT NULL AND cd_setor_p::text <> '') then
	select	max(ds_setor_atendimento),
		max(cd_exp_setor_atend)
	into STRICT	ds_retorno_w,
		cd_expressao_w
	from	setor_atendimento
	where	cd_setor_atendimento	= cd_setor_p;

	if (nr_seq_localizacao_p IS NOT NULL AND nr_seq_localizacao_p::text <> '') then
		select	max(a.cd_cnpj)
		into STRICT	cd_cnpj_w
		from	man_localizacao	a
		where	a.nr_sequencia	= nr_seq_localizacao_p;

		if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then
			select	max(a.nr_seq_idioma)
			into STRICT	nr_seq_idioma_w
			from	pessoa_juridica	a
			where	a.cd_cgc	= cd_cnpj_w;

			if (nr_seq_idioma_w IS NOT NULL AND nr_seq_idioma_w::text <> '') then
				ds_retorno_w	:= obter_desc_expressao_idioma(	cd_expressao_w,
										ds_retorno_w,
										nr_seq_idioma_w);
			end if;
		end if;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_setor_trad ( cd_setor_p bigint, nr_seq_localizacao_p bigint) FROM PUBLIC;
