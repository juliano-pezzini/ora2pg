-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE obter_saldo_disp_estoque_pck.set_cd_estabelecimento (cd_estabelecimento_p bigint) AS $body$
BEGIN
	if (coalesce(get_cd_estabelecimento::text, '') = '') or (cd_estabelecimento_p <> get_cd_estabelecimento) then
		begin
		PERFORM set_config('obter_saldo_disp_estoque_pck.cd_estabelecimento_w', cd_estabelecimento_p, false);

		select	coalesce(ie_disp_quimioterapia,'N'),
			coalesce(ie_disp_req_trans, 'N'),
			coalesce(ie_disp_prescr_eme, 'S'),
			coalesce(ie_disp_ag_cirur, 'N'),
			coalesce(ie_disp_comp_kit_estoque, 'N'),
			coalesce(ie_disp_reg_kit_estoque, 'N'),
			coalesce(ie_disp_emprestimo_lib, 'N'),
			coalesce(ie_disp_nf_emprestimo,'N'),
			coalesce(ie_disp_esp_cirurgia,'N'),
			coalesce(ie_disp_cirurgia,'S'),
			coalesce(ie_disp_req_trans_estab,'N'),
			coalesce(ie_disp_sep_gedipa,'N'),
			coalesce(ie_disp_ap_lote,'N')
		into STRICT	current_setting('obter_saldo_disp_estoque_pck.ie_disp_quimioterapia_w')::parametro_estoque.ie_disp_quimioterapia%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_req_trans_w')::parametro_estoque.ie_disp_req_trans%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_prescr_eme_w')::parametro_estoque.ie_disp_prescr_eme%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_ag_cirur_w')::parametro_estoque.ie_disp_ag_cirur%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_comp_kit_estoque_w')::parametro_estoque.ie_disp_comp_kit_estoque%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_reg_kit_estoque_w')::parametro_estoque.ie_disp_reg_kit_estoque%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_emprestimo_lib_w')::parametro_estoque.ie_disp_emprestimo_lib%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_nf_emprestimo_w')::parametro_estoque.ie_disp_nf_emprestimo%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_cirurgia_w')::parametro_estoque.ie_disp_cirurgia%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_req_trans_estab_w')::parametro_estoque.ie_disp_req_trans_estab%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_sep_gedipa_w')::parametro_estoque.ie_disp_sep_gedipa%type,
			current_setting('obter_saldo_disp_estoque_pck.ie_disp_ap_lote_w')::parametro_estoque.ie_disp_ap_lote%type
		from	parametro_estoque
		where	cd_estabelecimento = cd_estabelecimento_p  LIMIT 1;
		exception
		when others then
			begin
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_quimioterapia_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_req_trans_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_prescr_eme_w', 'S', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_ag_cirur_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_comp_kit_estoque_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_reg_kit_estoque_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_emprestimo_lib_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_nf_emprestimo_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_cirurgia_w', 'S', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_req_trans_estab_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_sep_gedipa_w', 'N', false);
			PERFORM set_config('obter_saldo_disp_estoque_pck.ie_disp_ap_lote_w', 'N', false);
			end;
		end;
	end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_saldo_disp_estoque_pck.set_cd_estabelecimento (cd_estabelecimento_p bigint) FROM PUBLIC;
