-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_repasse_pago_proc ( nr_seq_retorno_p bigint, nr_seq_grg_p bigint, nr_seq_ret_glosa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_proc_repasse_w		bigint;
nr_seq_ret_item_w		bigint;
dt_retorno_w			timestamp;
nr_interno_conta_w		bigint;
nr_seq_lote_audit_hist_w	bigint;
ie_status_w			varchar(255);
vl_liberado_w			double precision;
vl_repasse_w			double precision;
ie_repasse_grg_w		varchar(1);
cd_estabelecimento_w		smallint;
ie_data_grg_ret_w		varchar(1);
cd_autorizacao_w		varchar(20);
ie_repasse_retorno_w		parametro_repasse.ie_repasse_retorno%type;
vl_desconto_w			convenio_retorno_item.vl_desconto%type;
vl_original_repasse_w		procedimento_repasse.vl_original_repasse%type;
vl_desconto_item_w		procedimento_repasse.vl_desconto%type;
vl_guia_w			double precision;

c01 CURSOR FOR
SELECT	a.nr_interno_conta,
	a.nr_sequencia,
	null nr_seq_lote,
	a.cd_autorizacao,
	coalesce((select	max(x.vl_desconto)
	from	convenio_retorno_item x
	where	x.nr_sequencia = a.nr_sequencia
	and	not	exists (	select	1
				from	convenio_retorno_glosa y
				where	y.nr_seq_ret_item = x.nr_sequencia
				and	y.vl_desconto_item <> 0)),0)
from	convenio_retorno_item a
where	a.nr_seq_retorno		= nr_seq_retorno_p
and	a.vl_pago			<> 0
and	((ie_repasse_retorno_w = 'S') or (ie_repasse_retorno_w = 'P' and a.vl_amenor = 0))

union all

select	b.nr_interno_conta,
	null,
	b.nr_seq_lote_hist,
	b.cd_autorizacao,
	0
from	lote_audit_hist_guia b,
	lote_audit_hist_item a
where	a.nr_seq_guia			= b.nr_sequencia
and	ie_repasse_grg_w = 'P'
and	a.vl_pago <> 0
and	b.nr_seq_lote_hist		= nr_seq_grg_p;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ie_status,
	a.vl_liberado,
	a.vl_repasse,
	a.vl_original_repasse
from	procedimento_repasse a,
	procedimento_paciente b
where	a.nr_seq_procedimento			= b.nr_sequencia
and	b.nr_interno_conta			= nr_interno_conta_w
and	a.ie_status				in ('A','U')
--and	(((ie_repasse_grg_w = 'P') and (a.nr_seq_lote_audit_hist is null)) or (ie_repasse_grg_w in ('S','N')))
and	not exists (select	1
			from	convenio_retorno_glosa x
			where	x.nr_seq_propaci	= b.nr_sequencia
			and	x.vl_cobrado	= x.vl_glosa
			and	coalesce(x.vl_cobrado,0)	<> 0
			and	coalesce(x.vl_glosa,0) <> 0
			and	coalesce(x.nr_seq_partic,0) = coalesce(a.nr_seq_partic,0)
			and	x.nr_seq_ret_item = nr_seq_ret_item_w)
and	coalesce(nr_seq_ret_glosa_p, b.nr_sequencia)	= b.nr_sequencia
and	((coalesce(a.nr_seq_item_retorno, -1)		<> coalesce(nr_seq_ret_item_w,-1) and (nr_seq_ret_item_w IS NOT NULL AND nr_seq_ret_item_w::text <> '')) or (coalesce(nr_seq_ret_item_w::text, '') = ''))
and	coalesce(nr_seq_lote_audit_hist_w::text, '') = ''
and	coalesce(b.nr_doc_convenio,coalesce(cd_autorizacao_w,'Não Informada')) = coalesce(cd_autorizacao_w,'Não Informada')

union

select	a.nr_sequencia,
	a.ie_status,
	a.vl_liberado,
	a.vl_repasse,
	a.vl_original_repasse
from	procedimento_repasse a,
	procedimento_paciente b
where	a.nr_seq_procedimento		= b.nr_sequencia
and	b.nr_interno_conta		= nr_interno_conta_w
and	a.ie_status			in ('A','U')
and	coalesce(nr_seq_ret_glosa_p, b.nr_sequencia)	= b.nr_sequencia
and	(((ie_repasse_grg_w = 'P') and (coalesce(a.nr_seq_lote_audit_hist::text, '') = '')) or (ie_repasse_grg_w in ('S','N')))
and (coalesce(nr_seq_lote_audit_hist_w::text, '') = '' or coalesce(a.nr_seq_lote_audit_hist, -1) <> nr_seq_lote_audit_hist_w)
and	ie_repasse_grg_w		= 'P'
and	coalesce(nr_seq_ret_item_w::text, '') = ''
and	coalesce(b.nr_doc_convenio,coalesce(cd_autorizacao_w,'Não Informada')) = coalesce(cd_autorizacao_w,'Não Informada');


BEGIN
select	a.cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	parametro_faturamento b,
	convenio_retorno a
where	a.nr_sequencia		= nr_seq_retorno_p
and	a.cd_estabelecimento	= b.cd_estabelecimento

union

SELECT	a.cd_estabelecimento
from	parametro_faturamento b,
	lote_auditoria a,
	lote_audit_hist c
where	c.nr_sequencia		= nr_seq_grg_p
and	a.nr_sequencia		= c.nr_seq_lote_audit
and	a.cd_estabelecimento	= b.cd_estabelecimento;

select	coalesce(max(ie_data_lib_repasse_grg),'G'),
	coalesce(max(ie_repasse_retorno),'S')
into STRICT	ie_data_grg_ret_w,
	ie_repasse_retorno_w
from	parametro_repasse
where	cd_estabelecimento	= cd_estabelecimento_w;

if (nr_seq_retorno_p IS NOT NULL AND nr_seq_retorno_p::text <> '') then

	select	CASE WHEN b.ie_data_lib_repasse_ret='F' THEN  coalesce(a.dt_baixa_cr, a.dt_fechamento) WHEN b.ie_data_lib_repasse_ret='R' THEN  a.dt_retorno WHEN b.ie_data_lib_repasse_ret='E' THEN  a.dt_fechamento END
	into STRICT	dt_retorno_w
	from	parametro_faturamento b,
		convenio_retorno a
	where	a.nr_sequencia		= nr_seq_retorno_p
	and	a.cd_estabelecimento	= b.cd_estabelecimento;

end if;

if (nr_seq_grg_p IS NOT NULL AND nr_seq_grg_p::text <> '') then
	if (coalesce(ie_data_grg_ret_w,'G')	= 'G') then

		select	c.dt_fechamento
		into STRICT	dt_retorno_w
		from	lote_auditoria a,
			lote_audit_hist c
		where	c.nr_sequencia		= nr_seq_grg_p
		and	a.nr_sequencia		= c.nr_seq_lote_audit;

	elsif (coalesce(ie_data_grg_ret_w,'G')	= 'R') then

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
end if;

select	coalesce(max(a.ie_repasse_grg),'N')
into STRICT	ie_repasse_grg_w
from	parametro_repasse a
where	a.cd_estabelecimento	= cd_estabelecimento_w;

open c01;
loop
fetch c01 into
	nr_interno_conta_w,
	nr_seq_ret_item_w,
	nr_seq_lote_audit_hist_w,
	cd_autorizacao_w,
	vl_desconto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	vl_guia_w	:= obter_valor_conpaci_guia(nr_interno_conta_w, cd_autorizacao_w, 1);

	open c02;
	loop
	fetch c02 into
		nr_seq_proc_repasse_w,
		ie_status_w,
		vl_liberado_w,
		vl_repasse_w,
		vl_original_repasse_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		vl_desconto_item_w	:= (vl_desconto_w/vl_guia_w)*coalesce(vl_original_repasse_w,0);

		update	procedimento_repasse
		set	nr_seq_item_retorno	= nr_seq_ret_item_w,
			vl_repasse		= vl_repasse - vl_desconto_item_w,
			vl_liberado		= vl_repasse - vl_desconto_item_w,
			ie_status		= 'R',
			dt_liberacao		= dt_retorno_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario_lib		= nm_usuario_p,
			nr_seq_lote_audit_hist	= nr_seq_lote_audit_hist_w,
			vl_desconto		= CASE WHEN coalesce(vl_desconto,0)=0 THEN vl_desconto_item_w  ELSE vl_desconto END
		where	nr_sequencia		= nr_seq_proc_repasse_w;

		CALL GRAVAR_PROC_REPASSE_VALOR(	WHEB_MENSAGEM_PCK.get_texto(303757),
						nm_usuario_p,
						ie_status_w,
						'R',
						vl_liberado_w,
						vl_repasse_w,
						nr_seq_retorno_p,
						nr_seq_grg_p,
						nr_seq_proc_repasse_w,
						null);

	end loop;
	close c02;

end loop;
close c01;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_repasse_pago_proc ( nr_seq_retorno_p bigint, nr_seq_grg_p bigint, nr_seq_ret_glosa_p bigint, nm_usuario_p text) FROM PUBLIC;

