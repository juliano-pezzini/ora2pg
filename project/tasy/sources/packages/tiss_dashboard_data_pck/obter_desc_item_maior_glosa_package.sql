-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dashboard_data_pck.obter_desc_item_maior_glosa (cd_convenio_p convenio.cd_convenio%type, dt_ref_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_item_w	varchar(2000);

cd_proc_w	procedimento_paciente.cd_procedimento%type;
ie_proc_w	procedimento_paciente.ie_origem_proced%type;


BEGIN

	if tiss_dashboard_data_pck.obter_maior_glosa_mat_proc(cd_convenio_p, dt_ref_p) = 'P' then
		select	cd, ie
		into STRICT	cd_proc_w,
			ie_proc_w
		from (
			SELECT	a.cd_procedimento cd,
				a.ie_origem_proced ie		
			from    conciliacao_item_ret_rec a,
				conciliacao_conta_pac_guia b,
				conciliacao_conta_paciente c,
				protocolo_faturado d
			where   a.nr_seq_conc_guia          	= b.nr_sequencia
			and     b.nr_seq_conta_pac_conc     	= c.nr_sequencia
			and     c.nr_seq_protoc_faturado    	= d.nr_sequencia
			and	(a.cd_procedimento IS NOT NULL AND a.cd_procedimento::text <> '')
			and	(a.ie_origem_proced IS NOT NULL AND a.ie_origem_proced::text <> '')
			and	coalesce(a.cd_material::text, '') = ''
			and	d.cd_convenio 			= cd_convenio_p
			and (coalesce(dt_ref_p::text, '') = '' or trunc(d.dt_referencia, 'mm') = trunc(dt_ref_p, 'mm'))

			group	by				a.cd_procedimento,
								a.ie_origem_proced
			order	by				sum(a.vl_glosa_aceita) 	desc,
								sum(a.qt_glosada) 	desc
		) alias10 LIMIT 1;

		select	obter_desc_procedimento(cd_proc_w, ie_proc_w)
		into STRICT	ds_item_w
		;
	else
		select 	obter_desc_material(tiss_dashboard_data_pck.obter_maior_item_glosa(cd_convenio_p, dt_ref_p))
		into STRICT	ds_item_w
		;
	end if;

	return ds_item_w;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_dashboard_data_pck.obter_desc_item_maior_glosa (cd_convenio_p convenio.cd_convenio%type, dt_ref_p timestamp) FROM PUBLIC;