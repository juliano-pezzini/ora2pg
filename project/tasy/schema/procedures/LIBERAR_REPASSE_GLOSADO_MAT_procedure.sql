-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_repasse_glosado_mat ( nr_seq_retorno_p bigint, nr_seq_grg_p bigint, nr_seq_ret_glosa_p bigint, nm_usuario_p text) AS $body$
DECLARE


cont_w			bigint;
nr_seq_propaci_w		bigint;
nr_seq_matpaci_w		bigint;
vl_glosa_w		double precision;
vl_amenor_w		double precision;
cd_estabelecimento_w	bigint;
vl_cobrado_w		double precision;
ie_repasse_maior_w	varchar(255);
nr_seq_proc_rep_novo_w	bigint;
nr_seq_mat_rep_novo_w	bigint;
dt_retorno_w		timestamp;
pr_amenor_w		double precision;
nr_seq_repasse_w		bigint;
nr_seq_ret_item_w		bigint;
vl_repasse_w		double precision;
nr_seq_proc_repasse_w	bigint;
nr_seq_mat_repasse_w	bigint;
pr_glosa_w		double precision;
vl_material_w		double precision;
ie_status_w		varchar(10);
cd_motivo_glosa_w		bigint;
nr_seq_regra_w		bigint;
ie_calculo_w		varchar(10);
ie_status_rep_novo_w	varchar(10);
nr_seq_criterio_w		bigint;
ie_proc_partic_w		varchar(10);
ie_origem_valor_w		varchar(50);
tx_adicional_w		double precision;
vl_repasse_atualizado_w	double precision;
vl_repasse_atual_w	double precision;
vl_cobrado_glosa_w	double precision;
vl_glosa_aj_w		double precision;
nr_seq_lote_audit_hist_w	bigint;
nr_seq_lote_guia_w	bigint;
ie_data_grg_ret_w	varchar(1);
ds_observacao_w		varchar(3980);
vl_saldo_amenor_w	lote_audit_hist_item.vl_saldo_amenor%type;
cd_autorizacao_w		varchar(20);
vl_desconto_item_w		convenio_retorno_glosa.vl_desconto_item%type;
vl_desconto_w			material_repasse.vl_desconto%type;

c01 CURSOR FOR
SELECT	b.nr_sequencia,
	a.nr_seq_matpaci,
	a.vl_glosa,
	a.cd_motivo_glosa,
	null,
	null,
	null,
	b.cd_autorizacao,
	coalesce(a.vl_desconto_item,0)
from	motivo_glosa c,
	convenio_retorno_glosa a,
	convenio_retorno_item b
where	a.nr_seq_ret_item	= b.nr_sequencia
and	c.cd_motivo_glosa	= a.cd_motivo_glosa
and	b.nr_seq_retorno	= nr_seq_retorno_p
and	coalesce(a.ie_acao_glosa,c.ie_acao_glosa) = 'A'
and	(a.nr_seq_matpaci IS NOT NULL AND a.nr_seq_matpaci::text <> '')
and	a.vl_glosa	> 0

union all

select	null,
	a.nr_seq_propaci,
	a.vl_glosa,
	a.cd_motivo_glosa,
	b.nr_seq_lote_hist,
	b.nr_sequencia,
	a.vl_saldo_amenor,
	b.cd_autorizacao,
	0
from	lote_audit_hist_guia b,
	lote_audit_hist_item a
where	a.nr_seq_guia	= b.nr_sequencia
and	b.nr_seq_lote_hist	= nr_seq_grg_p
and	(a.nr_seq_matpaci IS NOT NULL AND a.nr_seq_matpaci::text <> '')
and	a.vl_glosa	> 0;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.vl_original_repasse,
	a.ie_status,
	a.nr_seq_criterio,
	a.vl_repasse
from	material_atend_paciente b,
	material_repasse a
where	a.nr_seq_material		= b.nr_sequencia
and	b.nr_sequencia			= nr_seq_matpaci_w
and	coalesce(a.nr_seq_item_retorno,-1)	<> coalesce(nr_seq_ret_item_w,-1)
and	coalesce(b.nr_doc_convenio,coalesce(cd_autorizacao_w,'Não Informada')) = coalesce(cd_autorizacao_w,'Não Informada');


BEGIN

select	CASE WHEN b.ie_data_lib_repasse_ret='F' THEN  coalesce(a.dt_baixa_cr, a.dt_fechamento) WHEN b.ie_data_lib_repasse_ret='R' THEN  a.dt_retorno WHEN b.ie_data_lib_repasse_ret='E' THEN  a.dt_fechamento END ,
	a.cd_estabelecimento
into STRICT	dt_retorno_w,
	cd_estabelecimento_w
from	parametro_faturamento b,
	convenio_retorno a
