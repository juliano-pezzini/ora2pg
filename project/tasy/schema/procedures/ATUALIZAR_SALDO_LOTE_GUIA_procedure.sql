-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_saldo_lote_guia (nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* NÃO DAR COMMIT NESTA PROCEDURE - ahoffelder 10/04/2010 */

vl_pago_w		double precision;
vl_glosa_w		double precision;
vl_saldo_guia_w		double precision;
cd_convenio_w		integer;
vl_saldo_conpaci_w	double precision:= 0;

BEGIN

select	coalesce(sum(a.vl_pago),0),
	coalesce(sum(a.vl_glosa),0)
into STRICT	vl_pago_w,
	vl_glosa_w
from	lote_audit_hist_baixa a
where	a.nr_seq_guia	= nr_seq_guia_p;

select	max(c.cd_convenio)
into STRICT	cd_convenio_w
from	lote_auditoria c,
	lote_audit_hist b,
	lote_audit_hist_guia a
where	a.nr_sequencia		= nr_seq_guia_p
and	a.nr_seq_lote_hist	= b.nr_sequencia
and	b.nr_seq_lote_audit	= c.nr_sequencia;




select	coalesce(max(w.vl_saldo_guia),0)
into STRICT	vl_saldo_guia_w
from (
	/* 1ª análise - guias sem retorno */

	SELECT	coalesce(b.vl_guia,0) vl_saldo_guia
	from	lote_audit_hist c,
		conta_paciente_guia b,
		lote_audit_hist_guia a
	where	a.nr_sequencia		= nr_seq_guia_p
	and	a.nr_interno_conta	= b.nr_interno_conta
	and	a.cd_autorizacao	= b.cd_autorizacao
	and	not exists (SELECT	1
		from	convenio_retorno y,
			convenio_retorno_item x
		where	x.nr_interno_conta	= a.nr_interno_conta
		and	x.cd_autorizacao	= a.cd_autorizacao
		and	x.nr_seq_retorno	= y.nr_sequencia
		and	y.cd_convenio		= cd_convenio_w)
	and	a.nr_seq_lote_hist	= c.nr_sequencia
	and	c.nr_analise		= 1
	/* 1ª análise - guias do retorno */

	
union

	select	coalesce(b.vl_guia - b.vl_pago + b.vl_glosado,0) vl_saldo_guia
	from	lote_audit_hist d,
		convenio_retorno c,
		convenio_retorno_item b,
		lote_audit_hist_guia a
	where	a.nr_sequencia		= nr_seq_guia_p
	and	a.nr_seq_retorno	= b.nr_seq_retorno
	and	a.nr_interno_conta	= b.nr_interno_conta
	and	a.cd_autorizacao	= b.cd_autorizacao
	and	b.nr_seq_retorno	= c.nr_sequencia
	and	c.cd_convenio		= cd_convenio_w
	and	a.nr_seq_lote_hist	= d.nr_sequencia
	and	d.nr_analise		= 1
	/* 2ª análise adiante - saldo atualizado */

	
union

	select	coalesce(a.vl_saldo_guia,0)
	from	lote_audit_hist b,
		lote_audit_hist_guia a
	where	a.nr_sequencia		= nr_seq_guia_p
	and	a.nr_seq_lote_hist	= b.nr_sequencia
	and	b.nr_analise		> 1
	) w;

if (coalesce(vl_saldo_guia_w,0) = 0) then

	select	coalesce(max(obter_saldo_conpaci(nr_interno_conta,cd_autorizacao)),0)
	into STRICT	vl_saldo_conpaci_w
	from	lote_audit_hist_guia
	where	nr_sequencia = nr_seq_guia_p;

end if;

if (coalesce(vl_saldo_conpaci_w,0) = 0) and (coalesce(vl_saldo_guia_w,0) = 0) then

	update	lote_audit_hist_guia
	set	vl_saldo_guia	= 0,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_guia_p;
else
	update	lote_audit_hist_guia
	set	vl_saldo_guia	= (vl_saldo_guia_w - vl_glosa_w - vl_pago_w),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_guia_p;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_saldo_lote_guia (nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;

