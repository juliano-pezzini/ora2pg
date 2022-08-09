-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_conv_ret_unica (nr_seq_retorno_p bigint, nm_usuario_p text, nr_seq_conta_banco_p bigint, ds_erro_p INOUT text, nr_seq_trans_financ_p bigint) AS $body$
DECLARE


vl_pago_w			double precision;
vl_adicional_w			double precision;
vl_glosado_w			double precision;
vl_adequado_w			double precision;
vl_desconto_w			double precision;
vl_guia_w			double precision;
vl_perdas_w			double precision;
vl_titulo_w			double precision;
vl_pago_guia_w			double precision;
vl_adicional_guia_w		double precision;
vl_glosado_guia_w		double precision;
vl_adequado_guia_w		double precision;
vl_desconto_guia_w		double precision;
vl_perdas_guia_w		double precision;
dt_recebimento_w		timestamp;
nr_seq_trans_financ_w		bigint;
cd_tipo_recebimento_w		bigint;
cd_banco_w			banco_estabelecimento.cd_banco%type;
cd_agencia_w			varchar(255);
cd_estabelecimento_w		bigint;
cd_moeda_w			bigint;
ie_consiste_mes_contabil_w	varchar(255);
nr_seq_trans_partic_w		bigint;
nr_seq_trans_desc_ret_w		bigint;
cd_tipo_receb_desc_ret_w	bigint;
nr_seq_trans_fin_perda_w	bigint;
cd_tipo_receb_perda_w		bigint;
nr_titulo_w			bigint;
nr_seq_liq_w			bigint;
nr_interno_conta_w		bigint;
nr_seq_protocolo_w		bigint;
nr_seq_liq_desc_w		bigint;
nr_seq_liq_perdas_w		bigint;

ie_baixa_unica_ret_w		varchar(255);

C01 CURSOR FOR
SELECT	sum(coalesce(a.vl_pago,0)),		-- Guias que tem titulo de conta paciente
	sum(coalesce(a.vl_adicional,0)),
	sum(coalesce(a.vl_glosado,0)),
	sum(coalesce(a.vl_adequado,0)),
	sum(coalesce(a.vl_desconto,0)),
	sum(coalesce(a.vl_perdas,0)),
	a.nr_interno_conta,
	(null)::numeric  nr_seq_protocolo,
	sum(d.vl_guia)
from	conta_paciente_guia d,
	convenio_retorno_item a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	a.nr_interno_conta	= d.nr_interno_conta
and	a.cd_autorizacao	= d.cd_autorizacao
and	exists (SELECT 1 from titulo_receber x where x.nr_interno_conta = a.nr_interno_conta)
group	by a.nr_interno_conta

union all

select	sum(coalesce(a.vl_pago,0)),		-- Guias que tem titulo de conta paciente
	sum(coalesce(a.vl_adicional,0)),
	sum(coalesce(a.vl_glosado,0)),
	sum(coalesce(a.vl_adequado,0)),
	sum(coalesce(a.vl_desconto,0)),
	sum(coalesce(a.vl_perdas,0)),
	(null)::numeric  nr_interno_conta,
	b.nr_seq_protocolo,
	sum(d.vl_guia)
from	conta_paciente_guia d,
	conta_paciente b,
	convenio_retorno_item a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_interno_conta	= d.nr_interno_conta
and	a.cd_autorizacao	= d.cd_autorizacao
and	exists (select 1 from titulo_receber x where x.nr_seq_protocolo = b.nr_seq_protocolo and coalesce(x.nr_interno_conta::text, '') = '')
group	by b.nr_seq_protocolo;

c02 CURSOR FOR
SELECT	a.nr_titulo,
	a.vl_titulo
from	titulo_receber a
where	a.nr_interno_conta	= nr_interno_conta_w
and	coalesce(a.nr_seq_protocolo::text, '') = ''

union all

SELECT	a.nr_titulo,
	a.vl_titulo
from	titulo_receber a
where	a.nr_seq_protocolo	= nr_seq_protocolo_w
and	coalesce(a.nr_interno_conta::text, '') = '';


BEGIN

select	coalesce(max(d.dt_baixa_cr),clock_timestamp()),
	max(coalesce(x.nr_seq_trans_fin_conv_ret, coalesce(e.nr_seq_trans_fin_conv_ret, b.nr_seq_trans_fin))),
	max(e.cd_tipo_receb_conv_ret),
	max(c.cd_banco),
	max(c.cd_agencia_bancaria),
	max(d.cd_estabelecimento),
	coalesce(max(ie_consiste_mes_contabil),'N'),
	max(nr_seq_trans_ret_partic),
	max(nr_seq_trans_desc_ret),
	max(cd_tipo_receb_desc_ret),
	max(nr_seq_trans_fin_perda),
	max(cd_tipo_receb_perda),
	coalesce(max(d.ie_baixa_unica_ret), 'N'),
	max(e.cd_moeda_padrao)
into STRICT	dt_recebimento_w,
	nr_seq_trans_financ_w,
	cd_tipo_recebimento_w,
	cd_banco_w,
	cd_agencia_w,
	cd_estabelecimento_w,
	ie_consiste_mes_contabil_w,
	nr_seq_trans_partic_w,
	nr_seq_trans_desc_ret_w,
	cd_tipo_receb_desc_ret_w,
	nr_seq_trans_fin_perda_w,
	cd_tipo_receb_perda_w,
	ie_baixa_unica_ret_w,
	cd_moeda_w
