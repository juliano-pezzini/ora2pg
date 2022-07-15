-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_lote_rateio ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_referencia_p timestamp) AS $body$
DECLARE


cd_conta_origem_w		varchar(20);
cd_centro_origem_w		bigint;
cd_conta_contabil_dest_w		varchar(20);
cd_centro_custo_ww		bigint;
cd_conta_contabil_ww		varchar(20);

cd_centro_custo_dest_w		bigint;
cd_classif_credito_w		varchar(40);
cd_classif_debito_w		varchar(40);
cd_conta_contabil_w		varchar(20);
cd_conta_debito_w			varchar(40);
cd_conta_credito_w		varchar(40);
ie_debito_credito_w			varchar(01);
cd_historico_w			bigint;
cd_tipo_lote_contabil_w		bigint;
ds_observacao_w			varchar(2000);
dt_atualizacao_saldo_w		timestamp;
dt_movimento_w			timestamp;
dt_referencia_w			timestamp;
ie_lote_gerado_w			varchar(1)	:= 'N';
nr_lote_contabil_w			bigint;
nr_seq_contrapartida_w		bigint;
nr_sequencia_w			bigint;
nr_seq_regra_rateio_w		bigint;
pr_rateio_w			double precision;
pr_total_rateio_w			double precision;
vl_base_w			double precision;
vl_movimento_w			double precision;
vl_total_rateio_w			double precision;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.cd_conta_origem,
		a.cd_centro_origem,
		a.cd_historico,
		--a.dt_movimento,
		a.pr_total_rateio
from	ctb_regra_rat_contabil a
where	a.cd_estabelecimento = cd_estabelecimento_p
and		dt_referencia_p between dt_inicio_vigencia and coalesce(dt_final_vigencia,dt_referencia_p)
and	coalesce(ie_regra_rat_saldo,'N') = 'N'
order by a.nr_seq_calculo, a.nr_sequencia;

c02 CURSOR FOR
SELECT	a.cd_centro_custo,
		a.cd_conta_contabil,
		a.cd_classificacao,
		a.vl_movimento
from	ctb_saldo a
where	a.nr_seq_mes_ref	= nr_seq_mes_ref_p
and		a.cd_estabelecimento	= cd_estabelecimento_p
and		a.cd_conta_contabil	= coalesce(cd_conta_origem_w, a.cd_conta_contabil)
/*and	nvl(a.cd_centro_custo,0) = nvl(cd_centro_origem_w,0)*/

/*and	nvl(a.cd_centro_custo, nvl(cd_centro_origem_w,0)) = nvl(cd_centro_origem_w,0)*/
	-- Márcio  OS: 486261
and		(((a.cd_centro_custo = cd_centro_origem_w)
and (coalesce(cd_centro_origem_w,0) > 0))
or (coalesce(cd_centro_origem_w,0) = 0))
and		a.vl_movimento > 0
order by a.cd_conta_contabil, a.cd_centro_custo;

vet02	C02%RowType;

c03 CURSOR FOR
SELECT	coalesce(a.cd_conta_contabil_dest, cd_conta_contabil_ww),
		coalesce(a.cd_centro_custo_dest, cd_centro_custo_ww),
		a.pr_rateio
from	ctb_regra_rat_dest a
where	a.nr_seq_regra_rateio	= nr_seq_regra_rateio_w
order by 1,2;


BEGIN

dt_movimento_w := dt_referencia_p;

select	coalesce(max(campo_numerico(coalesce(vl_parametro, vl_parametro_padrao))),0)
into STRICT	cd_tipo_lote_contabil_w
from	funcao_parametro
where	cd_funcao	= 923
and		nr_sequencia	= 3;

