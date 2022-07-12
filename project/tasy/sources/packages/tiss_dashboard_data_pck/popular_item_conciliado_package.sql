-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE rec AS (
	procedimento		conciliacao_item_ret_rec.cd_procedimento%type,
	origem			conciliacao_item_ret_rec.ie_origem_proced%type,
	material		conciliacao_item_ret_rec.cd_material%type,
	qt			conciliacao_item_ret_rec.qt_glosada%type,
	vl			conciliacao_item_ret_rec.vl_glosa_aceita%type
);


CREATE OR REPLACE PROCEDURE tiss_dashboard_data_pck.popular_item_conciliado (nr_seq_conc_guia_p conciliacao_conta_pac_guia.nr_sequencia%type, nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_autorizacao_p conta_paciente_guia.cd_autorizacao%type) AS $body$
DECLARE


itens CURSOR FOR
SELECT (select x.cd_material
	from 	material_atend_paciente x
	where 	x.nr_sequencia = a.nr_seq_matpaci) 	cd_material,
	(select x.cd_procedimento 
	from 	procedimento_paciente x
	where 	x.nr_sequencia = a.nr_seq_propaci) 	cd_procedimento,
	(select x.ie_origem_proced 
	from 	procedimento_paciente x
	where 	x.nr_sequencia = a.nr_seq_propaci) 	ie_origem_proced,
	a.qt_item					qt_item,
	a.vl_glosa					vl_glosa
from	lote_audit_hist_item a,
	lote_audit_hist_guia b
where	a.nr_seq_guia 		= b.nr_sequencia
and	(a.ie_acao_glosa IS NOT NULL AND a.ie_acao_glosa::text <> '')
and	a.ie_acao_glosa		in ('A', 'P')
and	b.nr_interno_conta 	= nr_interno_conta_p
and	b.cd_autorizacao 	= cd_autorizacao_p;

type	rec_tbl is table of rec index by integer;

rec_v 	rec_tbl;

i_exist integer;

nr_seq_conc_ret_w	conciliacao_item_ret_rec.nr_sequencia%type;
BEGIN
	rec_v.delete;	
	for item in itens loop
		if rec_v.count > 0 then
			i_exist := -1;
			for i in rec_v.first .. rec_v.last loop
				if (item.cd_procedimento = rec_v[i].procedimento and item.ie_origem_proced = rec_v[i].origem)
					or (item.cd_material = rec_v[i].material) then
					i_exist := i;
					exit;
				end if;
			end loop;
			if i_exist <> -1 then				
				rec_v[i_exist].qt := rec_v[i_exist].qt + item.qt_item;
				rec_v[i_exist].vl := rec_v[i_exist].vl + item.vl_glosa;
			else
				i_exist := rec_v.last+1;
				rec_v[i_exist].procedimento 	:= item.cd_procedimento;
				rec_v[i_exist].origem 		:= item.ie_origem_proced;
				rec_v[i_exist].material 	:= item.cd_material;
				rec_v[i_exist].qt 		:= item.qt_item;
				rec_v[i_exist].vl 		:= item.vl_glosa;
			end if;
		else
			i_exist := coalesce(rec_v.first, 0);
			rec_v[i_exist].procedimento 		:= item.cd_procedimento;
			rec_v[i_exist].origem 			:= item.ie_origem_proced;
			rec_v[i_exist].material 		:= item.cd_material;
			rec_v[i_exist].qt 			:= item.qt_item;
			rec_v[i_exist].vl 			:= item.vl_glosa;
		end if;
	end loop;
	
	if rec_v.count > 0 then
		for i in rec_v.first .. rec_v.last loop

			select	nextval('conciliacao_item_ret_rec_seq')
			into STRICT	nr_seq_conc_ret_w
			;
			CALL CALL tiss_dashboard_data_pck.printlog('#@ INICIO LOG TBL ITEM #@');
			CALL CALL tiss_dashboard_data_pck.printlog('i = ' || i);
			CALL CALL tiss_dashboard_data_pck.printlog('material = ' || rec_v[i].material);
			CALL CALL tiss_dashboard_data_pck.printlog('procedimento = ' || rec_v[i].procedimento);
			CALL CALL tiss_dashboard_data_pck.printlog('origem = ' || rec_v[i].origem);
			CALL CALL tiss_dashboard_data_pck.printlog('qt = ' || rec_v[i].qt);
			CALL CALL tiss_dashboard_data_pck.printlog('vl = ' || rec_v[i].vl);
			CALL CALL tiss_dashboard_data_pck.printlog('#@ FIM LOG TBL ITEM #@');
			insert into conciliacao_item_ret_rec(
				cd_material,
				cd_procedimento,
				ie_origem_proced,
				qt_glosada,
				vl_glosa_aceita,
				nr_sequencia,
				nr_seq_conc_guia,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec
			)
			values (
				rec_v[i].material,
				rec_v[i].procedimento,
				rec_v[i].origem,
				rec_v[i].qt,
				rec_v[i].vl,
				nr_seq_conc_ret_w,
				nr_seq_conc_guia_p,
				clock_timestamp(),
				clock_timestamp(),
				current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type,
				current_setting('tiss_dashboard_data_pck.nm_usuario_job_w')::usuario.nm_usuario%type
			);
		end loop;
	end if;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_dashboard_data_pck.popular_item_conciliado (nr_seq_conc_guia_p conciliacao_conta_pac_guia.nr_sequencia%type, nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_autorizacao_p conta_paciente_guia.cd_autorizacao%type) FROM PUBLIC;