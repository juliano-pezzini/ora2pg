-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_margem_beneficiario ( dt_mes_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
vl_dominio_w			varchar(15);
nr_seq_segurado_w		bigint;
vl_mensalidade_w		double precision;
vl_margem_w			double precision;
dt_referencia_w			timestamp;
dt_parametro_inicio_w		timestamp;
dt_parametro_fim_w		timestamp;
cd_cgc_estipulante_w		varchar(14);
cd_pf_estipulante_w		varchar(10);
qt_contador_pb_w		bigint;
vl_total_despesa_w		double precision	:= 0;
vl_total_imposto_w		double precision	:= 0;
vl_total_mensalidade_w		double precision	:= 0;
pr_rateio_w			double precision;
nr_sequencia_w			bigint;
vl_rateado_despesa_w		double precision	:= 0;
vl_rateado_imposto_w		double precision	:= 0;
vl_rateado_provisao_w		double precision	:= 0;
vl_total_provisao_tecnica_w	double precision	:= 0;
ie_tipo_beneficiario_w		varchar(5)	:= 'B';
vl_despesa_ops_w		double precision	:= 0;
vl_despesa_acidente_w		double precision	:= 0;
vl_despesa_pericia_w		double precision	:= 0;
vl_imposto_ops_w		double precision	:= 0;
vl_imposto_acidente_w		double precision	:= 0;
vl_imposto_pericia_w		double precision	:= 0;
vl_provisao_ops_w		double precision	:= 0;
vl_provisao_acidente_w		double precision	:= 0;
vl_provisao_pericia_w		double precision	:= 0;
ie_valor_mensalidade_w		varchar(1);
nr_seq_plano_w			bigint;
ds_dominio_w			varchar(255);

ie_tipo_vinculo_operadora_w	varchar(2);

C01 CURSOR FOR 
	SELECT	vl_dominio 
	from	valor_dominio 
	where	cd_dominio	= 2236 
	order by vl_dominio;

/* Mensalidade */
	 
C02 CURSOR FOR 
	SELECT	sum(d.vl_item) vl_mensalidade, 
		c.nr_seq_segurado 
	from	pls_mensalidade_seg_item	d, 
		pls_mensalidade_segurado	c, 
		pls_mensalidade			b, 
		pls_lote_mensalidade		a 
	where	d.nr_seq_mensalidade_seg = c.nr_sequencia 
	and	c.nr_seq_mensalidade	= b.nr_sequencia 
	and	b.nr_seq_lote		= a.nr_sequencia 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	a.ie_status	= 2 
	and	trunc(b.dt_referencia,'month') = dt_referencia_w 
	and	ie_valor_mensalidade_w = 'N' 
	group by c.nr_seq_segurado 
	
union
 
	SELECT	sum(CASE WHEN coalesce(a.dt_contabilizacao::text, '') = '' THEN d.vl_antecipacao  ELSE 0 END ) vl_mensalidade, 
		c.nr_seq_segurado 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	a.ie_status	= '2' 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'N' 
	and	trunc(d.dt_antecipacao,'month') = dt_referencia_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	d.ie_tipo_item	<> '3' 
	group by c.nr_seq_segurado 
	
union
 
	select	sum(d.vl_antecipacao) vl_pro_rata_dia, 
		c.nr_seq_segurado 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	d.ie_tipo_item	not in ('20','11') 
	and	(a.dt_contabilizacao IS NOT NULL AND a.dt_contabilizacao::text <> '') 
	and	a.ie_status	= '2' /* Lepinski - OS 342207 - Somente gerar no resumo, as informações de lotes em definitivo */
 
	and	trunc(d.dt_antecipacao,'month') = dt_referencia_w 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'N' 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	d.ie_tipo_item	<> '3' 
	group by c.nr_seq_segurado 
	
union
 
	select	sum(d.vl_pro_rata_dia) vl_pro_rata_dia, 
		c.nr_seq_segurado 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	d.ie_tipo_item	not in ('20','11') 
	and	a.ie_status	= '2' 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'N' 
	and	trunc(c.dt_mesano_referencia,'month') = dt_referencia_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	d.ie_tipo_item	<> '3' 
	group by c.nr_seq_segurado 
	
union
 
	select	sum(d.vl_item) vl_pro_rata_dia, 
		c.nr_seq_segurado 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'S' 
	and	a.ie_status	= '2' 
	and	trunc(a.dt_mesano_referencia,'month') = dt_referencia_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	d.ie_tipo_item	<> '3' 
	group by c.nr_seq_segurado;
	/*select	(sum(vl_mensalidade) - sum(vl_outros) + sum(vl_antecipacao) - sum(vl_coparticipacao_rembolso)) vl_mensalidade, 
		nr_seq_segurado 
	from	pls_margem_mensalidade_seg_v 
	where  dt_mesano_referencia  = dt_referencia_w 
	and	dt_mesano_referencia	<> trunc(to_date('01/01/2010'),'Month') 
	and	ie_valor_mensalidade_w = 'S' 
	group by nr_seq_segurado 
	union 
	select	(sum(vl_mensalidade) - sum(vl_outros)), 
		nr_seq_segurado 
	from	pls_margem_mensalidade_seg_v 
	where  dt_mesano_referencia  = dt_referencia_w 
	and	dt_mesano_referencia	= trunc(to_date('01/01/2010'),'Month') 
	and	ie_valor_mensalidade_w = 'S' 
	group by nr_seq_segurado;*/
 
 
/* Contas médicas */
	
C03 CURSOR FOR 
	SELECT	sum(coalesce(b.vl_total,0)), 
		b.nr_seq_segurado, 
		b.nr_seq_plano 
	from  pls_conta		b, 
		pls_protocolo_conta	a 
	where	a.nr_sequencia	= b.nr_seq_protocolo 
	and	trunc(a.dt_mes_competencia,'month') = dt_referencia_w	 
	and	a.ie_status 	in ('3','6') 
	and	a.ie_situacao in ('D','T') 
	and	a.ie_tipo_protocolo	= 'C' 
	and	(b.nr_seq_segurado IS NOT NULL AND b.nr_seq_segurado::text <> '') 
	group by	b.nr_seq_segurado, 
			b.nr_seq_plano;

/* Reembolso */
 
C04 CURSOR FOR 
	--Alex August Schlote 04/05/2010 OS - 213146 - O valor do resultado do reembolso deve ser o vl_liberado dos procedimentos 
	SELECT	sum(coalesce(c.vl_liberado,0)), 
		b.nr_seq_segurado 
	from  pls_conta_proc		c, 
		pls_conta		b, 
		pls_protocolo_conta	a 
	where	a.nr_sequencia	= b.nr_seq_protocolo 
	and	c.nr_seq_conta	= b.nr_sequencia 
	and	trunc(a.dt_mes_competencia,'month') = dt_referencia_w	 
	and	a.ie_status 	in ('3','6') 
	and	a.ie_situacao in ('D','T') 
	and	a.ie_tipo_protocolo	= 'R' 
	group by	b.nr_seq_segurado;
	
/* Comissão vendas */
 
C05 CURSOR FOR	 
	SELECT	sum(coalesce(vl_repasse,0)), 
		c.nr_seq_segurado 
	from	pls_mensalidade_segurado	c, 
		pls_repasse_mens		b, 
		pls_repasse_vend		a 
	where 	a.nr_sequencia			= b.nr_seq_repasse 
	and	c.nr_sequencia			= b.nr_seq_mens_seg 
	and	trunc(a.dt_referencia,'month') 	= dt_referencia_w 
	and	a.ie_status <> 'C' 
	group by c.nr_seq_segurado;
	
/*Coparticipação*/
 
C06 CURSOR FOR 
	SELECT	sum(d.vl_item) vl_mensalidade, 
		c.nr_seq_segurado 
	from	pls_mensalidade_seg_item	d, 
		pls_mensalidade_segurado	c, 
		pls_mensalidade			b, 
		pls_lote_mensalidade		a 
	where	d.nr_seq_mensalidade_seg = c.nr_sequencia 
	and	c.nr_seq_mensalidade	= b.nr_sequencia 
	and	b.nr_seq_lote		= a.nr_sequencia 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	a.ie_status	= 2 
	and	d.ie_tipo_item	= '3' 
	and	trunc(b.dt_referencia,'month') = dt_referencia_w 
	group by c.nr_seq_segurado 
	
union all
 /* OS 472263 - Coparticipação de reembolso */
 
	SELECT	sum(a.vl_coparticipacao), 
		b.nr_seq_segurado 
	from	pls_conta_coparticipacao	a, 
		pls_conta			b, 
		pls_protocolo_conta		c 
	where	a.nr_seq_conta		= b.nr_sequencia 
	and	b.nr_seq_protocolo	= c.nr_sequencia 
	and	c.ie_tipo_protocolo	= 'R' 
	and	trunc(c.dt_mes_competencia,'month') = dt_referencia_w 
	group by b.nr_seq_segurado;

/* Ressarcimento SUS */
 
C08 CURSOR FOR	 
	SELECT	0, 
		null 
	 
	where	1 = 2;
	

BEGIN 
 
ie_valor_mensalidade_w := Obter_Param_Usuario(1225, 16, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, ie_valor_mensalidade_w);
/*ie_valor_mensalidade_w	:= nvl(obter_valor_param_usuario(1225, 16, Obter_Perfil_Ativo, nm_usuario_p, 0), 'N');*/
 
 
qt_contador_pb_w	:= 0;
CALL gravar_processo_longo('Atualizar resultado competência' ,'PLS_GERAR_MARGEM_BENEFICIARIO',qt_contador_pb_w);
 
dt_referencia_w		:= trunc(dt_mes_referencia_p,'month');
dt_parametro_Inicio_w	:= trunc(dt_mes_referencia_p,'month');
dt_parametro_fim_w	:= last_day(dt_mes_referencia_p) + 86399/86400;
 
delete	from	pls_margem_beneficiario 
where	dt_mes_referencia >= dt_parametro_inicio_w 
and	dt_mes_referencia <= dt_parametro_fim_w;
 
/* Obter o valor total das contas contábeis de despesa assistencial - domínio 2406*/
 
select	coalesce(sum(CASE WHEN a.ie_tipo_operacao='B' THEN CASE WHEN a.ie_acao_conta='SO' THEN b.vl_movimento WHEN a.ie_acao_conta='SB' THEN b.vl_movimento * -1 END   ELSE 0 END ),0), 
	coalesce(sum(CASE WHEN a.ie_tipo_operacao='A' THEN CASE WHEN a.ie_acao_conta='SO' THEN b.vl_movimento WHEN a.ie_acao_conta='SB' THEN b.vl_movimento * -1 END   ELSE 0 END ),0), 
	coalesce(sum(CASE WHEN a.ie_tipo_operacao='P' THEN CASE WHEN a.ie_acao_conta='SO' THEN b.vl_movimento WHEN a.ie_acao_conta='SB' THEN b.vl_movimento * -1 END   ELSE 0 END ),0) 
into STRICT	vl_despesa_ops_w, 
	vl_despesa_acidente_w, 
	vl_despesa_pericia_w 
from	ctb_mes_ref	c, 
	ctb_balancete_v	b, 
	pls_ctb_despesa	a 
where	a.cd_conta_contabil		= b.cd_conta_contabil 
and	b.nr_seq_mes_ref		= c.nr_sequencia 
and	b.ie_normal_encerramento	= 'E' 
and	trunc(c.dt_referencia,'month')	= dt_referencia_w;
 
/* Felipe - 03/12/2009 - OS 177906 - Verificado com o CLaudinei que o correto é utilizar o crédito - débito */
 
select	coalesce(sum(CASE WHEN a.ie_tipo_operacao='B' THEN b.vl_debito - b.vl_credito  ELSE 0 END ),0), 
	coalesce(sum(CASE WHEN a.ie_tipo_operacao='A' THEN b.vl_debito - b.vl_credito  ELSE 0 END ),0), 
	coalesce(sum(CASE WHEN a.ie_tipo_operacao='P' THEN b.vl_debito - b.vl_credito  ELSE 0 END ),0) 
into STRICT	vl_imposto_ops_w, 
	vl_imposto_acidente_w, 
	vl_imposto_pericia_w 
from	ctb_mes_ref			c, 
	ctb_balancete_v			b, 
	pls_ctb_imposto_resultado	a 
where	a.cd_conta_contabil		= b.cd_conta_contabil 
and	b.nr_seq_mes_ref		= c.nr_sequencia 
and	b.ie_normal_encerramento	= 'E' 
and	trunc(c.dt_referencia,'month')	= dt_referencia_w;
 
select	coalesce(sum(CASE WHEN a.ie_tipo_operacao='B' THEN  CASE WHEN a.ie_acao_conta='SO' THEN b.vl_movimento WHEN a.ie_acao_conta='SB' THEN 	b.vl_movimento * -1 END   ELSE 0 END ),0), 
	coalesce(sum(CASE WHEN a.ie_tipo_operacao='A' THEN  CASE WHEN a.ie_acao_conta='SO' THEN b.vl_movimento WHEN a.ie_acao_conta='SB' THEN 	b.vl_movimento * -1 END   ELSE 0 END ),0), 
	coalesce(sum(CASE WHEN a.ie_tipo_operacao='P' THEN  CASE WHEN a.ie_acao_conta='SO' THEN b.vl_movimento WHEN a.ie_acao_conta='SB' THEN 	b.vl_movimento * -1 END   ELSE 0 END ),0) 
into STRICT	vl_provisao_ops_w, 
	vl_provisao_acidente_w, 
	vl_provisao_pericia_w 
from	ctb_mes_ref			c, 
	ctb_balancete_v			b, 
	pls_ctb_provisoes_tecnicas	a 
where	a.cd_conta_contabil		= b.cd_conta_contabil 
and	b.nr_seq_mes_ref		= c.nr_sequencia 
and	b.ie_normal_encerramento	= 'E' 
and	trunc(c.dt_referencia,'month')	= dt_referencia_w;
 
select	sum(vl_mensalidade) 
into STRICT	vl_total_mensalidade_w 
from (SELECT	sum(d.vl_item) vl_mensalidade 
	from	pls_segurado			e, 
		pls_mensalidade_seg_item	d, 
		pls_mensalidade_segurado	c, 
		pls_mensalidade			b, 
		pls_lote_mensalidade		a 
	where	d.nr_seq_mensalidade_seg = c.nr_sequencia 
	and	c.nr_seq_mensalidade	= b.nr_sequencia 
	and	b.nr_seq_lote		= a.nr_sequencia 
	and	c.nr_seq_segurado 	= e.nr_sequencia 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	a.ie_status	= 2 
	and	trunc(b.dt_referencia,'month') = dt_referencia_w 
	and	ie_valor_mensalidade_w = 'N' 
	and	coalesce(e.ie_tipo_vinculo_operadora::text, '') = '' 
	
union
 
	SELECT	sum(CASE WHEN coalesce(a.dt_contabilizacao::text, '') = '' THEN d.vl_antecipacao  ELSE 0 END ) vl_mensalidade 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_segurado		e, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	c.nr_seq_segurado = e.nr_sequencia 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	a.ie_status	= '2' 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'N' 
	and	trunc(d.dt_antecipacao,'month') = dt_referencia_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	coalesce(e.ie_tipo_vinculo_operadora::text, '') = '' 
	
union
 
	select	sum(d.vl_antecipacao) vl_mensalidade 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_segurado		e, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	c.nr_seq_segurado = e.nr_sequencia 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	d.ie_tipo_item	not in ('20','11') 
	and	(a.dt_contabilizacao IS NOT NULL AND a.dt_contabilizacao::text <> '') 
	and	a.ie_status	= '2' /* Lepinski - OS 342207 - Somente gerar no resumo, as informações de lotes em definitivo */
 
	and	trunc(d.dt_antecipacao,'month') = dt_referencia_w 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'N' 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	coalesce(e.ie_tipo_vinculo_operadora::text, '') = '' 
	
union
 
	select	sum(d.vl_pro_rata_dia) vl_mensalidade 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_segurado		e, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	c.nr_seq_segurado = e.nr_sequencia 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(b.ie_cancelamento::text, '') = '' 
	and	d.ie_tipo_item	not in ('20','11') 
	and	a.ie_status	= '2' 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'N' 
	and	trunc(c.dt_mesano_referencia,'month') = dt_referencia_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	coalesce(e.ie_tipo_vinculo_operadora::text, '') = '' 
	
union
 
	select	sum(d.vl_item) vl_mensalidade 
	from	pls_mensalidade_seg_item d, 
		pls_mensalidade_segurado c, 
		pls_segurado		e, 
		pls_mensalidade		b, 
		pls_lote_mensalidade	a 
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg 
	and	b.nr_sequencia	= c.nr_seq_mensalidade 
	and	c.nr_seq_segurado = e.nr_sequencia 
	and	a.nr_sequencia	= b.nr_seq_lote 
	and	coalesce(a.ie_mensalidade_mes_anterior,'N')	= 'S' 
	and	a.ie_status	= '2' 
	and	trunc(a.dt_mesano_referencia,'month') = dt_referencia_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_valor_mensalidade_w = 'S' 
	and	coalesce(e.ie_tipo_vinculo_operadora::text, '') = '') alias28;
	/*union 
	select	(sum(vl_mensalidade) - sum(vl_outros) + sum(vl_antecipacao) - sum(vl_coparticipacao_rembolso)) vl_mensalidade 
	from	pls_margem_mensalidade_seg_v 
	where  dt_mesano_referencia  = dt_referencia_w 
	and	dt_mesano_referencia	<> trunc(to_date('01/01/2010'),'Month') 
	and	ie_valor_mensalidade_w = 'S' 
	union 
	select	(sum(vl_mensalidade) - sum(vl_outros)) 
	from	pls_margem_mensalidade_seg_v 
	where  dt_mesano_referencia  = dt_referencia_w 
	and	dt_mesano_referencia	= trunc(to_date('01/01/2010'),'Month') 
	and	ie_valor_mensalidade_w = 'S');*/
 
 
open C01;
loop 
fetch C01 into	 
	vl_dominio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	qt_contador_pb_w	:= qt_contador_pb_w + 1;
	 
	ds_dominio_w		:= substr(Obter_Valor_Dominio(2236,vl_dominio_w),1,255);
	 
	CALL gravar_processo_longo('Atualizando o item de ' || ds_dominio_w,'PLS_GERAR_MARGEM_BENEFICIARIO',qt_contador_pb_w);
	 
	/* Mensalidade */
 
	if (vl_dominio_w	= 1) then 
		open C02;
		loop 
		fetch C02 into	 
			vl_mensalidade_w, 
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			begin 
			select	a.cd_cgc_estipulante, 
				a.cd_pf_estipulante, 
				coalesce(b.ie_tipo_segurado,'B'), 
				b.ie_tipo_vinculo_operadora 
			into STRICT	cd_cgc_estipulante_w, 
				cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w, 
				ie_tipo_vinculo_operadora_w 
			from	pls_segurado	b, 
				pls_contrato	a 
			where	a.nr_sequencia	= b.nr_seq_contrato 
			and	b.nr_sequencia	= nr_seq_segurado_w;
			exception 
				when others then 
				cd_cgc_estipulante_w	:= '';
				cd_pf_estipulante_w	:= '';
				ie_tipo_vinculo_operadora_w	:= null;
			end;
 
			if (ie_tipo_beneficiario_w	= 'B') then 
				vl_total_despesa_w		:= vl_despesa_ops_w;
				vl_total_imposto_w		:= vl_imposto_ops_w;
				vl_total_provisao_tecnica_w	:= vl_provisao_ops_w;
			elsif (ie_tipo_beneficiario_w	= 'A') then 
				vl_total_despesa_w		:= vl_despesa_acidente_w;
				vl_total_imposto_w		:= vl_imposto_acidente_w;
				vl_total_provisao_tecnica_w	:= vl_provisao_acidente_w;
			elsif (ie_tipo_beneficiario_w	= 'P') then 
				vl_total_despesa_w		:= vl_despesa_pericia_w;
				vl_total_imposto_w		:= vl_imposto_pericia_w;
				vl_total_provisao_tecnica_w	:= vl_provisao_pericia_w;
			end if;
 
			/* Mensalidade - 1 */
 
			insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
				dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
				ie_tipo_beneficiario) 
			values (	nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
				dt_referencia_w, '1', clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				vl_mensalidade_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w);
			 
			if (coalesce(ie_tipo_vinculo_operadora_w::text, '') = '') then 
				/* Despesas não assistênciais - 5 */
 
				pr_rateio_w	:= dividir((vl_mensalidade_w * 100),vl_total_mensalidade_w);
				vl_margem_w	:= dividir((pr_rateio_w * vl_total_despesa_w),100);
				vl_rateado_despesa_w	:= vl_rateado_despesa_w + vl_margem_w;
				 
				insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
					dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
					ie_tipo_beneficiario) 
				values (	nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
					dt_referencia_w, '5', clock_timestamp(), 
					nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
					ie_tipo_beneficiario_w);
				 
				/* Encargos - 6 */
 
				pr_rateio_w	:= 0;
				pr_rateio_w	:= dividir((vl_mensalidade_w * 100),vl_total_mensalidade_w);
				vl_margem_w	:= dividir((pr_rateio_w * vl_total_imposto_w),100);
				vl_rateado_imposto_w	:= vl_rateado_imposto_w + vl_margem_w;
				 
				select 	nextval('pls_margem_beneficiario_seq') 
				into STRICT 	nr_sequencia_w 
				;
				 
				insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
					dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
					ie_tipo_beneficiario) 
				values (	nr_sequencia_w, cd_estabelecimento_p, nr_seq_segurado_w, 
					dt_referencia_w, '6', clock_timestamp(), 
					nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
					ie_tipo_beneficiario_w);
				 
				/* Provisões técnicas - 9 */
 
				pr_rateio_w	:= 0;
				--pr_rateio_w	:= dividir((vl_mensalidade_w * 100),vl_total_mensalidade_w); 
				vl_margem_w	:= ((((vl_mensalidade_w * 100) / vl_total_mensalidade_w) * vl_total_provisao_tecnica_w) / 100);
				vl_rateado_provisao_w	:= vl_rateado_provisao_w + vl_margem_w;
				 
				select 	nextval('pls_margem_beneficiario_seq') 
				into STRICT 	nr_sequencia_w 
				;
				 
				insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
					dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
					ie_tipo_beneficiario) 
				values (	nr_sequencia_w, cd_estabelecimento_p, nr_seq_segurado_w, 
					dt_referencia_w, '9', clock_timestamp(), 
					nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
					ie_tipo_beneficiario_w);
			end if;
			end;
		end loop;
		close C02;
		 
		if (vl_total_despesa_w > 0) and (vl_rateado_despesa_w <> vl_total_despesa_w) then 
			update	pls_margem_beneficiario 
			set	vl_margem	= vl_margem + vl_total_despesa_w - vl_rateado_despesa_w 
			where	nr_sequencia	= (	SELECT	max(nr_sequencia) 
							from 	pls_margem_beneficiario 
							where (vl_margem + vl_total_despesa_w - vl_rateado_despesa_w) >= 0 
							and 	ie_tipo_valor = '5');
		end if;
		 
		if (vl_total_imposto_w > 0) and (vl_rateado_imposto_w <> vl_total_imposto_w) then 
			update	pls_margem_beneficiario 
			set	vl_margem	= vl_margem + vl_total_imposto_w - vl_rateado_imposto_w 
			where	nr_sequencia	= (	SELECT	max(nr_sequencia) 
							from 	pls_margem_beneficiario 
							where (vl_margem + vl_total_imposto_w - vl_rateado_imposto_w) >= 0 
							and 	ie_tipo_valor = '6');
		end if;
		 
		if (vl_total_provisao_tecnica_w > 0) and (vl_rateado_provisao_w <> vl_total_provisao_tecnica_w) then 
			update	pls_margem_beneficiario 
			set	vl_margem	= vl_margem + vl_total_provisao_tecnica_w - vl_rateado_provisao_w 
			where	nr_sequencia	= (	SELECT	max(nr_sequencia) 
							from 	pls_margem_beneficiario 
							where (vl_margem + vl_total_provisao_tecnica_w - vl_rateado_provisao_w) >= 0 
							and 	ie_tipo_valor = '9');
		end if;
 
	/* Contas médicas */
 
	elsif (vl_dominio_w	= 2) then 
		open C03;
		loop 
		fetch C03 into	 
			vl_margem_w, 
			nr_seq_segurado_w, 
			nr_seq_plano_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			 
			begin 
			select	coalesce(ie_tipo_segurado,'B') 
			into STRICT	ie_tipo_beneficiario_w 
			from	pls_segurado 
			where	nr_sequencia	= nr_seq_segurado_w;
			exception 
			when others then 
				ie_tipo_beneficiario_w	:= 'B';
			end;
			 
			if (ie_tipo_beneficiario_w in ('A','B','R')) then 
				begin 
				select	cd_cgc_estipulante, 
					cd_pf_estipulante 
				into STRICT	cd_cgc_estipulante_w, 
					cd_pf_estipulante_w 
				from	pls_segurado	b, 
					pls_contrato	a 
				where	a.nr_sequencia	= b.nr_seq_contrato 
				and	b.nr_sequencia	= nr_seq_segurado_w;
				exception 
					when others then 
					cd_cgc_estipulante_w	:= '';
					cd_pf_estipulante_w	:= '';
				end;
			elsif (ie_tipo_beneficiario_w in ('C','T')) then 
				begin 
				select	a.cd_cgc, 
					a.cd_pessoa_fisica 
				into STRICT	cd_cgc_estipulante_w, 
					cd_pf_estipulante_w 
				from	pls_segurado	b, 
					pls_intercambio	a 
				where	a.nr_sequencia	= b.nr_seq_intercambio 
				and	b.nr_sequencia	= nr_seq_segurado_w;
				exception 
					when others then 
					cd_cgc_estipulante_w	:= '';
					cd_pf_estipulante_w	:= '';
				end;
			elsif (ie_tipo_beneficiario_w in ('I','P')) then				 
				cd_cgc_estipulante_w	:= '';
				cd_pf_estipulante_w	:= '';
			end if;
			 
			insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
				dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
				ie_tipo_beneficiario,nr_seq_plano) 
			values (	nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
				dt_referencia_w, vl_dominio_w, clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w,nr_seq_plano_w);
			end;
		end loop;
		close C03;
 
	/* Reembolso */
 
	elsif (vl_dominio_w	= 3) then 
		open C04;
		loop 
		fetch C04 into	 
			vl_margem_w, 
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin 
			begin 
			select	cd_cgc_estipulante, 
				cd_pf_estipulante 
			into STRICT	cd_cgc_estipulante_w, 
				cd_pf_estipulante_w 
			from	pls_segurado	b, 
				pls_contrato	a 
			where	a.nr_sequencia	= b.nr_seq_contrato 
			and	b.nr_sequencia	= nr_seq_segurado_w;
			exception 
				when others then 
				cd_cgc_estipulante_w	:= '';
				cd_pf_estipulante_w	:= '';
			end;
			 
			insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
				dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
				ie_tipo_beneficiario) 
			values (	nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
				dt_referencia_w, vl_dominio_w, clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w);
			end;
		end loop;
		close C04;
	/* Comissão vendas */
 
	elsif (vl_dominio_w	= 4) then 
		open C05;
		loop 
		fetch C05 into	 
			vl_margem_w, 
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin 
			begin 
			select	cd_cgc_estipulante, 
				cd_pf_estipulante, 
				coalesce(ie_tipo_segurado,'B') 
			into STRICT	cd_cgc_estipulante_w, 
				cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w 
			from	pls_segurado	b, 
				pls_contrato	a 
			where	a.nr_sequencia	= b.nr_seq_contrato 
			and	b.nr_sequencia	= nr_seq_segurado_w;
			exception 
				when others then 
				cd_cgc_estipulante_w	:= '';
				cd_pf_estipulante_w	:= '';
			end;
			 
			insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
				dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
				ie_tipo_beneficiario) 
			values (	nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
				dt_referencia_w, vl_dominio_w, clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w);
			end;
		end loop;
		close C05;
	/* Ressarcimento SUS */
 
	elsif (vl_dominio_w	= 7) then 
		open C08;
		loop 
		fetch C08 into	 
			vl_margem_w, 
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on C08 */
			begin 
			begin 
			select	cd_cgc_estipulante, 
				cd_pf_estipulante, 
				ie_tipo_beneficiario 
			into STRICT	cd_cgc_estipulante_w, 
				cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w 
			from	pls_segurado	b, 
				pls_contrato	a 
			where	a.nr_sequencia	= b.nr_seq_contrato 
			and	b.nr_sequencia	= nr_seq_segurado_w;
			exception 
				when others then 
				cd_cgc_estipulante_w	:= '';
				cd_pf_estipulante_w	:= '';
			end;
			 
			insert into pls_margem_beneficiario(nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
				dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
				ie_tipo_beneficiario) 
			values (	nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
				dt_referencia_w, vl_dominio_w, clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				vl_margem_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w);
			end;
		end loop;
		close C08;
	/* Coparticipação */
 
	elsif (vl_dominio_w	= 11) then 
		open C06;
		loop 
		fetch C06 into	 
			vl_mensalidade_w, 
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin 
			 
			begin 
			select	cd_cgc_estipulante, 
				cd_pf_estipulante, 
				coalesce(ie_tipo_segurado,'B') 
			into STRICT	cd_cgc_estipulante_w, 
				cd_pf_estipulante_w, 
				ie_tipo_beneficiario_w 
			from	pls_segurado	b, 
				pls_contrato	a 
			where	a.nr_sequencia	= b.nr_seq_contrato 
			and	b.nr_sequencia	= nr_seq_segurado_w;
			exception 
				when others then 
				cd_cgc_estipulante_w	:= '';
				cd_pf_estipulante_w	:= '';
			end;
			 
			insert into pls_margem_beneficiario(	nr_sequencia, cd_estabelecimento, nr_seq_segurado, 
					dt_mes_referencia, ie_tipo_valor, dt_atualizacao, 
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
					vl_margem, cd_cgc_estipulante, cd_pf_estipulante, 
					ie_tipo_beneficiario) 
			values (		nextval('pls_margem_beneficiario_seq'), cd_estabelecimento_p, nr_seq_segurado_w, 
					dt_referencia_w, '11', clock_timestamp(), 
					nm_usuario_p, clock_timestamp(), nm_usuario_p, 
					vl_mensalidade_w, cd_cgc_estipulante_w, cd_pf_estipulante_w, 
					ie_tipo_beneficiario_w);
			end;
		end loop;
		close C06;
	 
	end if;
	end;
end loop;
close C01;
 
CALL pls_gerar_resultado(dt_referencia_w, cd_estabelecimento_p, nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_margem_beneficiario ( dt_mes_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

