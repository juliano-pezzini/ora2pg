-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_lote_audit_guia (nr_seq_lote_guia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

 
ie_guia_sem_saldo_w   varchar(255);
cd_autorizacao_w	varchar(255);
nr_analise_w      bigint;
nr_interno_conta_w   bigint;
nr_seq_lote_hist_w	bigint;
vl_guia_w		double precision;
vl_glosa_w		double precision;
vl_pago_w		double precision;
vl_retorno_w      double precision := 0;
nr_seq_lote_audit_w	bigint;

/*   ie_opcao_p 
'SI'  saldo inicial (saldo do item antes dele entrar na reapresentação de contas) 
'SA'  saldo atual do procedimento/material dentro do lote (considerando todas as análises do lote) 
'SAR'  saldo atual real (vl_amenor) 
'SIA'  saldo inicial do item dentro de uma mesma análise (antes de alterar os valores pago e glosado) 
'SAN'	saldo anterior à análise atual 
'SIP'	saldo da guia na análise anterior 
*/
 
 

BEGIN 
 
select	coalesce(a.ie_guia_sem_saldo, 'N'), 
	b.nr_analise, 
	a.nr_interno_conta, 
	a.cd_autorizacao, 
	b.nr_sequencia 
into STRICT	ie_guia_sem_saldo_w, 
	nr_analise_w, 
	nr_interno_conta_w, 
	cd_autorizacao_w, 
	nr_seq_lote_hist_w 
from	lote_audit_hist b, 
	lote_audit_hist_guia a 
where	a.nr_sequencia		= nr_seq_lote_guia_p 
and	a.nr_Seq_lote_hist	= b.nr_sequencia;
 
if (ie_guia_sem_saldo_w = 'S') then 
    vl_retorno_w  := 0;
elsif	((nr_analise_w = 1) or (ie_opcao_p = 'SA')) and (ie_opcao_p <> 'SAN') and (ie_opcao_p <> 'SNN') and (ie_opcao_p <> 'SIP') and (ie_opcao_p <> 'SAR') then 
     
	vl_retorno_w	:= (obter_saldo_conpaci(nr_interno_conta_w,cd_autorizacao_w))::numeric;
 
elsif (ie_opcao_p = 'SAN') then 
 
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
 
		SELECT	b.vl_glosa, 
			b.vl_pago 
		from	lote_audit_hist c, 
			lote_audit_hist_item b, 
			lote_audit_hist_guia a 
		where	a.nr_interno_conta	= nr_interno_conta_w 
		and	coalesce(a.cd_autorizacao,'0')	= coalesce(cd_autorizacao_w,'0') 
		and	a.nr_sequencia		= b.nr_seq_guia 
		and	a.nr_seq_lote_hist	= c.nr_sequencia 
		and	c.nr_analise		< nr_analise_w 
		and	(c.dt_envio IS NOT NULL AND c.dt_envio::text <> '')) alias6;
 
	vl_retorno_w	:= coalesce(vl_guia_w,0) - coalesce(vl_glosa_w,0) - coalesce(vl_pago_w,0);
 
elsif (ie_opcao_p = 'SNN') then 
 
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
 
		SELECT	b.vl_glosa, 
			b.vl_pago 
		from	lote_audit_hist c, 
			lote_audit_hist_item b, 
			lote_audit_hist_guia a 
		where	a.nr_interno_conta	= nr_interno_conta_w 
		and	coalesce(a.cd_autorizacao,'0')	= coalesce(cd_autorizacao_w,'0') 
		and	a.nr_sequencia		= b.nr_seq_guia 
		and	a.nr_seq_lote_hist	= c.nr_sequencia 
		and	c.nr_analise		<= nr_analise_w) alias5;
 
	vl_retorno_w	:= coalesce(vl_guia_w,0) - coalesce(vl_glosa_w,0) - coalesce(vl_pago_w,0);
 
elsif (ie_opcao_p = 'SIP') then 
 
	select	max(b.nr_analise), 
		max(b.nr_seq_lote_audit), 
		max(a.nr_interno_conta), 
		max(a.cd_autorizacao) 
	into STRICT	nr_analise_w, 
		nr_seq_lote_audit_w, 
		nr_interno_conta_w, 
		cd_autorizacao_w 
	from	lote_audit_hist b, 
		lote_audit_hist_guia a 
	where	a.nr_sequencia		= nr_seq_lote_guia_p 
	and	a.nr_seq_lote_hist	= b.nr_sequencia;
 
	if (nr_analise_w <= 1) then 
 
		select	coalesce(max(a.vl_saldo_guia),0) 
		into STRICT	vl_retorno_w 
		from	lote_audit_hist_guia a 
		where	a.nr_sequencia	= nr_seq_lote_guia_p;
 
	else 
 
		select	coalesce(sum(c.vl_amenor),0) 
		into STRICT	vl_retorno_w 
		from	lote_audit_hist_item c, 
			lote_audit_hist_guia b, 
			lote_audit_hist a 
		where	a.nr_seq_lote_audit	= nr_seq_lote_audit_w 
		and	a.nr_analise		= coalesce(nr_analise_w,2) - 1 
		and	a.nr_sequencia		= b.nr_seq_lote_hist 
		and	b.nr_interno_conta	= nr_interno_conta_w 
		and	coalesce(b.cd_autorizacao,'0')	= coalesce(cd_autorizacao_w,'0') 
		and	b.nr_sequencia		= c.nr_seq_guia;
 
	end if;
 
elsif (ie_opcao_p = 'SAR') then 
 
	select	coalesce(sum(a.vl_amenor),0) 
	into STRICT	vl_retorno_w 
	from	lote_audit_hist_item a 
	where	nr_seq_guia	= nr_seq_lote_guia_p;
 
else 
 
    select	coalesce(sum(obter_saldo_lote_audit_item(a.nr_sequencia, ie_opcao_p)),0) 
    into STRICT	vl_retorno_w 
    from	lote_audit_hist_item a 
    where	a.nr_seq_guia  = nr_seq_lote_guia_p;
 
end if;
 
return vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_lote_audit_guia (nr_seq_lote_guia_p bigint, ie_opcao_p text) FROM PUBLIC;

