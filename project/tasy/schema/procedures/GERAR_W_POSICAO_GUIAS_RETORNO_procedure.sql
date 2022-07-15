-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_posicao_guias_retorno (cd_convenio_p text, dt_inicial_p timestamp, dt_final_p timestamp, ie_filtro_data_p text, nm_usuario_p text) AS $body$
DECLARE


nr_interno_conta_w           		conta_paciente.nr_interno_conta%type;
cd_autorizacao_w           		convenio_retorno_item.cd_autorizacao%type;
vl_guia_w           			conta_paciente_guia.vl_guia%type;
cd_estabelecimento_w           		conta_paciente.cd_estabelecimento%type;
dt_emissao_w           			titulo_receber.dt_emissao%type;
dt_vencimento_w           		titulo_receber.dt_vencimento%type;
nr_nota_fiscal_w           		titulo_receber.nr_nota_fiscal%type;
nr_seq_protocolo_w           		conta_paciente.nr_seq_protocolo%type;
nr_seq_nf_saida_w           		titulo_receber.nr_seq_nf_saida%type;
nr_titulo_w           			titulo_receber.nr_titulo%type;
nr_seq_retorno_ultimo_w			convenio_retorno.nr_sequencia%type;
cd_convenio_w				conta_paciente.cd_convenio_parametro%type;
cd_senha_atend_w			atend_categoria_convenio.cd_senha%type;
vl_pago_w           			double precision;
vl_perda_w           			double precision;
vl_adequado_w           		double precision;
vl_desconto_w           		double precision;
vl_glosa_aceita_w           		double precision;
vl_saldo_guia_w           		double precision;
vl_adicional_w				double precision;
vl_glosado_retorno_w			double precision;
vl_glosa_grg_w				double precision;
dt_ult_recebimento_w			timestamp;


c01 CURSOR FOR
	SELECT	distinct
		cg.cd_autorizacao,
		acc.cd_senha,
		cg.nr_interno_conta,
		cg.vl_guia,
		cp.cd_estabelecimento,
		tr.dt_emissao,
		tr.dt_vencimento,
		tr.nr_nota_fiscal,
		pc.nr_seq_protocolo,
		tr.nr_seq_nf_saida,
		tr.nr_titulo,
		cp.cd_convenio_parametro
	from	conta_paciente_guia cg,
		conta_paciente cp,
		protocolo_convenio pc,
		convenio_retorno_item ri,
		titulo_receber tr,
		atend_categoria_convenio acc
	where	cg.nr_interno_conta 		= cp.nr_interno_conta
	and	cp.nr_seq_protocolo		= pc.nr_seq_protocolo
	and	cp.cd_convenio_parametro 	= coalesce(cd_convenio_p, cp.cd_convenio_parametro)
	and	ri.nr_interno_conta 		= cp.nr_interno_conta
	and	ri.cd_autorizacao   		= coalesce(cp.cd_autorizacao, ri.cd_autorizacao)
	and	ri.nr_titulo        		= tr.nr_titulo
	and	acc.nr_atendimento		= cp.nr_atendimento
	and	((tr.dt_emissao	    	between dt_inicial_p and dt_final_p) and (ie_filtro_data_p = 'E')
	or (tr.dt_vencimento	between dt_inicial_p and dt_final_p) and (ie_filtro_data_p = 'V'))
	order	by
		cp.cd_convenio_parametro,
		CASE WHEN ie_filtro_data_p='E' THEN tr.dt_emissao  ELSE tr.dt_vencimento END ,
		cg.cd_autorizacao,
		tr.nr_titulo;


