-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_monitor_tiss_proc_val_del ON pls_monitor_tiss_proc_val CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_monitor_tiss_proc_val_del() RETURNS trigger AS $BODY$
declare
vl_total_pago_w			pls_monitor_tiss_cta_val.vl_total_pago%type;
vl_total_apres_w		pls_monitor_tiss_cta_val.vl_cobranca_guia%type;
vl_total_item_w			pls_monitor_tiss_cta_val.vl_total_pago%type;
vl_total_tab_propria_w		pls_monitor_tiss_cta_val.vl_total_pago%type;
vl_total_glosa_w		pls_monitor_tiss_cta_val.vl_total_glosa%type;
vl_item_pago_w			pls_monitor_tiss_proc_val.vl_liberado%type;
vl_item_apres_w			pls_monitor_tiss_proc_val.vl_procedimento%type;
vl_item_glosa_w			pls_monitor_tiss_proc_val.vl_glosa%type;
ie_tipo_despesa_w		pls_conta_mat.ie_tipo_despesa%type;

BEGIN
vl_item_pago_w := coalesce(OLD.vl_liberado,0);
vl_item_apres_w := coalesce(OLD.vl_procedimento,0);
vl_item_glosa_w := coalesce(OLD.vl_glosa,0);

select	vl_cobranca_guia,
	vl_total_pago,
	vl_total_glosa
into STRICT	vl_total_apres_w,
	vl_total_pago_w,
	vl_total_glosa_w
from	pls_monitor_tiss_cta_val
where	nr_sequencia = OLD.nr_seq_cta_val;

select	ie_tipo_despesa
into STRICT	ie_tipo_despesa_w
from	pls_conta_proc
where	nr_sequencia = OLD.nr_seq_conta_proc;

if (OLD.cd_tabela_ref in ('00','98')) then
	select	vl_total_tabela_propria
	into STRICT	vl_total_tab_propria_w
	from	pls_monitor_tiss_cta_val
	where	nr_sequencia = OLD.nr_seq_cta_val;

	select	vl_total_procedimento
	into STRICT	vl_total_item_w
	from	pls_monitor_tiss_cta_val
	where	nr_sequencia = OLD.nr_seq_cta_val;

	update	pls_monitor_tiss_cta_val set
		vl_total_tabela_propria = vl_total_tab_propria_w - vl_item_pago_w,
		vl_total_procedimento	= vl_total_item_w - vl_item_pago_w,
		vl_cobranca_guia 	= vl_total_apres_w - vl_item_apres_w,
		vl_total_pago 		= vl_total_pago_w - vl_item_pago_w,
		vl_total_glosa 		= vl_total_glosa_w - vl_item_glosa_w
	where	nr_sequencia 		= OLD.nr_seq_cta_val;

elsif (OLD.cd_tabela_ref = '18') and (ie_tipo_despesa_w = '2') then
	select	vl_total_taxa
	into STRICT	vl_total_item_w
	from	pls_monitor_tiss_cta_val
	where	nr_sequencia = OLD.nr_seq_cta_val;

	update	pls_monitor_tiss_cta_val set
		vl_total_taxa		= vl_total_item_w - vl_item_pago_w,
		vl_cobranca_guia 	= vl_total_apres_w - vl_item_apres_w,
		vl_total_pago 		= vl_total_pago_w - vl_item_pago_w,
		vl_total_glosa 		= vl_total_glosa_w - vl_item_glosa_w
	where	nr_sequencia 		= OLD.nr_seq_cta_val;

elsif (OLD.cd_tabela_ref = '22') and (ie_tipo_despesa_w = '1') then
	select	vl_total_procedimento
	into STRICT	vl_total_item_w
	from	pls_monitor_tiss_cta_val
	where	nr_sequencia = OLD.nr_seq_cta_val;

	update	pls_monitor_tiss_cta_val set
		vl_total_procedimento	= vl_total_item_w - vl_item_pago_w,
		vl_cobranca_guia 	= vl_total_apres_w - vl_item_apres_w,
		vl_total_pago 		= vl_total_pago_w - vl_item_pago_w,
		vl_total_glosa 		= vl_total_glosa_w - vl_item_glosa_w
	where	nr_sequencia 		= OLD.nr_seq_cta_val;

elsif (OLD.cd_tabela_ref = '18') and (ie_tipo_despesa_w = '3') then
	select	vl_total_diaria
	into STRICT	vl_total_item_w
	from	pls_monitor_tiss_cta_val
	where	nr_sequencia = OLD.nr_seq_cta_val;

	update	pls_monitor_tiss_cta_val set
		vl_total_diaria		= vl_total_item_w - vl_item_pago_w,
		vl_cobranca_guia 	= vl_total_apres_w - vl_item_apres_w,
		vl_total_pago 		= vl_total_pago_w - vl_item_pago_w,
		vl_total_glosa 		= vl_total_glosa_w - vl_item_glosa_w
	where	nr_sequencia 		= OLD.nr_seq_cta_val;
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_monitor_tiss_proc_val_del() FROM PUBLIC;

CREATE TRIGGER pls_monitor_tiss_proc_val_del
	BEFORE DELETE ON pls_monitor_tiss_proc_val FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_monitor_tiss_proc_val_del();

