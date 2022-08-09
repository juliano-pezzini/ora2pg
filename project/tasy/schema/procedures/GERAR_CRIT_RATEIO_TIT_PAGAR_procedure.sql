-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_crit_rateio_tit_pagar ( nr_seq_criterio_p bigint, nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_vigencia_w		timestamp;
vl_titulo_w		double precision;
nr_sequencia_w		bigint;
pr_rateio_w		double precision;
vl_rateio_w		double precision;
cd_centro_custo_w		bigint;
cd_conta_contabil_w	varchar(255);
cd_conta_financ_w		bigint;
ds_erro_w		varchar(4000);
vl_soma_w		double precision := 0;
count_w			bigint := 0;
qtd_item_pr_w		bigint := 0;

c02 CURSOR FOR
	SELECT	a.cd_centro_custo,
		a.cd_conta_contabil,
		a.cd_conta_financ,
		a.pr_rateio
	from	ctb_criterio_rateio_item	a
	where	a.nr_seq_criterio 	= nr_seq_criterio_p
	and	coalesce(a.pr_rateio,0)	> 0
	and (dt_vigencia_w 	>= coalesce(a.dt_inicio_vigencia,dt_vigencia_w) and dt_vigencia_w <= coalesce(a.dt_fim_vigencia,dt_vigencia_w))
	order by
		a.pr_rateio;


BEGIN
select	max(coalesce(a.vl_saldo_titulo,0)),
	max(dt_emissao)
into STRICT	vl_titulo_w,
	dt_vigencia_w
from	titulo_receber	a
where	a.nr_titulo	= nr_titulo_p
and (exists (	SELECT	1
		from	titulo_receber_liq	c
		where	c.nr_titulo	= a.nr_titulo
		and	exists (	select	1
				from	titulo_receber_liq	x
				where	c.nr_sequencia	= x.nr_seq_liq_origem
				and	x.nr_titulo	= c.nr_titulo))
or	not exists (select	1
			from	titulo_receber_liq	c
			where	c.nr_titulo	= a.nr_titulo))
and	not exists (select	1
			from	alteracao_valor	d
			where	d.nr_titulo	= a.nr_titulo);

select	coalesce(count(*),0)	-- AAMFIRMO OS 658893 - Criei esse contador para saber quantos itens existe no critério da regra utilizada.
into STRICT	qtd_item_pr_w
from	ctb_criterio_rateio_item	a
where	a.nr_seq_criterio	= nr_seq_criterio_p
and	coalesce(a.pr_rateio,0)	> 0
and (dt_vigencia_w 	>= coalesce(a.dt_inicio_vigencia,dt_vigencia_w) and dt_vigencia_w <= coalesce(a.dt_fim_vigencia,dt_vigencia_w));

if (coalesce(vl_titulo_w, 0) > 0) then
	open c02;
	loop
	fetch c02 into
		cd_centro_custo_w,
		cd_conta_contabil_w,
		cd_conta_financ_w,
		pr_rateio_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select	coalesce(max(a.nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	titulo_receber_classif	a
		where	a.nr_titulo	= nr_titulo_p;

		vl_rateio_w	:= dividir((vl_titulo_w * pr_rateio_w), 100);

		vl_soma_w	:= coalesce(vl_soma_w,0) + coalesce(vl_rateio_w,0); -- AAMFIRMO OS 658893 - Variável de controle que vai somando todos os valores de rateio.
		count_w		:= coalesce(count_w,0) + 1; -- AAMFIRMO OS 658893 - Variável de controle, para verificar qual será o último item a ser incluido.
		if (count_w = qtd_item_pr_w) then -- AAMFIRMO OS 658893 - Se o item a ser lançado for igual ao total de itens, ou seja, o ultimo, ele verifica  se o valor de rateio está maior ou menor que o valor do titulo, para ajustar
			if (vl_soma_w > vl_titulo_w) then
				vl_rateio_w :=  vl_rateio_w - (vl_soma_w - vl_titulo_w);
			elsif (vl_soma_w < vl_titulo_w) then
				vl_rateio_w :=  vl_rateio_w + (vl_titulo_w - vl_soma_w);
			end if;
		end if;

		begin
		insert	into titulo_receber_classif(nr_sequencia,
			nr_titulo,
			dt_atualizacao,
			nm_usuario,
			cd_centro_custo,
			cd_conta_contabil,
			cd_conta_financ,
			vl_classificacao,
			vl_desconto)
		values (nr_sequencia_w,
			nr_titulo_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_centro_custo_w,
			cd_conta_contabil_w,
			cd_conta_financ_w,
			vl_rateio_w,
			0);
		exception
		when others then
			ds_erro_w	:= SQLERRM(SQLSTATE);
			--r.aise_application_error(-20011,'Erro ao gravar o rateio do título! ' || chr(13) || 'Seq: ' || nr_sequencia_w || chr(13) || ds_erro_w);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(264859,	'nr_sequencia_w=' || nr_sequencia_w || ';' ||
									'ds_erro_w=' || ds_erro_w);
		end;
		end;
	end loop;
	close c02;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_crit_rateio_tit_pagar ( nr_seq_criterio_p bigint, nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;
