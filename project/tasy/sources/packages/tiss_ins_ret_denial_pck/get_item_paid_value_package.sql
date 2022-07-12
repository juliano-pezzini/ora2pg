-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_ins_ret_denial_pck.get_item_paid_value ( nr_seq_tiss_conta_proc_p bigint, nr_seq_tiss_conta_desp_p bigint ) RETURNS bigint AS $body$
DECLARE


result_w	double precision;
		

BEGIN
	
	result_w := 0;
	
	if (nr_seq_tiss_conta_proc_p IS NOT NULL AND nr_seq_tiss_conta_proc_p::text <> '') then
	
		/* Paid value from Insurance Return. */

		select 	result_w + coalesce(sum(coalesce(x.vl_pago_digitado, 0)), 0)
		into STRICT	result_w
		from	convenio_retorno_glosa x,
			convenio_retorno_item y,
			convenio_retorno z
		where	x.nr_seq_tiss_conta_proc = nr_seq_tiss_conta_proc_p
		and	x.nr_seq_ret_item = y.nr_sequencia
		and	y.nr_seq_retorno = z.nr_sequencia;
		--and	z.ie_status_retorno = 'F';
		
		/* Denial value that has been accepted from Insurance Return. */

		select 	result_w + coalesce(sum(coalesce(x.vl_glosa, 0)), 0)
		into STRICT	result_w
		from	convenio_retorno_glosa x,
			convenio_retorno_item y,
			convenio_retorno z
		where	x.nr_seq_tiss_conta_proc = nr_seq_tiss_conta_proc_p
		and	x.nr_seq_ret_item = y.nr_sequencia
		and	y.nr_seq_retorno = z.nr_sequencia
		--and	z.ie_status_retorno = 'F'
		and	x.ie_acao_glosa in ('A', 'P');
		
		/* Paid value from Denial Appeal Management. */

		select	result_w + coalesce(sum(coalesce(x.vl_pago, 0)),0)
		into STRICT	result_w
		from	lote_audit_hist_item x,
			lote_audit_hist_guia y,
			lote_audit_hist z
		where	x.nr_seq_tiss_conta_proc = nr_seq_tiss_conta_proc_p
		and	x.nr_seq_guia = y.nr_sequencia
		and	y.nr_seq_lote_hist = z.nr_sequencia;
		--and	z.dt_fechamento is not null;
		
		/* Denial value that has been accepted from Denial Appeal Management. */

		select	result_w + coalesce(sum(coalesce(x.vl_glosa, 0)),0)
		into STRICT	result_w
		from	lote_audit_hist_item x,
			lote_audit_hist_guia y,
			lote_audit_hist z
		where	x.nr_seq_tiss_conta_proc = nr_seq_tiss_conta_proc_p
		and	x.nr_seq_guia = y.nr_sequencia
		and	y.nr_seq_lote_hist = z.nr_sequencia
		-- and	z.dt_fechamento is not null
		and	x.ie_acao_glosa in ('A', 'P');
	
	
	elsif (nr_seq_tiss_conta_desp_p IS NOT NULL AND nr_seq_tiss_conta_desp_p::text <> '') then
		
		/* Paid value from Insurance Return. */

		select 	result_w + coalesce(sum(coalesce(x.vl_pago_digitado, 0)), 0)
		into STRICT	result_w
		from	convenio_retorno_glosa x,
			convenio_retorno_item y,
			convenio_retorno z
		where	x.nr_seq_tiss_conta_desp = nr_seq_tiss_conta_desp_p
		and	x.nr_seq_ret_item = y.nr_sequencia
		and	y.nr_seq_retorno = z.nr_sequencia;
		-- and	z.ie_status_retorno = 'F';
		
		/* Denial value that has been accepted from Insurance Return. */

		select 	result_w + coalesce(sum(coalesce(x.vl_glosa, 0)), 0)
		into STRICT	result_w
		from	convenio_retorno_glosa x,
			convenio_retorno_item y,
			convenio_retorno z
		where	x.nr_seq_tiss_conta_desp = nr_seq_tiss_conta_desp_p
		and	x.nr_seq_ret_item = y.nr_sequencia
		and	y.nr_seq_retorno = z.nr_sequencia
		-- and	z.ie_status_retorno = 'F'
		and	x.ie_acao_glosa in ('A', 'P');
		
		/* Paid value from Denial Appeal Management. */

		select	result_w + coalesce(sum(coalesce(x.vl_pago, 0)),0)
		into STRICT	result_w
		from	lote_audit_hist_item x,
			lote_audit_hist_guia y,
			lote_audit_hist z
		where	x.nr_seq_tiss_conta_desp = nr_seq_tiss_conta_desp_p
		and	x.nr_seq_guia = y.nr_sequencia
		and	y.nr_seq_lote_hist = z.nr_sequencia;
		-- and	z.dt_fechamento is not null;
		
		/* Denial value that has been accepted from Denial Appeal Management. */

		select	result_w + coalesce(sum(coalesce(x.vl_glosa, 0)),0)
		into STRICT	result_w
		from	lote_audit_hist_item x,
			lote_audit_hist_guia y,
			lote_audit_hist z
		where	x.nr_seq_tiss_conta_desp = nr_seq_tiss_conta_desp_p
		and	x.nr_seq_guia = y.nr_sequencia
		and	y.nr_seq_lote_hist = z.nr_sequencia
		-- and	z.dt_fechamento is not null
		and	x.ie_acao_glosa in ('A', 'P');
		
	end if;


	return result_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tiss_ins_ret_denial_pck.get_item_paid_value ( nr_seq_tiss_conta_proc_p bigint, nr_seq_tiss_conta_desp_p bigint ) FROM PUBLIC;
