-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_pck.carregar_grupo_itens ( nr_seq_grupo_itens_p pls_grupo_item_mens.nr_sequencia%type) AS $body$
DECLARE

C01 CURSOR FOR
	SELECT	ie_tipo_item,
		nr_seq_tipo_lanc
	from	pls_item_grupo_tipo_mens
	where	nr_seq_grupo_item = nr_seq_grupo_itens_p
	and	ie_situacao	= 'A';
BEGIN
current_setting('pls_mens_itens_pck.tb_ie_tipo_item_grupo_w')::pls_util_cta_pck.t_number_table.delete;
current_setting('pls_mens_itens_pck.tb_nr_seq_tipo_lanc_grupo_w')::pls_util_cta_pck.t_number_table.delete;
PERFORM set_config('pls_mens_itens_pck.nr_indice_grupo_itens_w', 0, false);
for c01_w in C01 loop
	begin
	current_setting('pls_mens_itens_pck.tb_ie_tipo_item_grupo_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_grupo_itens_w')::integer)	:= c01_w.ie_tipo_item;
	current_setting('pls_mens_itens_pck.tb_nr_seq_tipo_lanc_grupo_w')::pls_util_cta_pck.t_number_table(current_setting('pls_mens_itens_pck.nr_indice_grupo_itens_w')::integer)	:= c01_w.nr_seq_tipo_lanc;
	PERFORM set_config('pls_mens_itens_pck.nr_indice_grupo_itens_w', current_setting('pls_mens_itens_pck.nr_indice_grupo_itens_w')::integer + 1, false);
	end;
end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_pck.carregar_grupo_itens ( nr_seq_grupo_itens_p pls_grupo_item_mens.nr_sequencia%type) FROM PUBLIC;
