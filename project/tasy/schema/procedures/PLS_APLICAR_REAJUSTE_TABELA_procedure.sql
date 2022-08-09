-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_reajuste_tabela ( cd_tabela_servico_p bigint, vl_reajuste_p bigint, dt_inicio_vigencia_p timestamp, ds_observacao_p text, ie_opcao_p text default 'S', nm_usuario_p text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, ie_tipo_tabela_p bigint DEFAULT NULL, ie_replica_proc_p text default 'N') AS $body$
DECLARE


cd_estabelecimento_w		smallint;
cd_tabela_servico_w		smallint;
cd_procedimento_w		bigint;
dt_inicio_vigencia_w		timestamp;
vl_servico_w			double precision;
vl_reajustado_w			double precision;
ie_origem_proced_w		bigint;
nr_seq_log_w			bigint;
vl_anestesista_reajustado_w	double precision;
vl_auxiliares_reajustado_w	double precision;
vl_custo_operacional_reaj_w	double precision;
vl_filme_reajustado_w		double precision;
vl_medico_reajustado_w		double precision;
vl_procedimento_reajustado_w	double precision;
ie_tipo_tabela_w		smallint;

C01 CURSOR FOR
	SELECT	max(cd_estabelecimento),
		max(cd_tabela_servico),
		max(cd_procedimento),
		max(dt_inicio_vigencia),
		max(vl_servico),
		max(ie_origem_proced)
	from	preco_servico
	where	cd_tabela_servico	= cd_tabela_servico_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(dt_vigencia_final::text, '') = ''
	and	dt_inicio_vigencia  	< dt_inicio_vigencia_p
	group by
		cd_procedimento;

C02 CURSOR(	cd_tabela_pc		preco_tuss.cd_edicao_amb%type,
		dt_inicio_vigencia_pc	timestamp) FOR
	SELECT	a.cd_edicao_amb,
		a.cd_procedimento,
		a.dt_inicio_vigencia,
		a.vl_anestesista,
		a.vl_auxiliares,
		a.vl_custo_operacional,
		a.vl_filme,
		a.vl_medico,
		a.vl_procedimento,
		a.ie_origem_proced
	from	preco_tuss	a
	where	a.cd_edicao_amb		= cd_tabela_pc
	and	coalesce(a.dt_final_vigencia::text, '') = ''
	and	a.dt_inicio_vigencia  	= (SELECT 	max(b.dt_inicio_vigencia)
					   from		preco_tuss b
					   where	b.cd_edicao_amb	= cd_tabela_pc
					   and		a.cd_procedimento	= b.cd_procedimento
					   and		a.ie_origem_proced	= b.ie_origem_proced
					   and		coalesce(b.dt_final_vigencia::text, '') = ''
					   and		b.dt_inicio_vigencia	< dt_inicio_vigencia_pc );

BEGIN

	select	coalesce(ie_tipo_tabela_p, 1)
	into STRICT	ie_tipo_tabela_w
	;

if ( ie_tipo_tabela_w = 1 ) then
	open C01;
	loop
	fetch C01 into
		cd_estabelecimento_w,
		cd_tabela_servico_w,
		cd_procedimento_w,
		dt_inicio_vigencia_w,
		vl_servico_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		vl_reajustado_w	:= vl_servico_w + ((vl_servico_w * vl_reajuste_p) / 100);

		insert 	into preco_servico(	cd_estabelecimento, cd_tabela_servico, cd_procedimento,
				dt_inicio_vigencia, vl_servico, cd_moeda,
				dt_atualizacao, nm_usuario, ie_origem_proced,
				cd_unidade_medida, dt_atualizacao_nrec, nm_usuario_nrec,
				dt_inativacao, dt_vigencia_final)
			(	SELECT	cd_estabelecimento, cd_tabela_servico, cd_procedimento,
				dt_inicio_vigencia_p, vl_reajustado_w, cd_moeda,
				clock_timestamp(), nm_usuario_p, ie_origem_proced,
				cd_unidade_medida, clock_timestamp(), nm_usuario_p,
				null, null
				from	preco_servico
				where	cd_estabelecimento	= cd_estabelecimento_w
				and		cd_tabela_servico	= cd_tabela_servico_w
				and		cd_procedimento		= cd_procedimento_w
				and		dt_inicio_vigencia	= dt_inicio_vigencia_w
				and		coalesce(dt_vigencia_final::text, '') = ''
				and		ie_origem_proced	= ie_origem_proced_w);

		update	preco_servico
		set	dt_vigencia_final		= (dt_inicio_vigencia_p -1)
		where	cd_estabelecimento		= cd_estabelecimento_w
		and	cd_tabela_servico		= cd_tabela_servico_w
		and	cd_procedimento			= cd_procedimento_w
		and	ie_origem_proced		= ie_origem_proced_w
		and	dt_inicio_vigencia		< dt_inicio_vigencia_p
		and	coalesce(dt_vigencia_final::text, '') = '';

		end;
	end loop;
	close C01;

	insert into	tabela_servico_log(	nr_sequencia,cd_tabela_servico, cd_estabelecimento, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				dt_log, ds_log )
	values		(	nextval('tabela_servico_log_seq'), cd_tabela_servico_p, cd_estabelecimento_p, clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				clock_timestamp(),'Aplicação de ajuste de preço de '||(vl_reajuste_p)||' % Observação : '||ds_observacao_p) returning nr_sequencia into nr_seq_log_w;
	commit;

