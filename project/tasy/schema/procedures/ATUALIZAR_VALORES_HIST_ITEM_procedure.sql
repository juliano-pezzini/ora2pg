-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_valores_hist_item (nm_usuario_p text, nr_seq_hist_item_p bigint) AS $body$
DECLARE


vl_amenor_w		double precision;
vl_glosa_w		double precision;
vl_pago_w		double precision;
vl_adicional_w		double precision;


BEGIN

select	coalesce(sum(vl_amenor),0),
	coalesce(sum(vl_glosa),0),
	coalesce(sum(vl_pago),0),
	coalesce(sum(vl_adicional),0)
into STRICT	vl_amenor_w,
	vl_glosa_w,
	vl_pago_w,
	vl_adicional_w
from	grg_proc_partic
where	nr_seq_hist_item	= nr_seq_hist_item_p;

update	lote_audit_hist_item
set	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	vl_amenor		= vl_amenor_w,
	vl_glosa		= vl_glosa_w,
	vl_pago			= vl_pago_w,
	vl_adicional		= vl_adicional_w
where	nr_sequencia		= nr_seq_hist_item_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_valores_hist_item (nm_usuario_p text, nr_seq_hist_item_p bigint) FROM PUBLIC;
