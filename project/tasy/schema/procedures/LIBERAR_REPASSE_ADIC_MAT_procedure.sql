-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_repasse_adic_mat ( nr_seq_retorno_p bigint, nr_seq_grg_p bigint, nr_seq_ret_glosa_p bigint, nm_usuario_p text) AS $body$
DECLARE


cont_w			bigint;
nr_seq_propaci_w		bigint;
nr_seq_matpaci_w		bigint;
vl_glosa_w		double precision;
vl_amaior_w		double precision;
cd_estabelecimento_w	bigint;
vl_cobrado_w		double precision;
ie_repasse_maior_w	varchar(255);
nr_seq_proc_rep_novo_w	bigint;
nr_seq_mat_rep_novo_w	bigint;
dt_retorno_w		timestamp;
nr_seq_convret_glosa_w	bigint;
pr_adicional_w		double precision;
nr_seq_repasse_w		bigint;
nr_seq_ret_item_w		bigint;
vl_repasse_w		double precision;
vl_material_w		double precision;
nr_seq_mat_repasse_w	bigint;
nr_seq_material_w	bigint;
cd_material_w		material.cd_material%type;
nr_seq_terceiro_w	bigint;
nr_seq_criterio_w		bigint;
nr_seq_regra_w		bigint;
ie_calculo_w		bigint;
ie_status_rep_novo_w	varchar(10);
cd_motivo_glosa_w	bigint;
ie_status_w		varchar(10);
ie_proc_partic_w		varchar(10);
ie_origem_valor_w		varchar(50);
vl_calculo_adic_w		double precision;
tx_adicional_w		double precision;
vl_repasse_atual_w	double precision;
ds_observacao_w		varchar(3980);
cd_autorizacao_w		varchar(20);
nr_seq_regra_bloq_w		bigint;
nr_seq_conv_ret_glosa_w		bigint;
nr_seq_lote_audit_hist_item_w		bigint;
ds_observacao_regra_bloq_w	varchar(255);

c01 CURSOR FOR
SELECT	b.nr_sequencia,
	a.nr_seq_matpaci,
	a.vl_amaior,
	a.cd_motivo_glosa,
	b.cd_autorizacao,
	a.nr_sequencia,
	null
from	convenio_retorno_glosa a,
	convenio_retorno_item b
where	a.nr_seq_ret_item	= b.nr_sequencia
and	b.nr_seq_retorno	= nr_seq_retorno_p
and	(a.nr_seq_matpaci IS NOT NULL AND a.nr_seq_matpaci::text <> '')
and	a.vl_amaior	> 0

union all

select	null,
	a.nr_seq_matpaci,
	vl_adicional,
	a.cd_motivo_glosa,
	b.cd_autorizacao,
	null,
	a.nr_sequencia
from	lote_audit_hist_guia b,
	lote_audit_hist_item a
where	a.nr_seq_guia	= b.nr_sequencia
and	b.nr_seq_lote_hist	= nr_seq_grg_p
and	(a.nr_seq_matpaci IS NOT NULL AND a.nr_seq_matpaci::text <> '')
and	vl_adicional	> 0;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.vl_original_repasse,
	a.ie_status,
	a.nr_seq_criterio,
	a.vl_repasse,
	a.nr_seq_material,
	a.nr_seq_terceiro,
	b.cd_material
from	material_atend_Paciente b,
	material_repasse a
where	a.nr_seq_material			= b.nr_sequencia
and	b.nr_sequencia				= nr_seq_matpaci_w
and	coalesce(a.nr_seq_item_retorno,-1)	<> coalesce(nr_seq_ret_item_w,-1)
and	coalesce(b.nr_doc_convenio,coalesce(cd_autorizacao_w,'Não Informada')) = coalesce(cd_autorizacao_w,'Não Informada');


BEGIN

select	CASE WHEN b.ie_data_lib_repasse_ret='F' THEN  coalesce(a.dt_baixa_cr, a.dt_fechamento) WHEN b.ie_data_lib_repasse_ret='R' THEN  a.dt_retorno WHEN b.ie_data_lib_repasse_ret='E' THEN  a.dt_fechamento END
into STRICT	dt_retorno_w
from	parametro_faturamento b,
	convenio_retorno a
where	a.nr_sequencia		= nr_seq_retorno_p
and	a.cd_estabelecimento	= b.cd_estabelecimento

union

SELECT	c.dt_fechamento
from	parametro_faturamento b,
	lote_auditoria a,
	lote_audit_hist c
where	c.nr_sequencia		= nr_seq_grg_p
and	a.nr_sequencia		= c.nr_seq_lote_audit
and	a.cd_estabelecimento	= b.cd_estabelecimento;