elsif ( ie_tipo_tabela_w = 2 ) then

	for r_c02_w in C02( cd_tabela_servico_p, dt_inicio_vigencia_p ) loop

		vl_anestesista_reajustado_w		:= r_c02_w.vl_anestesista + ((r_c02_w.vl_anestesista * vl_reajuste_p) / 100);
		vl_auxiliares_reajustado_w		:= r_c02_w.vl_auxiliares + ((r_c02_w.vl_auxiliares * vl_reajuste_p) / 100);
		vl_custo_operacional_reaj_w		:= r_c02_w.vl_custo_operacional + ((r_c02_w.vl_custo_operacional * vl_reajuste_p) / 100);
		vl_filme_reajustado_w			:= r_c02_w.vl_filme + ((r_c02_w.vl_filme * vl_reajuste_p) / 100);
		vl_medico_reajustado_w			:= r_c02_w.vl_medico + ((r_c02_w.vl_medico * vl_reajuste_p) / 100);
		vl_procedimento_reajustado_w		:= r_c02_w.vl_procedimento + ((r_c02_w.vl_procedimento * vl_reajuste_p) / 100);
		if (ie_replica_proc_p = 'S') then
			vl_procedimento_reajustado_w	:= 	coalesce(vl_anestesista_reajustado_w,0) + coalesce(vl_auxiliares_reajustado_w,0) + coalesce(vl_custo_operacional_reaj_w,0) +
								coalesce(vl_filme_reajustado_w,0) + coalesce(vl_medico_reajustado_w,0);
		end if;
		insert 	into preco_tuss(	cd_edicao_amb, cd_moeda, cd_porte_cbhpm,
				cd_procedimento, dt_atualizacao, dt_atualizacao_nrec,
				dt_final_vigencia, dt_inicio_vigencia, ie_origem_proced,
				ie_situacao, nm_usuario, nm_usuario_nrec,
				nr_auxiliares_amb, nr_auxiliares_cbhpm, nr_porte_anest_amb,
				nr_porte_anest_cbhpm, nr_sequencia, qt_filme_amb,
				qt_filme_cbhpm, qt_incidencia_amb, qt_incidencia_cbhpm,
				qt_uco, tx_porte, vl_anestesista,
				vl_auxiliares, vl_custo_operacional, vl_filme,
				vl_medico, vl_procedimento)
			(	SELECT	cd_edicao_amb, cd_moeda, cd_porte_cbhpm,
					cd_procedimento, clock_timestamp(), clock_timestamp(),
					dt_final_vigencia, dt_inicio_vigencia_p, ie_origem_proced,
					ie_situacao, nm_usuario_p, nm_usuario_p,
					nr_auxiliares_amb, nr_auxiliares_cbhpm, nr_porte_anest_amb,
					nr_porte_anest_cbhpm, nextval('preco_tuss_seq'), qt_filme_amb,
					qt_filme_cbhpm, qt_incidencia_amb, qt_incidencia_cbhpm,
					qt_uco, tx_porte, vl_anestesista_reajustado_w,
					vl_auxiliares_reajustado_w, vl_custo_operacional_reaj_w, vl_filme_reajustado_w,
					vl_medico_reajustado_w, vl_procedimento_reajustado_w
				from	preco_tuss
				where	cd_edicao_amb		= r_c02_w.cd_edicao_amb
				and	cd_procedimento		= r_c02_w.cd_procedimento
				and	dt_inicio_vigencia	= r_c02_w.dt_inicio_vigencia
				and	coalesce(dt_final_vigencia::text, '') = ''
				and	ie_origem_proced	= r_c02_w.ie_origem_proced );

		update	preco_tuss
		set	dt_final_vigencia	= (dt_inicio_vigencia_p -1)
		where	cd_edicao_amb		= r_c02_w.cd_edicao_amb
		and	cd_procedimento		= r_c02_w.cd_procedimento
		and	ie_origem_proced	= r_c02_w.ie_origem_proced
		and	dt_inicio_vigencia	< dt_inicio_vigencia_p
		and	coalesce(dt_final_vigencia::text, '') = '';

	end loop;

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_reajuste_tabela ( cd_tabela_servico_p bigint, vl_reajuste_p bigint, dt_inicio_vigencia_p timestamp, ds_observacao_p text, ie_opcao_p text default 'S', nm_usuario_p text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, ie_tipo_tabela_p bigint DEFAULT NULL, ie_replica_proc_p text default 'N') FROM PUBLIC;
