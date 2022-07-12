-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_lote_audit_hist ( nr_seq_lote_hist_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

 
/*	ie_opcao_p 
'SI'	saldo inicial (saldo do item antes dele entrar na reapresentação de contas) 
'SA'	saldo atual do procedimento/material dentro do lote (considerando todas as análises do lote) 
'SAR'	saldo atual real (vl_amenor) 
'SIA'	saldo inicial do item dentro de uma mesma análise (antes de alterar os valores pago e glosado) 
'SAN'	saldo da análise anterior 
'SNN'	saldo atual da análise 
'SIP'	saldo da análise anterior (vl amenor) 
*/
 
 
vl_retorno_w		double precision := 0;
vl_guia_w		double precision;
vl_glosa_w		double precision;
vl_pago_w		double precision;
nr_analise_w		bigint;
nr_seq_lote_audit_w	bigint;
nr_interno_conta_w	bigint;
cd_autorizacao_w	varchar(20);

c01 CURSOR FOR 
SELECT	distinct 
	a.nr_interno_conta, 
	a.cd_autorizacao 
from	lote_audit_hist_guia a 
where	a.nr_seq_lote_hist	= nr_seq_lote_hist_p;


BEGIN 
 
if (ie_opcao_p = 'SAN') then 
 
	select	max(a.nr_analise), 
		max(a.nr_seq_lote_audit) 
	into STRICT	nr_analise_w, 
		nr_seq_lote_audit_w 
	from	lote_audit_hist a 
	where	a.nr_sequencia	= nr_seq_lote_hist_p;
 
	if (nr_analise_w = 1) then 
 
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
 
			vl_retorno_w	:= coalesce(vl_retorno_w,0) + (coalesce(vl_guia_w,0) - coalesce(vl_glosa_w,0) - coalesce(vl_pago_w,0));
 
		end	loop;
		close	c01;	
 
	else 
 
		select	coalesce(sum(obter_saldo_lote_audit_guia(b.nr_sequencia,'SNN')),0) 
		into STRICT	vl_retorno_w 
		from	lote_audit_hist_guia b, 
			lote_audit_hist a 
		where	a.nr_seq_lote_audit	= nr_seq_lote_audit_w 
		and	a.nr_analise		= coalesce(nr_analise_w,0) - 1 
		and	a.nr_sequencia		= b.nr_seq_lote_hist;
 
	end if;
 
elsif (ie_opcao_p = 'SNN') then 
 
	select	coalesce(sum(obter_saldo_lote_audit_guia(a.nr_sequencia,'SNN')),0) 
	into STRICT	vl_retorno_w 
	from	lote_audit_hist_guia a 
	where	a.nr_seq_lote_hist	= nr_seq_lote_hist_p;
 
elsif (ie_opcao_p = 'SIP') then 
 
	select	max(a.nr_analise), 
		max(a.nr_seq_lote_audit) 
	into STRICT	nr_analise_w, 
		nr_seq_lote_audit_w 
	from	lote_audit_hist a 
	where	a.nr_sequencia	= nr_seq_lote_hist_p;
 
	if (nr_analise_w <= 1) then 
 
		select	coalesce(sum(a.vl_saldo_guia),0) 
		into STRICT	vl_retorno_w 
		from	lote_audit_hist_guia a 
		where	a.nr_seq_lote_hist	= nr_seq_lote_hist_p;
 
	else 
 
		select	coalesce(sum(c.vl_amenor),0) 
		into STRICT	vl_retorno_w 
		from	lote_audit_hist_item c, 
			lote_audit_hist_guia b, 
			lote_audit_hist a 
		where	a.nr_seq_lote_audit	= nr_seq_lote_audit_w 
		and	a.nr_analise		= coalesce(nr_analise_w,2) - 1 
		and	a.nr_sequencia		= b.nr_seq_lote_hist 
		and	b.nr_sequencia		= c.nr_seq_guia;
 
	end if;
 
elsif (ie_opcao_p = 'SAR') then 
 
	select	coalesce(sum(b.vl_amenor),0) 
	into STRICT	vl_retorno_w 
	from	lote_audit_hist_item b, 
		lote_audit_hist_guia a 
	where	a.nr_seq_lote_hist	= nr_seq_lote_hist_p 
	and	a.nr_sequencia		= b.nr_seq_guia;
 
else 
 
	select	coalesce(sum(obter_saldo_lote_audit_guia(a.nr_sequencia,ie_opcao_p)),0) 
	into STRICT	vl_retorno_w 
	from	lote_audit_hist_guia a 
	where	a.nr_seq_lote_hist	= nr_seq_lote_hist_p;
 
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_lote_audit_hist ( nr_seq_lote_hist_p bigint, ie_opcao_p text) FROM PUBLIC;

