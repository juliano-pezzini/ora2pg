-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE unificar_repasse_terceiro (ds_lista_repasse_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_acao_p text, dt_inicial_p timestamp, dt_final_p timestamp, dt_referencia_p timestamp, ie_tipo_data_p bigint, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_condicao_pagamento_p bigint, nr_seq_tipo_p bigint, nr_repasse_novo_p INOUT bigint) AS $body$
DECLARE


/* ie_acao_p
1 - Unificar
2 - Desfazer unificação
*/
ds_lista_repasse_w	varchar(255);
nr_repasse_terceiro_w	bigint;
nr_seq_terceiro_w	bigint;
nr_repasse_terc_novo_w	bigint;
nr_seq_item_repasse_w	bigint;
nr_seq_item_rep_novo_w	bigint;
nr_repasse_terc_unif_w	bigint;
ds_repasse_observacao_w	varchar(255);

c01 CURSOR FOR
SELECT	nr_repasse_terceiro,
	nr_seq_terceiro
from	repasse_terceiro
where	coalesce(nr_repasse_terc_unif::text, '') = ''
and	' ' || ds_lista_repasse_w || ' ' like '% ' || nr_repasse_terceiro || ' %'
and	(ds_lista_repasse_p IS NOT NULL AND ds_lista_repasse_p::text <> '');

c02 CURSOR FOR
SELECT	nr_sequencia
from	repasse_terceiro_item
where	nr_repasse_terceiro	= nr_repasse_terceiro_w
order by coalesce(nr_sequencia_item,0);

c03 CURSOR FOR
SELECT	nr_repasse_terceiro,
	nr_repasse_terc_unif
from	repasse_terceiro
where	' ' || ds_lista_repasse_w || ' ' like '% ' || nr_repasse_terc_unif || ' %'
and	(ds_lista_repasse_p IS NOT NULL AND ds_lista_repasse_p::text <> '');


BEGIN

ds_lista_repasse_w	:= ' ' || replace(ds_lista_repasse_p, ',', ' ') || ' ';

