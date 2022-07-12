-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_rec_glosa_cta_tiss_update ON pls_rec_glosa_conta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_rec_glosa_cta_tiss_update() RETURNS trigger AS $BODY$
declare

qt_rec_glosa_tiss_w	bigint;

C01 CURSOR(nr_seq_conta_rec_pc	pls_rec_glosa_conta.nr_sequencia%type) FOR
	SELECT	a.nr_seq_conta_proc,
		null nr_seq_conta_mat,
		a.vl_acatado,
		a.nr_sequencia nr_seq_proc_rec,
		null nr_seq_mat_rec
	from	pls_rec_glosa_proc	a
	where	a.nr_seq_conta_rec	= nr_seq_conta_rec_pc
	
union all

	SELECT	null nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.vl_acatado,
		null nr_seq_proc_rec,
		a.nr_sequencia nr_seq_mat_rec
	from	pls_rec_glosa_mat	a
	where	a.nr_seq_conta_rec	= nr_seq_conta_rec_pc;

BEGIN
-- Gravar log TISS para quando ocorrer quando fecha o recurso de glosa
select	count(1)
into STRICT	qt_rec_glosa_tiss_w
from	pls_monitor_tiss_alt
where	nr_seq_conta 	= NEW.nr_seq_conta
and	ie_tipo_evento 	= 'FR';

if (NEW.ie_status = '2') and (coalesce(qt_rec_glosa_tiss_w,0) = 0) then
	for	r_c01_w in c01(NEW.nr_sequencia) loop
		CALL pls_tiss_gravar_log_monitor(	'FR', NEW.nr_seq_conta, r_c01_w.nr_seq_conta_proc,
						r_c01_w.nr_seq_conta_mat, NEW.nr_sequencia, r_c01_w.nr_seq_proc_rec,
						r_c01_w.nr_seq_mat_rec, null, null,
						null, r_c01_w.vl_acatado, wheb_usuario_pck.get_nm_usuario,LOCALTIMESTAMP);
	end loop;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_rec_glosa_cta_tiss_update() FROM PUBLIC;

CREATE TRIGGER pls_rec_glosa_cta_tiss_update
	AFTER UPDATE ON pls_rec_glosa_conta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_rec_glosa_cta_tiss_update();