where	a.nr_sequencia		= nr_seq_retorno_p
and	a.cd_estabelecimento	= b.cd_estabelecimento

union

SELECT	c.dt_fechamento,
	a.cd_estabelecimento
from	parametro_faturamento b,
	lote_auditoria a,
	lote_audit_hist c
where	c.nr_sequencia		= nr_seq_grg_p
and	a.nr_sequencia		= c.nr_seq_lote_audit
and	a.cd_estabelecimento	= b.cd_estabelecimento;

select	coalesce(max(ie_data_lib_repasse_grg),'G')
into STRICT	ie_data_grg_ret_w
from	parametro_repasse
where	cd_estabelecimento	= cd_estabelecimento_w;

if (coalesce(ie_data_grg_ret_w,'G')	= 'R') and (coalesce(nr_seq_retorno_p::text, '') = '') then

	select	max(e.dt_baixa_cr)
	into STRICT	dt_retorno_w
	from	convenio_retorno e,
		lote_audit_hist_guia d,
		parametro_faturamento b,
		lote_auditoria a,
		lote_audit_hist c
	where	c.nr_sequencia		= nr_seq_grg_p
	and	d.nr_seq_retorno	= e.nr_sequencia
	and	d.nr_seq_lote_hist	= c.nr_sequencia
	and	a.nr_sequencia		= c.nr_seq_lote_audit
	and	a.cd_estabelecimento	= b.cd_estabelecimento;
end if;
select	coalesce(max(ie_repasse_maior),'L')
into STRICT	ie_repasse_maior_w
from	parametro_repasse
where	cd_estabelecimento	= cd_estabelecimento_w;