open C01;
loop
fetch C01 into
	nr_seq_regra_rateio_w,
	cd_conta_origem_w,
	cd_centro_origem_w,
	cd_historico_w,
	--dt_movimento_w,
	pr_total_rateio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin


	if (coalesce(nr_lote_contabil_w::text, '') = '') and (cd_tipo_lote_contabil_w <> 0) then
		begin

		select	max(dt_referencia)
		into STRICT	dt_referencia_w
		from	ctb_mes_ref
		where	nr_sequencia	= nr_seq_mes_ref_p;

		if (trunc(dt_referencia_w,'mm') <>
			 trunc(dt_movimento_w,'mm')) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(260279);
		end if;

		select	coalesce(max(nr_lote_contabil),0) + 1
		into STRICT	nr_lote_contabil_w
		from	lote_contabil;

		insert into lote_contabil(
			nr_lote_contabil,
			dt_referencia,
			cd_tipo_lote_contabil,
			dt_atualizacao,
			nm_usuario,
			cd_estabelecimento,
			ie_situacao,
			vl_debito,
			vl_credito,
			dt_integracao,
			dt_atualizacao_saldo,
			dt_consistencia,
			nm_usuario_original,
			nr_seq_mes_ref,
			ie_encerramento,
			ds_observacao)
		values (	nr_lote_contabil_w,
			trunc(dt_movimento_w),
			cd_tipo_lote_contabil_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_estabelecimento_p,
			'A', 0, 0, null, null, null,
			nm_usuario_p,
			nr_seq_mes_ref_p,
			'N',
			obter_desc_expressao(779283));


		ie_lote_gerado_w	:= 'S';
		end;
	end if;
	cd_conta_contabil_w		:= '0';
	open C02;
	loop
	fetch C02 into
		vet02;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		vl_base_w		:= vet02.vl_movimento * dividir(pr_total_rateio_w,100);
		vl_total_rateio_w	:= 0;
		cd_conta_debito_w	:= '';
		cd_conta_credito_w	:= '';
		cd_classif_debito_w	:= '';
		cd_classif_credito_w	:= '';

		select	coalesce(max(ie_debito_credito),'D')
		into STRICT	ie_debito_credito_w
		from	ctb_grupo_conta b,
			conta_contabil a
		where	a.cd_grupo		= b.cd_grupo
		and	a.cd_conta_contabil	= vet02.cd_conta_contabil;


		if (ie_debito_credito_w = 'D') then
			cd_conta_credito_w	:= vet02.cd_conta_contabil;
			cd_classif_credito_w	:= substr(ctb_obter_classif_conta(cd_conta_credito_w,null,dt_movimento_w),1,40);
		else
			cd_conta_debito_w	:= vet02.cd_conta_contabil;
			cd_classif_debito_w	:= substr(ctb_obter_classif_conta(cd_conta_debito_w,null,dt_movimento_w),1,40);
		end if;

		/*Movimento de Contra-partida*/

		if (vet02.cd_conta_contabil <> cd_conta_contabil_w) then
			begin

			select	nextval('ctb_movimento_seq')
			into STRICT	nr_seq_contrapartida_w
			;

			insert into ctb_movimento(
				nr_sequencia,
				nr_lote_contabil,
				nr_seq_mes_ref,
				dt_movimento,
				vl_movimento,
				dt_atualizacao,
				nm_usuario,
				cd_historico,
				cd_conta_debito,
				cd_conta_credito,
				ds_compl_historico,
				nr_seq_agrupamento,
				ie_revisado,
				cd_estabelecimento,
				cd_classif_debito,
				cd_classif_credito)
			values (	nr_seq_contrapartida_w,
				nr_lote_contabil_w,
				nr_seq_mes_ref_p,
				dt_movimento_w,
				vl_base_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_historico_w,
				cd_conta_debito_w,
				cd_conta_credito_w,
				null,
				null,
				'N',
				cd_estabelecimento_p,
				cd_classif_debito_w,
				cd_classif_credito_w);
			end;
		else
			update	ctb_movimento
			set	vl_movimento	= vl_movimento + vl_base_w
			where	nr_Sequencia	= nr_seq_contrapartida_w;

		end if;

		if (vet02.cd_centro_custo IS NOT NULL AND vet02.cd_centro_custo::text <> '') and (nr_seq_contrapartida_w IS NOT NULL AND nr_seq_contrapartida_w::text <> '') then
			begin
			insert into ctb_movto_centro_custo(
				nr_sequencia,
				nr_seq_movimento,
				cd_centro_custo,
				dt_atualizacao,
				nm_usuario,
				vl_movimento,
				pr_rateio)
			values (	nextval('ctb_movto_centro_custo_seq'),
				nr_seq_contrapartida_w,
				vet02.cd_centro_custo,
				clock_timestamp(),
				nm_usuario_p,
				vl_base_w,
				100);
			end;
		end if;
		cd_conta_contabil_w	:= vet02.cd_conta_contabil;
		cd_conta_contabil_ww	:= vet02.cd_conta_contabil;
		cd_centro_custo_ww	:= vet02.cd_centro_custo;
		nr_sequencia_w		:= null;
		open C03;
		loop
		fetch C03 into
			cd_conta_contabil_dest_w,
			cd_centro_custo_dest_w,
			pr_rateio_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			if (coalesce(nr_sequencia_w::text, '') = '') then
				cd_conta_contabil_ww	:= '0';
			end if;

			cd_conta_debito_w		:= '';
			cd_conta_credito_w		:= '';
			cd_classif_credito_w		:= '';
			cd_classif_debito_w		:= '';
			ie_debito_credito_w		:= '';
			vl_movimento_w			:= vl_base_w * dividir(pr_rateio_w,100);
			vl_total_rateio_w		:= vl_total_rateio_w + vl_movimento_w;

			select	coalesce(max(ie_debito_credito),'D')
			into STRICT	ie_debito_credito_w
			from	ctb_grupo_conta b,
				conta_contabil a
			where	a.cd_grupo	= b.cd_grupo
			and	a.cd_conta_contabil	= cd_conta_contabil_dest_w;

			if (ie_debito_credito_w = 'D') then
				cd_conta_debito_w	:= cd_conta_contabil_dest_w;
				cd_classif_debito_w	:= substr(ctb_obter_classif_conta(cd_conta_debito_w,null,dt_movimento_w),1,40);
			else
				cd_conta_credito_w	:= cd_conta_contabil_dest_w;
				cd_classif_credito_w	:= substr(ctb_obter_classif_conta(cd_conta_credito_w,null,dt_movimento_w),1,40);
			end if;

			if (cd_conta_contabil_dest_w <> cd_conta_contabil_ww) then

				select	nextval('ctb_movimento_seq')
				into STRICT	nr_sequencia_w
				;

				insert into ctb_movimento(
					nr_sequencia,
					nr_lote_contabil,
					nr_seq_mes_ref,
					dt_movimento,
					vl_movimento,
					dt_atualizacao,
					nm_usuario,
					cd_historico,
					cd_conta_debito,
					cd_conta_credito,
					ds_compl_historico,
					nr_seq_agrupamento,
					ie_revisado,
					cd_estabelecimento,
					cd_classif_debito,
					cd_classif_credito)
				values (	nr_sequencia_w,
					nr_lote_contabil_w,
					nr_seq_mes_ref_p,
					dt_movimento_w,
					vl_movimento_w,
					clock_timestamp(),
					nm_usuario_p,
					cd_historico_w,
					cd_conta_debito_w,
					cd_conta_credito_w,
					null,
					null,
					'N',
					cd_estabelecimento_p,
					cd_classif_debito_w,
					cd_classif_credito_w);
			else
				update	ctb_movimento
				set	vl_movimento	= vl_movimento + vl_movimento_w
				where	nr_sequencia	= nr_sequencia_w;
			end if;

			if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') and (cd_centro_custo_dest_w IS NOT NULL AND cd_centro_custo_dest_w::text <> '') then

				insert into ctb_movto_centro_custo(
					nr_sequencia,
					nr_seq_movimento,
					cd_centro_custo,
					dt_atualizacao,
					nm_usuario,
					vl_movimento,
					pr_rateio)
				values (	nextval('ctb_movto_centro_custo_seq'),
					nr_sequencia_w,
					cd_centro_custo_dest_w,
					clock_timestamp(),
					nm_usuario_p,
					vl_movimento_w,
					100);
			end if;

			cd_conta_contabil_ww	:= cd_conta_contabil_dest_w;

			end;
		end loop;
		close C03;

		cd_conta_contabil_w	:= vet02.cd_conta_contabil;
		end;
	end loop;
	close C02;

	/*if	(nr_sequencia_w is not null) and
		(nr_lote_contabil_w is not null) then

		update	ctb_regra_rateio
		set	nr_lote_contabil	= nr_lote_contabil_w
		where	nr_sequencia		= nr_seq_regra_rateio_w;
	end if;*/
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_lote_rateio ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;