FROM convenio_estabelecimento x, parametro_contas_receber e, convenio_ret_receb a
LEFT OUTER JOIN convenio_receb b ON (a.nr_seq_receb = b.nr_sequencia)
LEFT OUTER JOIN banco_estabelecimento c ON (b.nr_seq_conta_banco = c.nr_sequencia)
, convenio_retorno d
LEFT OUTER JOIN convenio_ret_receb a ON (d.nr_sequencia = a.nr_seq_retorno)
WHERE d.cd_estabelecimento	= e.cd_estabelecimento and d.cd_estabelecimento	= x.cd_estabelecimento and d.cd_convenio		= x.cd_convenio and d.nr_sequencia		= nr_seq_retorno_p;

if (coalesce(ie_baixa_unica_ret_w, 'N') <> 'S') then
	-- Este retorno nao foi criado para baixa unica no titulo a receber!
	CALL wheb_mensagem_pck.exibir_mensagem_abort(267119);
end if;

open c01;
loop
fetch c01 into
	vl_pago_guia_w,
	vl_adicional_guia_w,
	vl_glosado_guia_w,
	vl_adequado_guia_w,
	vl_desconto_guia_w,
	vl_perdas_guia_w,
	nr_interno_conta_w,
	nr_seq_protocolo_w,
	vl_guia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */


	open c02;
	loop
	fetch c02 into
		nr_titulo_w,
		vl_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		vl_pago_w		:= vl_pago_guia_w;
		vl_adicional_w		:= vl_adicional_guia_w;
		vl_glosado_w		:= vl_glosado_guia_w;
		vl_adequado_w		:= vl_adequado_guia_w;
		vl_desconto_w		:= vl_desconto_guia_w;
		vl_perdas_w		:= vl_perdas_guia_w;

		-- Gerar baixa do desconto
		if (nr_seq_trans_desc_ret_w IS NOT NULL AND nr_seq_trans_desc_ret_w::text <> '') and (cd_tipo_receb_desc_ret_w IS NOT NULL AND cd_tipo_receb_desc_ret_w::text <> '') and (vl_desconto_w <> 0) then

			baixa_tit_rec_liq_convret
				(nr_titulo_w,
				dt_recebimento_w,
				0,
				(dividir_sem_round(vl_desconto_w, vl_guia_w) * vl_titulo_w),
				0,
				0,
				0,
				0,
				0,
				0,
				cd_moeda_w,
				cd_tipo_receb_desc_ret_w,
				nr_seq_trans_desc_ret_w,
				nr_seq_retorno_p,
				null, -- nr_seq_conta_banco_p,
				nm_usuario_p,
				nr_seq_liq_desc_w);

			CALL GERAR_TIT_REC_LIQ_DESC(nr_titulo_w, nr_seq_liq_desc_w, nm_usuario_p);
			vl_desconto_w	:= 0;	
		end if;

		if (nr_seq_trans_fin_perda_w IS NOT NULL AND nr_seq_trans_fin_perda_w::text <> '') and (cd_tipo_receb_perda_w IS NOT NULL AND cd_tipo_receb_perda_w::text <> '') and (vl_perdas_w <> 0) then

			baixa_tit_rec_liq_convret
				(nr_titulo_w,
				dt_recebimento_w,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				(dividir_sem_round(vl_perdas_w, vl_guia_w) * vl_titulo_w),
				cd_moeda_w,
				cd_tipo_receb_perda_w,
				nr_seq_trans_fin_perda_w,
				nr_seq_retorno_p,
				null, --nr_seq_conta_banco_p,
				nm_usuario_p,
				nr_seq_liq_perdas_w);

			CALL GERAR_TIT_REC_LIQ_DESC(nr_titulo_w, nr_seq_liq_perdas_w, nm_usuario_p);
			vl_perdas_w	:= 0;	
		end if;


		baixa_tit_rec_liq_convret
			(nr_titulo_w,
			dt_recebimento_w,
			(dividir_sem_round(vl_pago_w, vl_guia_w) * vl_titulo_w),
			(dividir_sem_round(vl_desconto_w, vl_guia_w) * vl_titulo_w),
			0,
			0,
			(dividir_sem_round(vl_adicional_w, vl_guia_w) * vl_titulo_w),
			(dividir_sem_round(vl_glosado_w, vl_guia_w) * vl_titulo_w),
			(dividir_sem_round(vl_adequado_w, vl_guia_w) * vl_titulo_w),
			(dividir_sem_round(vl_perdas_w, vl_guia_w) * vl_titulo_w),
			cd_moeda_w,
			cd_tipo_recebimento_w,
			nr_seq_trans_financ_w,
			nr_seq_retorno_p,
			null, -- nr_seq_conta_banco_p,
			nm_usuario_p,
			nr_seq_liq_w);

		CALL gerar_tit_rec_liq_cc_convret(nr_titulo_w, nr_seq_liq_w, nm_usuario_p);
		CALL atualizar_saldo_tit_rec(nr_titulo_w, nm_usuario_p);

	end loop;
	close c02;

	CALL ATUALIZAR_TIT_REC_LIQ_CONVRET(nr_seq_retorno_p,
				nr_seq_protocolo_w,
				nr_interno_conta_w,
				vl_pago_guia_w,
				vl_adicional_guia_w,
				vl_glosado_guia_w,
				vl_adequado_guia_w,
				vl_desconto_guia_w,
				vl_perdas_guia_w,
				nm_usuario_p);

end loop;
close c01;

update	convenio_retorno
set	ie_status_retorno 	= 'F',
	dt_fechamento 		= clock_timestamp(),
	nm_usuario_fechamento 	= nm_usuario_p
where	nr_sequencia 		= nr_seq_retorno_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_conv_ret_unica (nr_seq_retorno_p bigint, nm_usuario_p text, nr_seq_conta_banco_p bigint, ds_erro_p INOUT text, nr_seq_trans_financ_p bigint) FROM PUBLIC;
