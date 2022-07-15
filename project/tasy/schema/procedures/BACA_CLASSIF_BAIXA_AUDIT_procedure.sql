-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_classif_baixa_audit (nm_usuario_p text) AS $body$
DECLARE

 
nr_titulo_w		bigint;
nr_seq_baixa_w		bigint;
nr_seq_ret_item_w	bigint;
dt_recebimento_w	timestamp;
vl_glosa_w		double precision;
nr_seq_conpaci_ret_hist_w	bigint;

c01 CURSOR FOR 
SELECT	a.nr_titulo, 
	a.nr_sequencia, 
	a.nr_seq_ret_item, 
	a.dt_recebimento, 
	a.vl_glosa 
from	titulo_receber_liq a 
where	a.vl_glosa > 0 
and	exists (SELECT	1 
		from	titulo_rec_liq_cc y 
		where	y.nr_titulo	= a.nr_titulo 
		and	y.nr_seq_baixa	= a.nr_sequencia) 
and (select	sum(x.vl_baixa) 
	from	titulo_rec_liq_cc x 
	where	x.nr_titulo	= a.nr_titulo 
	and	x.nr_seq_baixa	= a.nr_sequencia) <> a.vl_glosa 
and	(a.nr_seq_ret_item IS NOT NULL AND a.nr_seq_ret_item::text <> '') 
and	coalesce(a.nr_seq_conpaci_ret_hist::text, '') = '';

c02 CURSOR FOR 
SELECT	b.nr_sequencia 
from	hist_audit_conta_paciente d, 
	lote_audit_tit_rec c, 
	conta_paciente_ret_hist b, 
	convenio_retorno_glosa a 
where	a.nr_seq_ret_item		= nr_seq_ret_item_w 
and	a.nr_seq_conpaci_ret_hist 	= b.nr_sequencia 
and	b.nr_seq_lote_audit		= c.nr_sequencia 
and	b.nr_seq_hist_audit		= d.nr_sequencia 
and	d.ie_acao			= 3 
and	(c.dt_baixa IS NOT NULL AND c.dt_baixa::text <> '') 
and	coalesce(c.dt_baixa_cr,c.dt_baixa)	= dt_recebimento_w 
and	b.vl_historico			= vl_glosa_w 
and	not exists (SELECT	1 
			from	titulo_receber_liq x 
			where	x.nr_seq_conpaci_ret_hist	= b.nr_sequencia);


BEGIN 
 
open c01;
loop 
fetch c01 into 
	nr_titulo_w, 
	nr_seq_baixa_w, 
	nr_seq_ret_item_w, 
	dt_recebimento_w, 
	vl_glosa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	 
	open c02;
	loop 
	fetch c02 into 
		nr_seq_conpaci_ret_hist_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	 
		update	titulo_receber_liq 
		set	nr_seq_conpaci_ret_hist	= nr_seq_conpaci_ret_hist_w 
		where	nr_titulo	= nr_titulo_w 
		and	nr_sequencia	= nr_seq_baixa_w;
 
		CALL recalcular_titulo_rec_liq_cc(nr_titulo_w,nr_seq_baixa_w,nm_usuario_p);
 
		/*insert	into	logxxxx_tasy(cd_log, 
					nm_usuario, 
					dt_atualizacao, 
					ds_log) 
		values	(55804, 
			nm_usuario_p, 
			sysdate, 
			'Título: ' || nr_titulo_w || chr(13) || 
			'Baixa: ' || nr_seq_baixa_w || chr(13) || 
			'Historico: ' || nr_seq_conpaci_ret_hist_w); */
 
	end loop;
	close c02;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_classif_baixa_audit (nm_usuario_p text) FROM PUBLIC;