if (ie_acao_p = '1') then

	open C01;
	loop
	fetch C01 into
		nr_repasse_terceiro_w,
		nr_seq_terceiro_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (coalesce(nr_repasse_terc_novo_w::text, '') = '') then

			select	nextval('repasse_terceiro_seq')
			into STRICT	nr_repasse_terc_novo_w
			;

			/*Cria novo repasse*/

			insert into repasse_terceiro(nr_repasse_terceiro,
				cd_estabelecimento,
				nr_seq_terceiro,
				dt_mesano_referencia,
				ie_status,
				dt_atualizacao,
				nm_usuario,
				cd_convenio,
				dt_periodo_inicial,
				dt_periodo_final,
				ie_tipo_data,
				cd_condicao_pagamento,
				ds_observacao,
				ie_tipo_convenio,
				nr_seq_tipo)
			values (nr_repasse_terc_novo_w,
				cd_estabelecimento_p,
				nr_seq_terceiro_w,
				dt_referencia_p,
				'A',
				clock_timestamp(),
				nm_usuario_p,
				cd_convenio_p,
				dt_inicial_p,
				dt_final_p,
				ie_tipo_data_p,
				cd_condicao_pagamento_p,
				--'Repasse gerado pela unificação do(s) repasse(s) '||DS_LISTA_REPASSE_P,
				wheb_mensagem_pck.get_texto(304202,'DS_LISTA_REPASSE=' || DS_LISTA_REPASSE_P),
				ie_tipo_convenio_p,
				nr_seq_tipo_p);
		end if;

		/*Copia procedimentos de repasse do repasse origem para o novo repasse*/

		insert into procedimento_repasse(nr_sequencia,
			nr_seq_procedimento,
			vl_repasse,
			dt_atualizacao,
			nm_usuario,
			nr_seq_terceiro,
			nr_lote_contabil,
			nr_repasse_terceiro,
			cd_conta_contabil,
			nr_seq_trans_fin,
			vl_liberado,
			nr_seq_item_retorno,
			ie_status,
			nr_seq_origem,
			cd_regra,
			dt_liberacao,
			cd_medico,
			dt_contabil_titulo,
			nr_seq_ret_glosa,
			dt_contabil,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_partic,
			ds_observacao,
			nr_processo_aih,
			nm_usuario_lib,
			nr_interno_conta_est,
			nr_seq_criterio,
			nr_seq_trans_fin_rep_maior,
			ie_estorno,
			ie_repasse_calc,
			vl_original_repasse,
			nr_seq_regra_item,
			ie_analisado,
			nr_seq_lote_audit_hist,
			nr_seq_motivo_des,
			ie_desc_caixa)
		SELECT	nextval('procedimento_repasse_seq'),
			nr_seq_procedimento,
			vl_repasse,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_terceiro_w,
			nr_lote_contabil,
			nr_repasse_terc_novo_w,
			cd_conta_contabil,
			nr_seq_trans_fin,
			vl_liberado,
			nr_seq_item_retorno,
			ie_status,
			nr_seq_origem,
			cd_regra,
			dt_liberacao,
			cd_medico,
			dt_contabil_titulo,
			nr_seq_ret_glosa,
			dt_contabil,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_partic,
			ds_observacao,
			nr_processo_aih,
			nm_usuario_lib,
			nr_interno_conta_est,
			nr_seq_criterio,
			nr_seq_trans_fin_rep_maior,
			ie_estorno,
			ie_repasse_calc,
			vl_original_repasse,
			nr_seq_regra_item,
			ie_analisado,
			nr_seq_lote_audit_hist,
			nr_seq_motivo_des,
			ie_desc_caixa
		from	procedimento_repasse
		where	nr_repasse_terceiro	= nr_repasse_terceiro_w;

		/*Copia materiais de repasse do repasse origem para o novo repasse*/

		insert into material_repasse(nr_sequencia,
			nr_seq_material,
			vl_repasse,
			dt_atualizacao,
			nm_usuario,
			nr_seq_terceiro,
			nr_lote_contabil,
			nr_repasse_terceiro,
			cd_conta_contabil,
			nr_seq_trans_fin,
			vl_liberado,
			nr_seq_item_retorno,
			ie_status,
			nr_seq_origem,
			cd_regra,
			dt_liberacao,
			cd_medico,
			dt_contabil_titulo,
			nr_seq_ret_glosa,
			dt_contabil,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_observacao,
			nm_usuario_lib,
			nr_interno_conta_est,
			nr_seq_trans_fin_rep_maior,
			nr_seq_criterio,
			ie_estorno,
			ie_repasse_calc,
			vl_original_repasse,
			nr_seq_regra_item,
			ie_analisado,
			nr_seq_motivo_des,
			ie_desc_caixa,
			nr_seq_lote_audit_hist)
		SELECT	nextval('material_repasse_seq'),
			nr_seq_material,
			vl_repasse,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_terceiro_w,
			nr_lote_contabil,
			nr_repasse_terc_novo_w,
			cd_conta_contabil,
			nr_seq_trans_fin,
			vl_liberado,
			nr_seq_item_retorno,
			ie_status,
			nr_seq_origem,
			cd_regra,
			dt_liberacao,
			cd_medico,
			dt_contabil_titulo,
			nr_seq_ret_glosa,
			dt_contabil,
			clock_timestamp(),
			nm_usuario_p,
			ds_observacao,
			nm_usuario_lib,
			nr_interno_conta_est,
			nr_seq_trans_fin_rep_maior,
			nr_seq_criterio,
			ie_estorno,
			ie_repasse_calc,
			vl_original_repasse,
			nr_seq_regra_item,
			ie_analisado,
			nr_seq_motivo_des,
			ie_desc_caixa,
			nr_seq_lote_audit_hist
		from	material_repasse
		where	nr_repasse_terceiro	= nr_repasse_terceiro_w;

		open C02;
		loop
		fetch C02 into
			nr_seq_item_repasse_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			select	coalesce(max(nr_sequencia_item),0) + 1
			into STRICT	nr_seq_item_rep_novo_w
			from	repasse_terceiro_item
			where	nr_repasse_terceiro = nr_repasse_terc_novo_w;

			insert into repasse_terceiro_item(nr_repasse_terceiro,
				nr_sequencia_item,
				vl_repasse,
				dt_atualizacao,
				nm_usuario,
				nr_lote_contabil,
				ds_observacao,
				cd_conta_contabil,
				nr_seq_trans_fin,
				nr_seq_regra,
				cd_medico,
				nr_seq_regra_esp,
				dt_lancamento,
				cd_centro_custo,
				nr_seq_terceiro,
				dt_liberacao,
				nr_seq_trans_fin_prov,
				cd_conta_contabil_prov,
				cd_centro_custo_prov,
				nr_lote_contabil_prov,
				nr_sequencia,
				cd_conta_financ,
				cd_convenio,
				nr_seq_ret_glosa,
				nr_seq_terc_rep,
				dt_contabil,
				qt_minuto,
				nr_seq_tipo,
				nr_atendimento,
				cd_procedimento,
				ie_origem_proced,
				ie_partic_tributo,
				nr_adiant_pago,
				cd_material,
				nr_seq_tipo_valor,
				nr_seq_terc_regra_esp,
				nr_seq_terc_regra_item,
				dt_plantao,
				nr_seq_med_plantao,
				nr_interno_conta,
				nr_seq_repasse_prod,
				nr_seq_proc_interno)
			SELECT	nr_repasse_terc_novo_w,
				nr_seq_item_rep_novo_w,
				a.vl_repasse,
				clock_timestamp(),
				nm_usuario_p,
				a.nr_lote_contabil,
				a.ds_observacao,
				a.cd_conta_contabil,
				a.nr_seq_trans_fin,
				a.nr_seq_regra,
				a.cd_medico,
				a.nr_seq_regra_esp,
				a.dt_lancamento,
				a.cd_centro_custo,
				nr_seq_terceiro_w,
				a.dt_liberacao,
				a.nr_seq_trans_fin_prov,
				a.cd_conta_contabil_prov,
				a.cd_centro_custo_prov,
				a.nr_lote_contabil_prov,
				nextval('repasse_terceiro_item_seq'),
				a.cd_conta_financ,
				a.cd_convenio,
				a.nr_seq_ret_glosa,
				a.nr_seq_terc_rep,
				a.dt_contabil,
				a.qt_minuto,
				a.nr_seq_tipo,
				a.nr_atendimento,
				a.cd_procedimento,
				a.ie_origem_proced,
				a.ie_partic_tributo,
				a.nr_adiant_pago,
				a.cd_material,
				a.nr_seq_tipo_valor,
				a.nr_seq_terc_regra_esp,
				a.nr_seq_terc_regra_item,
				a.dt_plantao,
				a.nr_seq_med_plantao,
				a.nr_interno_conta,
				a.nr_seq_repasse_prod,
				a.nr_seq_proc_interno
			from	repasse_terceiro_item a
			where	a.nr_sequencia	= nr_seq_item_repasse_w;

			end;
		end loop;
		close C02;

		update	repasse_terceiro
		set	ie_status		= 'U', --Unificado
			nr_repasse_terc_unif	= nr_repasse_terc_novo_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ds_observacao		= wheb_mensagem_pck.get_texto(304203,'NR_REPASSE_TERC_NOVO=' || nr_repasse_terc_novo_w)
		where	nr_repasse_terceiro	= nr_repasse_terceiro_w;

		--ds_observacao		= 'O repasse foi unificado para o repasse '||NR_REPASSE_TERC_NOVO_W
		end;
	end loop;
	close C01;

