-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_lote_auditoria ( nr_seq_lote_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

 
/*	ie_opcao_p 
'SI'	saldo inicial (saldo do item antes dele entrar na reapresentação de contas) 
'SA'	saldo atual do procedimento/material dentro do lote (considerando todas as análises do lote) 
'SAR'	saldo atual real (vl_amenor) 
'SIA'	saldo inicial do item dentro de uma mesma análise (antes de alterar os valores pago e glosado) 
'SAN'	saldo anterior do lote 
'SNN'	saldo atual do lote 
'SIP'	saldo inicial da primeira análise 
*/
 
 
vl_pago_w		double precision;
vl_glosa_w		double precision;
vl_guia_w		double precision;
vl_retorno_w		double precision	:= 0;
nr_seq_analise_w	bigint;
nr_interno_conta_w	bigint;
cd_autorizacao_w	varchar(20);

vl_total_guia_w		double precision;
vl_total_ret_w		double precision;

c01 CURSOR FOR 
SELECT	distinct 
	b.nr_interno_conta, 
	b.cd_autorizacao 
from	lote_audit_hist_guia b, 
	lote_audit_hist a 
where	a.nr_seq_lote_audit	= nr_seq_lote_p 
and	a.nr_sequencia		= b.nr_seq_lote_hist;


BEGIN 
 
if	((ie_opcao_p = 'SI') or (ie_opcao_p = 'SIA')) then	/* quando for o saldo anterior, busca o saldo da primeira análise do lote */
 
 
	select	a.nr_sequencia 
	into STRICT	nr_seq_analise_w 
	from	lote_audit_hist a 
	where	a.nr_seq_lote_audit	= nr_seq_lote_p 
	and	a.nr_analise		= 1;
 
	vl_retorno_w	:= coalesce(obter_saldo_lote_audit_hist(nr_seq_analise_w, ie_opcao_p),0);
 
elsif	((ie_opcao_p = 'SA') or (ie_opcao_p = 'SAR')) then	/* quando for o saldo atual, busca o saldo da última análise do lote */
 
 
	nr_seq_analise_w	:= obter_ultima_analise(nr_seq_lote_p);
 
	vl_retorno_w	:= coalesce(obter_saldo_lote_audit_hist(nr_seq_analise_w, ie_opcao_p),0);
 
elsif (ie_opcao_p = 'SAN') then 
 
	open	c01;
	loop 
	fetch	c01 into 
		nr_interno_conta_w, 
		cd_autorizacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		select	sum(a.vl_guia) 
		into STRICT	vl_guia_w 
		from	conta_paciente_guia a 
		where	a.nr_interno_conta		= nr_interno_conta_w 
		and	coalesce(a.cd_autorizacao,'0')	= coalesce(cd_autorizacao_w,coalesce(a.cd_autorizacao,'0'));
 
		vl_total_guia_w	:= coalesce(vl_total_guia_w,0) + coalesce(vl_guia_w,0);
 
		select	sum(a.vl_glosado), 
			sum(a.vl_pago) 
		into STRICT	vl_glosa_w, 
			vl_pago_w 
		from	convenio_retorno b, 
			convenio_retorno_item a 
		where	a.nr_interno_conta	= nr_interno_conta_w 
		and	a.cd_autorizacao	= coalesce(cd_autorizacao_w,a.cd_autorizacao) 
		and	a.nr_seq_retorno	= b.nr_sequencia 
		and	b.ie_status_retorno	= 'F';
 
		vl_total_ret_w	:= coalesce(vl_total_ret_w,0) + coalesce(vl_glosa_w,0) + coalesce(vl_pago_w,0);
 
	end	loop;
	close	c01;
 
	vl_retorno_w	:= coalesce(vl_total_guia_w,0) - coalesce(vl_total_ret_w,0);
 
elsif (ie_opcao_p = 'SNN') then 
 
	open	c01;
	loop 
	fetch	c01 into 
		nr_interno_conta_w, 
		cd_autorizacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		select	sum(a.vl_guia) 
		into STRICT	vl_guia_w 
		from	conta_paciente_guia a 
		where	a.nr_interno_conta	= nr_interno_conta_w 
		and	a.cd_autorizacao	= coalesce(cd_autorizacao_w,a.cd_autorizacao);
 
		select	sum(vl_glosa), 
			sum(vl_pago) 
		into STRICT	vl_glosa_w, 
			vl_pago_w 
		from (SELECT	a.vl_glosado vl_glosa, 
				a.vl_pago 
			from	convenio_retorno b, 
				convenio_retorno_item a 
			where	a.nr_interno_conta	= nr_interno_conta_w 
			and	a.cd_autorizacao	= coalesce(cd_autorizacao_w,a.cd_autorizacao) 
			and	a.nr_seq_retorno	= b.nr_sequencia 
			and	b.ie_status_retorno	= 'F' 
			
union
 
			SELECT	c.vl_glosa, 
				c.vl_pago 
			from	lote_audit_hist_item c, 
				lote_audit_hist_guia b, 
				lote_audit_hist a 
			where	a.nr_seq_lote_audit	= nr_seq_lote_p 
			and	a.nr_sequencia		= b.nr_seq_lote_hist 
			and	b.nr_interno_conta	= nr_interno_conta_w 
			and	coalesce(b.cd_autorizacao,coalesce(cd_autorizacao_w,'0'))	= coalesce(cd_autorizacao_w,'0') 
			and	b.nr_sequencia		= c.nr_seq_guia) alias6;
 
		vl_retorno_w	:= coalesce(vl_retorno_w,0) + (coalesce(vl_guia_w,0) - coalesce(vl_glosa_w,0) - coalesce(vl_pago_w,0));
 
	end	loop;
	close	c01;
 
elsif (ie_opcao_p = 'SIP') then 
 
	select	sum(b.vl_saldo_guia) 
	into STRICT	vl_retorno_w 
	from	lote_audit_hist_guia b, 
		lote_audit_hist a 
	where	a.nr_seq_lote_audit	= nr_seq_lote_p 
	and	a.nr_analise		= 1 
	and	a.nr_sequencia		= b.nr_seq_lote_hist;
 
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_lote_auditoria ( nr_seq_lote_p bigint, ie_opcao_p text) FROM PUBLIC;
