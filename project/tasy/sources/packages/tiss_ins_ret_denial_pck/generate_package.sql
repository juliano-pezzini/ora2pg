-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_ins_ret_denial_pck.generate ( nr_seq_item_fatur_p bigint, ie_proc_desp_p text, cd_item_p text, dt_item_p timestamp, vl_item_p bigint, qt_item_p bigint, qt_item_orig_p bigint, cd_setor_p setor_atendimento.cd_setor_atendimento%type, vl_payment_p bigint, ie_funcao_medico_p text ) AS $body$
DECLARE


proc_ins_w		procedimento;
mat_ins_w		material;
		
BEGIN
	/* Try to conciliate/backtrace the item with a medical procedure. */

	if current_setting('tiss_ins_ret_denial_pck.proc_w')::proc_v.count > 0 then
		for i in current_setting('tiss_ins_ret_denial_pck.proc_w')::proc_v.first .. current_setting('tiss_ins_ret_denial_pck.proc_w')::proc_v.last loop
			if tiss_ins_ret_denial_pck.check_if_procedure_conciliate(current_setting('tiss_ins_ret_denial_pck.proc_w')::proc_v(i), cd_item_p, dt_item_p,
				vl_item_p, cd_setor_p, ie_funcao_medico_p) = 'S' then

				proc_ins_w := current_setting('tiss_ins_ret_denial_pck.proc_w')::proc_v(i);
				current_setting('tiss_ins_ret_denial_pck.proc_w')::proc_v[i].ie_status 	:= 'S';
				exit;

			end if;
		end loop;
	end if;
	
	/* Try to conciliate/backtrace the item with a medical material/medicine. */

	if coalesce(proc_ins_w.nr_sequencia::text, '') = '' and current_setting('tiss_ins_ret_denial_pck.mat_w')::mat_v.count > 0 then
		for i in current_setting('tiss_ins_ret_denial_pck.mat_w')::mat_v.first .. current_setting('tiss_ins_ret_denial_pck.mat_w')::mat_v.last loop
			if tiss_ins_ret_denial_pck.check_if_med_mat_conciliate(current_setting('tiss_ins_ret_denial_pck.mat_w')::mat_v(i), cd_item_p, dt_item_p,
					vl_item_p, qt_item_p,  qt_item_orig_p, 
					cd_setor_p) = 'S' then

				mat_ins_w := current_setting('tiss_ins_ret_denial_pck.mat_w')::mat_v(i);
				current_setting('tiss_ins_ret_denial_pck.mat_w')::mat_v[i].ie_status	:= 'S';
				exit;

			end if;
		end loop;
	end if;
	
	/* If a item was found, create it. */

	if (proc_ins_w.nr_sequencia IS NOT NULL AND proc_ins_w.nr_sequencia::text <> '') or (mat_ins_w.nr_sequencia IS NOT NULL AND mat_ins_w.nr_sequencia::text <> '') then
		CALL tiss_ins_ret_denial_pck.create_denied_item(nr_seq_item_fatur_p, proc_ins_w, mat_ins_w,
			cd_item_p, vl_item_p, qt_item_p, 
			cd_setor_p, vl_payment_p, ie_funcao_medico_p, 
			ie_proc_desp_p);
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_ins_ret_denial_pck.generate ( nr_seq_item_fatur_p bigint, ie_proc_desp_p text, cd_item_p text, dt_item_p timestamp, vl_item_p bigint, qt_item_p bigint, qt_item_orig_p bigint, cd_setor_p setor_atendimento.cd_setor_atendimento%type, vl_payment_p bigint, ie_funcao_medico_p text ) FROM PUBLIC;