BEGIN

	delete	from w_posicao_guias_retorno
	where	nm_usuario = nm_usuario_p;

	open c01;
	loop
	fetch c01 into
		cd_autorizacao_w,
		cd_senha_atend_w,
		nr_interno_conta_w,
		vl_guia_w,
		cd_estabelecimento_w,
		dt_emissao_w,
		dt_vencimento_w,
		nr_nota_fiscal_w,
		nr_seq_protocolo_w,
		nr_seq_nf_saida_w,
		nr_titulo_w,
		cd_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		select	sum(i.vl_pago),
			sum(i.vl_adequado),
			sum(i.vl_desconto),
			sum(i.vl_perdas),
			sum(i.vl_adicional)
		into STRICT	vl_pago_w,
			vl_adequado_w,
			vl_desconto_w,
			vl_perda_w,
			vl_adicional_w
		from	convenio_retorno_item i,
			convenio_retorno r
		where	r.nr_sequencia 		= i.nr_seq_retorno
		and	i.cd_autorizacao 	= cd_autorizacao_w
		and	i.nr_interno_conta 	= nr_interno_conta_w
		and	r.cd_convenio		= coalesce(cd_convenio_p, r.cd_convenio);

		select	obter_saldo_conpaci(nr_interno_conta_w, cd_autorizacao_w)
		into STRICT	vl_saldo_guia_w
		;

		select 	coalesce(sum(b.vl_glosa),0)
		into STRICT	vl_glosa_aceita_w
		from	titulo_receber a,
			titulo_receber_liq b
		where	a.nr_titulo 		= b.nr_titulo
		and	a.nr_titulo		= nr_titulo_w;

		select  coalesce(sum(a.vl_glosado),0)
		into STRICT	vl_glosado_retorno_w
		from    convenio_retorno_item  a,
			convenio_retorno b
		where   a.nr_seq_retorno     	= b.nr_sequencia
		and     b.ie_status_retorno  	= 'F'
		and     a.cd_autorizacao   	= cd_autorizacao_w
		and	a.nr_interno_conta 	= nr_interno_conta_w;

		select 	coalesce(sum(i.vl_amenor),0)
		into STRICT	vl_glosa_grg_w
		from	titulo_receber a,
			titulo_receber_liq b,
			lote_audit_hist_guia g,
			lote_audit_hist_item i,
			convenio_retorno r
		where	a.nr_titulo 		= b.nr_titulo
		and    	g.nr_sequencia 		= b.nr_seq_lote_hist_guia
		and 	g.nr_seq_retorno 	= r.nr_sequencia
		and	i.nr_seq_guia		= g.nr_sequencia
		and 	r.ie_status_retorno 	= 'F'
		and	i.ie_acao_glosa		in ('R','P')
		and	g.nr_interno_conta 	= nr_interno_conta_w
		and     g.cd_autorizacao   	= cd_autorizacao_w;

		select	max(dt_recebimento)
		into STRICT	dt_ult_recebimento_w
		from	titulo_receber_liq
		where	nr_titulo = nr_titulo_w;

		insert into w_posicao_guias_retorno(
			cd_autorizacao,		cd_convenio,		cd_estabelecimento,	dt_atualizacao,
			dt_emissao_titulo,	dt_vencimento_titulo,	nm_usuario,		nr_interno_conta,
			nr_nota_fiscal,		nr_seq_protocolo,	nr_sequencia_nf,	nr_sequencia,
			nr_titulo,		vl_adequado,		vl_desconto,		vl_glosa_aceita,
			vl_guia,		vl_pago,		vl_perda,		vl_saldo_guia,
			vl_adicional,		vl_glosado_retorno,	vl_glosa_grg,		dt_ult_recebimento,
			cd_senha_atend		)
		values (cd_autorizacao_w,	cd_convenio_w,		cd_estabelecimento_w,	clock_timestamp(),
			dt_emissao_w,		dt_vencimento_w,	nm_usuario_p,		nr_interno_conta_w,
			nr_nota_fiscal_w,	nr_seq_protocolo_w,	nr_seq_nf_saida_w,	nextval('w_posicao_guias_retorno_seq'),
			nr_titulo_w,		vl_adequado_w,		vl_desconto_w,		vl_glosa_aceita_w,
			vl_guia_w,		vl_pago_w,		vl_perda_w,		vl_saldo_guia_w,
			vl_adicional_w,		vl_glosado_retorno_w,	vl_glosa_grg_w,		dt_ult_recebimento_w,
			cd_senha_atend_w	);

	end loop;
	close c01;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_posicao_guias_retorno (cd_convenio_p text, dt_inicial_p timestamp, dt_final_p timestamp, ie_filtro_data_p text, nm_usuario_p text) FROM PUBLIC;

