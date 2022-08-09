-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fechar_lote_audit_hist (nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE

/*
ie_acao_p
	'F' - Fechar o lote
	'A' - Reabrir o lote
*/
ie_status_w		varchar(1);
dt_envio_w		timestamp;
dt_baixa_glosa_w		timestamp;
vl_glosa_w		double precision;
nr_interno_conta_w		bigint;
cd_autorizacao_w		varchar(20);
nr_seq_lote_guia_w		bigint;
vl_saldo_guia_w		double precision;
vl_saldo_anterior_w		double precision;
ie_guia_sem_saldo_w	varchar(1);
cd_estabelecimento_w	bigint;
IE_REPASSE_GRG_W	varchar(10);
IE_GLOSA_POSTERIOR_W	varchar(10);


c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_interno_conta,
	a.cd_autorizacao,
	a.vl_saldo_guia
from	lote_audit_hist_guia a
where	a.nr_seq_lote_hist	= nr_seq_lote_p;


BEGIN

select	b.dt_envio,
	a.cd_estabelecimento
into STRICT	dt_envio_w,
	cd_estabelecimento_w
from	convenio c,
	lote_auditoria a,
	lote_audit_hist b
where	b.nr_sequencia		= nr_seq_lote_p
and	b.nr_seq_lote_audit		= a.nr_sequencia
and	a.cd_convenio		= c.cd_convenio;

select	coalesce(max(IE_REPASSE_GRG),'N'),
	coalesce(max(IE_GLOSA_POSTERIOR),'N')
into STRICT	IE_REPASSE_GRG_W,
	IE_GLOSA_POSTERIOR_W
from	PARAMETRO_REPASSE
where	cd_estabelecimento = cd_estabelecimento_w;

if (ie_acao_p	= 'A') then

	if (coalesce(dt_envio_w::text, '') = '') then
		ie_status_w	:= 'A';
	else
		ie_status_w	:= 'E';
	end if;

	update	lote_audit_hist
	set	dt_fechamento	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		ie_status		= ie_status_w
--		dt_baixa_glosa	= null
	where	nr_sequencia	= nr_seq_lote_p;

	open c01;
	loop
	fetch	c01 into
		nr_seq_lote_guia_w,
		nr_interno_conta_w,
		cd_autorizacao_w,
		vl_saldo_anterior_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		update	lote_audit_hist_guia
		set	vl_saldo_guia		= coalesce(vl_saldo_original,vl_saldo_guia)
		where	nr_sequencia		= nr_seq_lote_guia_w;

	end loop;
	close c01;

elsif (ie_acao_p	= 'F') then

	/* ahoffelder - OS 263397 - 03/11/2010 */

	/*open c01;
	loop
	fetch	c01 into
		nr_seq_lote_guia_w,
		nr_interno_conta_w,
		cd_autorizacao_w,
		vl_saldo_anterior_w;
	exit	when c01%notfound;

		vl_saldo_guia_w	:= to_number(obter_saldo_conpaci(nr_interno_conta_w,cd_autorizacao_w));

		if	(nvl(vl_saldo_guia_w,vl_saldo_anterior_w) = 0) then
			ie_guia_sem_saldo_w	:= 'S';
		else
			ie_guia_sem_saldo_w	:= 'N';
		end if;


		update	lote_audit_hist_guia
		set	vl_saldo_original	= vl_saldo_guia
		where	nr_sequencia		= nr_seq_lote_guia_w;

		update	lote_audit_hist_guia
		set	vl_saldo_guia		= nvl(vl_saldo_guia_w,vl_saldo_guia),
			ie_guia_sem_saldo		= ie_guia_sem_saldo_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= sysdate
		where	nr_sequencia		= nr_seq_lote_guia_w;

	end loop;
	close c01;*/
	/*select	sum(a.vl_glosa)
	into	vl_glosa_w
	from	lote_audit_hist_item a,
		lote_audit_hist_guia b
	where	b.nr_seq_lote_hist		= nr_seq_lote_p
	and	b.nr_sequencia		= a.nr_seq_guia
	and	nvl(b.vl_saldo_guia,0)	> 0;

	if	(nvl(vl_glosa_w,0)	> 0) then
		dt_baixa_glosa_w	:= null;
	else
		dt_baixa_glosa_w	:= sysdate;
	end if;*/
	update	lote_audit_hist
	set	dt_fechamento		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_status			= 'F'
		--dt_baixa_glosa		= dt_baixa_glosa_w
	where	nr_sequencia		= nr_seq_lote_p;

end if;

CALL atualizar_valor_lote_recurso(nr_seq_lote_p, ie_acao_p, nm_usuario_p);

if (IE_REPASSE_GRG_W in ('S','P')) and (ie_acao_p = 'F') then
	CALL fechar_retorno_repasse(null, nr_seq_lote_p, null, nm_usuario_p);
end if;

if (IE_GLOSA_POSTERIOR_W = 'S') or (IE_GLOSA_POSTERIOR_W = 'T') then
	CALL GERAR_GLOSA_POSTERIOR(nr_seq_lote_p, nm_usuario_p,ie_glosa_posterior_w,ie_acao_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fechar_lote_audit_hist (nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
