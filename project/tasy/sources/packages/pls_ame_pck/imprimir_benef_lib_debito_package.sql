-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ame_pck.imprimir_benef_lib_debito () RETURNS SETOF REG_ITENS_BENEF_DEBITO_DATA AS $body$
DECLARE

t_reg_itens_benef_debito_aux_w	reg_itens_benef_debito;
BEGIN

for i in 1..reg_itens_benef_debito_w.count loop
	begin
	t_reg_itens_benef_debito_aux_w.nr_seq_segurado		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].nr_seq_segurado;
	t_reg_itens_benef_debito_aux_w.nr_seq_segurado_preco	:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].nr_seq_segurado_preco;
	t_reg_itens_benef_debito_aux_w.dt_rescisao		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].dt_rescisao;
	t_reg_itens_benef_debito_aux_w.ie_titular		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].ie_titular;
	t_reg_itens_benef_debito_aux_w.nr_seq_conta		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].nr_seq_conta;
	t_reg_itens_benef_debito_aux_w.nr_seq_conta_proc	:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].nr_seq_conta_proc;
	t_reg_itens_benef_debito_aux_w.nr_seq_conta_mat		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].nr_seq_conta_mat;
	t_reg_itens_benef_debito_aux_w.ie_tipo_item		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].ie_tipo_item;
	t_reg_itens_benef_debito_aux_w.vl_item			:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].vl_item;
	t_reg_itens_benef_debito_aux_w.nr_seq_prestador		:= current_setting('pls_ame_pck.reg_itens_benef_debito_w')::reg_itens_benef_debito_v[i].nr_seq_prestador;
	RETURN NEXT t_reg_itens_benef_debito_aux_w;
	end;
end loop;

return;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_ame_pck.imprimir_benef_lib_debito () FROM PUBLIC;