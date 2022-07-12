-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dashboard_data_pck.obter_maior_glosa_mat_proc (cd_convenio_p convenio.cd_convenio%type, dt_ref_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_ret_w varchar(1);

vl_proc_w double precision;
vl_mat_w double precision;


BEGIN
	begin
		select	sum(coalesce(a.vl_glosa_aceita,0))
		into STRICT	vl_mat_w
		from    conciliacao_item_ret_rec a,
			conciliacao_conta_pac_guia b,
			conciliacao_conta_paciente c,
			protocolo_faturado d
		where   a.nr_seq_conc_guia          	= b.nr_sequencia
		and     b.nr_seq_conta_pac_conc     	= c.nr_sequencia
		and     c.nr_seq_protoc_faturado    	= d.nr_sequencia
		and (coalesce(dt_ref_p::text, '') = '' or trunc(d.dt_referencia, 'mm') 	= trunc(dt_ref_p, 'mm'))
		and	coalesce(a.cd_procedimento::text, '') = ''
		and	coalesce(a.ie_origem_proced::text, '') = ''
		and	(a.cd_material IS NOT NULL AND a.cd_material::text <> '')
		and	d.cd_convenio = cd_convenio_p;
	exception
	when others then
		vl_mat_w := 0;
	end;
	
	begin
		select	sum(coalesce(a.vl_glosa_aceita,0))
		into STRICT	vl_proc_w
		from    conciliacao_item_ret_rec a,
			conciliacao_conta_pac_guia b,
			conciliacao_conta_paciente c,
			protocolo_faturado d
		where   a.nr_seq_conc_guia          	= b.nr_sequencia
		and     b.nr_seq_conta_pac_conc     	= c.nr_sequencia
		and     c.nr_seq_protoc_faturado    	= d.nr_sequencia
		and (coalesce(dt_ref_p::text, '') = '' or trunc(d.dt_referencia, 'mm') 	= trunc(dt_ref_p, 'mm'))
		and	(a.cd_procedimento IS NOT NULL AND a.cd_procedimento::text <> '')
		and	(a.ie_origem_proced IS NOT NULL AND a.ie_origem_proced::text <> '')
		and	coalesce(a.cd_material::text, '') = ''
		and	d.cd_convenio 		    	= cd_convenio_p;
	exception
	when others then
		vl_proc_w := 0;
	end;
	
	if coalesce(vl_proc_w,0) > coalesce(vl_mat_w,0) then
		ie_ret_w := 'P';
	else
		ie_ret_w := 'M';
	end if;

	return ie_ret_w;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_dashboard_data_pck.obter_maior_glosa_mat_proc (cd_convenio_p convenio.cd_convenio%type, dt_ref_p timestamp) FROM PUBLIC;
