-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_acompanhamento_meta ( dt_mes_competencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_equipe_w			bigint;
nr_seq_vendedor_w		bigint;
dt_referencia_w			timestamp;
qt_meta_global_w		bigint;
qt_meta_pf_w			bigint;
qt_meta_pj_w			bigint;
qt_atual_global_w		bigint;
qt_atual_pf_w			bigint;
qt_atual_pj_w			bigint;
pr_meta_global_w		double precision;
pr_meta_pf_w			double precision;
pr_meta_pj_w			double precision;
qt_atual_pago_w			bigint;
dt_mes_competencia_w		timestamp;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_equipe_vendedor	a
	where	cd_estabelecimento	= cd_estabelecimento_p;

C02 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_vendedor		b,
		pls_equipe_vend_vinculo	a
	where	a.nr_seq_vendedor	= b.nr_sequencia
	and	a.nr_seq_equipe		= nr_seq_equipe_w
	and	dt_mes_competencia_w between coalesce(a.dt_inicio_vigencia,dt_mes_competencia_w) and coalesce(a.dt_fim_vigencia,dt_mes_competencia_w);


BEGIN

dt_mes_competencia_w := trunc(dt_mes_competencia_p,'month');

delete	FROM pls_acompanhamento_venda
where	trunc(dt_referencia,'month') = dt_mes_competencia_w;

open C01;
loop
fetch C01 into
	nr_seq_equipe_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_vendedor_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		qt_atual_global_w	:= 0;
		pr_meta_global_w	:= 0;
		qt_atual_pf_w		:= 0;
		pr_meta_pf_w		:= 0;
		qt_atual_pj_w		:= 0;
		pr_meta_pj_w		:= 0;

		qt_meta_global_w	:= pls_qt_metas_canal_vendas(nr_seq_equipe_w,nr_seq_vendedor_w,dt_mes_competencia_w,'G');
		qt_meta_pf_w		:= pls_qt_metas_canal_vendas(nr_seq_equipe_w,nr_seq_vendedor_w,dt_mes_competencia_w,'PF');
		qt_meta_pj_w		:= pls_qt_metas_canal_vendas(nr_seq_equipe_w,nr_seq_vendedor_w,dt_mes_competencia_w,'PJ');

		qt_atual_pf_w		:= pls_obter_resumo_equipe_canal(nr_seq_vendedor_w,dt_mes_competencia_w,'PF');
		qt_atual_pj_w		:= pls_obter_resumo_equipe_canal(nr_seq_vendedor_w,dt_mes_competencia_w,'PJ');
		qt_atual_global_w	:= coalesce(qt_atual_pf_w,0) + coalesce(qt_atual_pj_w,0);

		begin
		if (qt_meta_global_w	<> 0) then
			pr_meta_global_w	:= dividir(qt_atual_global_w*100,qt_meta_global_w);
		else
			pr_meta_global_w	:= 0;
		end if;
		exception
		when others then
			pr_meta_global_w	:= 999;
		end;

		begin
		if (qt_meta_pf_w	<> 0) then
			pr_meta_pf_w	:= dividir(qt_atual_pf_w*100,qt_meta_pf_w);
		else
			pr_meta_pf_w	:= 0;
		end if;
		exception
		when others then
			pr_meta_pf_w	:= 999;
		end;

		begin
		if (qt_meta_pj_w	<> 0) then
			pr_meta_pj_w	:= dividir(qt_atual_pj_w*100,qt_meta_pj_w);
		else
			pr_meta_pj_w	:= 0;
		end if;
		exception
		when others then
			pr_meta_pj_w	:= 999;
		end;

		qt_atual_pago_w	:= pls_obter_resumo_equipe_canal(nr_seq_vendedor_w,dt_mes_competencia_w,'GP');

		insert into pls_acompanhamento_venda(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_equipe,nr_seq_vendedor,dt_referencia,qt_meta_global,qt_meta_pf,
				qt_meta_pj,qt_atual_global,qt_atual_pf,qt_atual_pj,pr_meta_global,
				pr_meta_pf,pr_meta_pj,qt_atual_pago)
		values (	nextval('pls_acompanhamento_venda_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				nr_seq_equipe_w,nr_seq_vendedor_w,dt_mes_competencia_w,qt_meta_global_w,qt_meta_pf_w,
				qt_meta_pj_w,qt_atual_global_w,qt_atual_pf_w,qt_atual_pj_w,pr_meta_global_w,
				pr_meta_pf_w,pr_meta_pj_w,qt_atual_pago_w);

		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_acompanhamento_meta ( dt_mes_competencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