open c01;
loop
fetch c01 into
	nr_seq_ret_item_w,
	nr_seq_matpaci_w,
	vl_glosa_w,
	cd_motivo_glosa_w,
	nr_seq_lote_audit_hist_w,
	nr_seq_lote_guia_w,
	vl_saldo_amenor_w,
	cd_autorizacao_w,
	vl_desconto_item_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	CASE WHEN max(a.vl_cobrado)=0 THEN max(a.vl_pago_digitado)  ELSE max(a.vl_cobrado) END ,
		max(a.vl_glosa)
	into STRICT	vl_cobrado_glosa_w,
		vl_glosa_aj_w
	from	convenio_retorno_glosa a
	where	a.nr_seq_matpaci	= nr_seq_matpaci_w
	and	a.nr_seq_ret_item	= nr_seq_ret_item_w;


	select	max(vl_cobrado),
		max(vl_glosa)
	into STRICT	vl_cobrado_glosa_w,
		vl_glosa_aj_w
	from (SELECT	CASE WHEN a.vl_cobrado=0 THEN a.vl_pago_digitado  ELSE a.vl_cobrado END  vl_cobrado,
			a.vl_glosa
		from	convenio_retorno_glosa a
		where	a.nr_seq_matpaci	= nr_seq_matpaci_w
		and	a.nr_seq_ret_item	= nr_seq_ret_item_w
		
union all

		SELECT	b.vl_material vl_cobrado,
			a.vl_glosa
		from	material_atend_paciente b,
			lote_audit_hist_item a
		where	a.nr_seq_matpaci	= b.nr_sequencia
		and	a.nr_seq_matpaci	= nr_seq_matpaci_w
		and	a.nr_seq_guia		= nr_seq_lote_guia_w) alias2;

	open c02;
	loop
	fetch c02 into
		nr_seq_mat_repasse_w,
		vl_repasse_w,
		ie_status_w,
		nr_seq_criterio_w,
		vl_repasse_atual_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		/*
		apenas deve tratar repasses com status 'A' ou 'U' (Aguardando ...), a não ser que exista regra
		*/
		if (ie_status_w in ('A','U')) then

			if (coalesce(vl_repasse_w::text, '') = '') then

				select	a.vl_repasse
				into STRICT		vl_repasse_w
				from	material_repasse a
				where	a.nr_sequencia	= nr_seq_mat_repasse_w;

				if (coalesce(vl_repasse_w,0)>0) then

					update	material_repasse
					set		vl_original_repasse	= vl_repasse_w
					where	nr_sequencia	= nr_seq_mat_repasse_w;

				end if;

			end if;

			if (coalesce(ie_calculo_w,-1)	= 3) then

				/*
				vem da regra Regra liberação do repasse pelo retorno (nova).
				Se a forma de calculo for Valor total do repasse, libera na rotina abaixo
				*/
				CALL liberar_repasse_valor_fixo(null, nr_seq_mat_repasse_w, 'Tasy');

			else

				select	sum(vl_repasse_calc),
						sum(a.vl_material)
				into STRICT		vl_cobrado_w,
						vl_material_w
				from	material_atend_paciente a
				where	a.nr_sequencia		= nr_seq_matpaci_w;

				if (coalesce(vl_repasse_w,0) > 0) then

					vl_desconto_w	:= (vl_desconto_item_w/vl_cobrado_glosa_w) * vl_repasse_w;

					if (ie_status_w in ('A','U')) then

						if (coalesce(vl_cobrado_glosa_w,0) <> coalesce(vl_glosa_aj_w,0)) and
							((coalesce(vl_saldo_amenor_w::text, '') = '') or (coalesce(vl_glosa_aj_w,0) <> coalesce(vl_saldo_amenor_w,0))) then
							update	material_repasse
							set	vl_repasse		= vl_repasse - (vl_repasse_w * (coalesce(vl_glosa_w,0) / coalesce(vl_material_w,1))) - vl_desconto_w,
								vl_liberado		= vl_repasse - (vl_repasse_w * (coalesce(vl_glosa_w,0) / coalesce(vl_material_w,1))) - vl_desconto_w,
								dt_liberacao		= dt_retorno_w,
								vl_desconto		= vl_desconto_w
							where	nr_sequencia		= nr_seq_mat_repasse_w;

							select	coalesce(max(vl_repasse),0)
							into STRICT	vl_repasse_atualizado_w
							from	material_repasse
							where	nr_sequencia		= nr_seq_mat_repasse_w;
						else
							update	material_repasse
							set	vl_repasse	= (vl_repasse_w * (coalesce(vl_glosa_w,0) / coalesce(vl_material_w,1))),
								vl_liberado	= 0,
								dt_liberacao	= coalesce(dt_retorno_w, clock_timestamp()),
								ie_status	= 'G'
							where	nr_sequencia	= nr_seq_mat_repasse_w;
						end if;
					end if;

					if (coalesce(ie_calculo_w, 1) = 2) then

						/*
						vem da regra Regra liberação do repasse pelo retorno (nova).
						Se o cálculo for valor proporcional negativo, altera sinal
						*/
						vl_glosa_w	:= vl_glosa_w * -1;
					end if;
					if (coalesce(vl_cobrado_glosa_w,0) <> coalesce(vl_glosa_aj_w,0)) and
						((coalesce(vl_saldo_amenor_w::text, '') = '') or (coalesce(vl_glosa_aj_w,0) <> coalesce(vl_saldo_amenor_w,0))) then
						desdobrar_procmat_repasse(	null,
										nr_seq_mat_repasse_w,
										coalesce(ie_status_rep_novo_w, 'G'),
										(vl_repasse_w * (coalesce(vl_glosa_w,0) / coalesce(vl_material_w,1))),
										nm_usuario_p,
										nr_seq_proc_rep_novo_w,
										nr_seq_mat_rep_novo_w);

						ds_observacao_w := WHEB_MENSAGEM_PCK.get_texto(303666,
												'DS_PROC_P='|| 'LIBERAR_REPASSE_GLOSADO_MAT' ||
												';NR_SEQ_PROC_REP_NOVO_P='|| nr_seq_mat_rep_novo_w ||
												';VL_CALCULO_ADIC_P='|| (vl_repasse_w * (coalesce(vl_glosa_w,0) / coalesce(vl_material_w,1))) ||
												';IE_STATUS_REP_NOVO_P='|| coalesce(ie_status_rep_novo_w, 'G'));

						CALL GRAVAR_MAT_REPASSE_VALOR(	ds_observacao_w,						-- DS_OBSERVACAO_P
										nm_usuario_p,							-- NM_USUARIO_P
										ie_status_w, 							-- IE_STATUS_ANT_P
										ie_status_w,							-- IE_STATUS_ATUAL_P
										coalesce(vl_repasse_atual_w,0),						-- VL_REPASSE_ANT_P
										coalesce(vl_repasse_atualizado_w,0),						-- VL_REPASSE_ATUAL_P,
										nr_seq_retorno_p,						 	-- NR_SEQ_RETORNO_P,
										nr_seq_grg_p,							-- NR_SEQ_LOTE_AUDIT_HIST_P,
										nr_seq_mat_repasse_w,						-- NR_SEQ_MAT_REPASSE_P,
										nr_seq_regra_w);							-- NR_SEQ_REGRA_REP_RET_P
						update	material_repasse
						set	nr_seq_item_retorno	= nr_seq_ret_item_w,
							vl_original_repasse	= vl_repasse_w
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
-- REVOKE ALL ON PROCEDURE liberar_repasse_glosado_mat ( nr_seq_retorno_p bigint, nr_seq_grg_p bigint, nr_seq_ret_glosa_p bigint, nm_usuario_p text) FROM PUBLIC;