elsif (ie_acao_p = '2') then
	ds_lista_repasse_w	:= trim(both ds_lista_repasse_w);
	open C03;
	loop
	fetch C03 into
		nr_repasse_terceiro_w,
		nr_repasse_terc_unif_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (coalesce(ds_repasse_observacao_w::text, '') = '') then
			ds_repasse_observacao_w	:= nr_repasse_terceiro_w;
		else
			ds_repasse_observacao_w	:= ds_repasse_observacao_w||', '||nr_repasse_terceiro_w;
		end if;
		update	repasse_terceiro
		set	ie_status		= 'A', --Aberto
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nr_repasse_terc_unif	 = NULL,
			ds_observacao		 = NULL
		where	nr_repasse_terceiro	= nr_repasse_terceiro_w;

		end;
	end loop;
	close C03;

	/*Cancelar o repasse que foi gerado pela unificação*/

	update	repasse_terceiro
	set	ie_status		= 'C', --Cancelado
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ds_observacao 		= wheb_mensagem_pck.get_texto(304204,'DS_REPASSE_OBSERVACAO=' || DS_REPASSE_OBSERVACAO_W)
	where	nr_repasse_terceiro	= nr_repasse_terc_unif_w;

	--ds_observacao		= 'Repasse cancelado pela unificação ter sido desfeita para o(s) repasse(s) '||DS_REPASSE_OBSERVACAO_W||' '
end if;

commit;

nr_repasse_novo_p := nr_repasse_terc_novo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE unificar_repasse_terceiro (ds_lista_repasse_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_acao_p text, dt_inicial_p timestamp, dt_final_p timestamp, dt_referencia_p timestamp, ie_tipo_data_p bigint, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_condicao_pagamento_p bigint, nr_seq_tipo_p bigint, nr_repasse_novo_p INOUT bigint) FROM PUBLIC;