open c01;
loop
fetch c01 into
	nr_seq_ret_item_w,
	nr_seq_matpaci_w,
	vl_amaior_w,
	cd_motivo_glosa_w,
	cd_autorizacao_w,
	nr_seq_conv_ret_glosa_w,
	nr_seq_lote_audit_hist_item_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
	fetch c02 into
		nr_seq_mat_repasse_w,
		vl_repasse_w,
		ie_status_w,
		nr_seq_criterio_w,
		vl_repasse_atual_w,
		nr_seq_material_w,
		nr_seq_terceiro_w,
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		select obter_bloq_repasse_amaior(null, cd_material_w, nr_seq_terceiro_w, dt_retorno_w)
		into STRICT nr_seq_regra_bloq_w
		;

		if (nr_seq_regra_bloq_w IS NOT NULL AND nr_seq_regra_bloq_w::text <> '') then

			select WHEB_MENSAGEM_PCK.get_texto(1050568, 'NR_SEQ_REGRA='|| nr_seq_regra_bloq_w)
			into STRICT ds_observacao_regra_bloq_w
			;

			if (nr_seq_conv_ret_glosa_w IS NOT NULL AND nr_seq_conv_ret_glosa_w::text <> '') then

				update convenio_retorno_glosa
				set ds_observacao = ds_observacao_regra_bloq_w
				where nr_sequencia = nr_seq_conv_ret_glosa_w;

			elsif (nr_seq_lote_audit_hist_item_w IS NOT NULL AND nr_seq_lote_audit_hist_item_w::text <> '') then

				update lote_audit_hist_item
				set ds_observacao = ds_observacao_regra_bloq_w
				where nr_sequencia = nr_seq_lote_audit_hist_item_w;

			end if;

		else

			--apenas deve tratar repasses com status 'A' ou 'U' (Aguardando ...), a não ser que exista regra
			if (ie_status_w in ('A','U')) then

				if (coalesce(vl_repasse_w::text, '') = '') then

					select	a.vl_repasse
					into STRICT	vl_repasse_w
					from	material_repasse a
					where	a.nr_sequencia		= nr_seq_mat_repasse_w;

					update	material_repasse
					set	vl_original_repasse		= vl_repasse_w
					where	nr_sequencia		= nr_seq_mat_repasse_w;

				end if;

				if (coalesce(ie_calculo_w,-1)	= 3) then

					--vem da regra Regra liberação do repasse pelo retorno (nova).
					--Se a forma de calculo for Valor total do repasse, libera na rotina abaixo
					CALL liberar_repasse_valor_fixo(null, nr_seq_mat_repasse_w, 'Tasy');

				else

					select	sum(a.vl_repasse_calc),
						sum(a.vl_material)
					into STRICT	vl_cobrado_w,
						vl_material_w
					from	material_atend_paciente a
					where	a.nr_sequencia		= nr_seq_matpaci_w;

					if (coalesce(ie_calculo_w, 1) = 2) then

						--vem da regra Regra liberação do repasse pelo retorno (nova).
						--Se o cálculo for valor proporcional negativo, altera sinal
						vl_amaior_w	:= vl_amaior_w * -1;
					end if;

					if (coalesce(vl_repasse_w,0) > 0) then

						vl_calculo_adic_w	:= (vl_repasse_w * (coalesce(vl_amaior_w,0) / coalesce(vl_material_w,1)));

						if (coalesce(ie_calculo_w,-1)	= 4) then
							vl_calculo_adic_w		:= vl_amaior_w;
						end if;

						SELECT * FROM desdobrar_procmat_repasse(null, nr_seq_mat_repasse_w, coalesce(ie_status_rep_novo_w, 'R'), vl_calculo_adic_w, nm_usuario_p, nr_seq_proc_rep_novo_w, nr_seq_mat_rep_novo_w) INTO STRICT nr_seq_proc_rep_novo_w, nr_seq_mat_rep_novo_w;

						ds_observacao_w := WHEB_MENSAGEM_PCK.get_texto(303666,
										'DS_PROC_P='|| 'LIBERAR_REPASSE_ADIC_MAT' ||
										';NR_SEQ_PROC_REP_NOVO_P='|| nr_seq_proc_rep_novo_w ||
										';VL_CALCULO_ADIC_P='|| vl_calculo_adic_w ||
										';IE_STATUS_REP_NOVO_P='|| coalesce(ie_status_rep_novo_w, 'R'));

						CALL GRAVAR_MAT_REPASSE_VALOR(	ds_observacao_w,						-- DS_OBSERVACAO_P
										nm_usuario_p,							-- NM_USUARIO_P
										ie_status_w, 							-- IE_STATUS_ANT_P
										ie_status_w,							-- IE_STATUS_ATUAL_P
										coalesce(vl_repasse_atual_w,0),						-- VL_REPASSE_ANT_P
										coalesce(vl_repasse_atual_w,0),						-- VL_REPASSE_ATUAL_P,
										nr_seq_retorno_p,						 	-- NR_SEQ_RETORNO_P,
										nr_seq_grg_p,							-- NR_SEQ_LOTE_AUDIT_HIST_P,
										nr_seq_mat_repasse_w,						-- NR_SEQ_MAT_REPASSE_P,
										nr_seq_regra_w);

						update	material_repasse
						set	vl_liberado		= vl_repasse,
							nr_seq_item_retorno	= nr_seq_ret_item_w,
							vl_original_repasse		= vl_repasse_w
						where	nr_sequencia		= nr_seq_mat_rep_novo_w;

					end if;

				end if;

			end if;

		end if;

	end loop;
	close c02;

end loop;
close c01;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_repasse_adic_mat ( nr_seq_retorno_p bigint, nr_seq_grg_p bigint, nr_seq_ret_glosa_p bigint, nm_usuario_p text) FROM PUBLIC;

