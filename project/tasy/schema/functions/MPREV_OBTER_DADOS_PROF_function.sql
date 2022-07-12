-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_dados_prof (cd_pessoa_fisica_p bigint, dt_referencia_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar diferentes informações com relação ao profissional da medicina preventiva.
Usada em campos function do dicionario de dados.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: MedPrev - Programas de Promoção a Saúde
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(255);
ds_funcoes_w	varchar(255);
ds_equipes_w	varchar(255);
ds_situacao_w	varchar(10);

/*
ie_opcao_p
'IE' = Retorna se o profissional está ativo em alguma equipe
'EQ' = Retorna as equipes em que o profissional está ativo
'FN' = Retorna as funções ativas do profissional
*/
C01 CURSOR FOR
	SELECT	distinct
		y.nm_funcao
	from	mprev_funcao_colaborador y,
		mprev_equipe_profissional x,
		mprev_equipe z
	where	z.nr_sequencia	= x.nr_seq_equipe
	and	z.ie_situacao = 'A'
	and	y.nr_sequencia = x.nr_seq_funcao
	and	x.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	clock_timestamp() between x.dt_inclusao and coalesce(x.dt_exclusao,clock_timestamp());

C02 CURSOR FOR
	SELECT	distinct
		mprev_obter_dados_equipe(x.nr_seq_equipe, clock_timestamp(), 'NM') nm_equipe
	from	mprev_funcao_colaborador y,
		mprev_equipe_profissional x,
		mprev_equipe z
	where	z.nr_sequencia	= x.nr_seq_equipe
	and	z.ie_situacao = 'A'
	and	y.nr_sequencia = x.nr_seq_funcao
	and	x.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	clock_timestamp() between x.dt_inclusao and coalesce(x.dt_exclusao,clock_timestamp());

C03 CURSOR FOR
	SELECT	distinct
		mprev_obter_situacao_funcao(x.dt_inclusao, x.dt_exclusao, clock_timestamp(), 'S')
	from	mprev_funcao_colaborador y,
		mprev_equipe_profissional x
	where	y.nr_sequencia = x.nr_seq_funcao
	and	x.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	clock_timestamp() between y.dt_inclusao and coalesce(y.dt_exclusao,clock_timestamp());


BEGIN

if (upper(ie_opcao_p) = 'IE')then

	open C03;
	loop
	fetch C03 into
		ds_equipes_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
			if (ds_equipes_w = 'Ativo') then
				ds_retorno_w := ds_equipes_w;
			elsif (ds_retorno_w <> 'Ativo')
			or (coalesce(ds_retorno_w::text, '') = '')then
				ds_retorno_w := ds_equipes_w;
			end if;
		end;
	end loop;
	close C03;

elsif (upper(ie_opcao_p) = 'EQ')then

	open C02;
	loop
	fetch C02 into
		ds_equipes_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w := substr(ds_retorno_w || ', ' || ds_equipes_w,1,255);
				exit when length(ds_retorno_w) >= 254;
			elsif (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w := ds_equipes_w;
			end if;
		end;
	end loop;
	close C02;

elsif (upper(ie_opcao_p) = 'FN')then

	open C01;
	loop
	fetch C01 into
		ds_funcoes_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w := substr(ds_retorno_w || ', ' || ds_funcoes_w,1,255);
				exit when length(ds_retorno_w) >= 254;
			elsif (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w := ds_funcoes_w;
			end if;
		end;
	end loop;
	close C01;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_dados_prof (cd_pessoa_fisica_p bigint, dt_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;

