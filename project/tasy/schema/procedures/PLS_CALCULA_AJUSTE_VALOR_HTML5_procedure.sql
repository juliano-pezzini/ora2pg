-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_calcula_ajuste_valor_html5 ( qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_p pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_p pls_conta_proc_v.vl_lib_taxa_servico%type, tx_intercambio_imp_p pls_conta_proc_v.tx_intercambio_imp%type, nr_seq_item_p pls_conta_proc_v.nr_sequencia%type, ie_tipo_item_p text, ie_opcao_p text, ie_intercambio_p text, nm_usuario_p usuario.nm_usuario%type, vl_unitario_out_p INOUT pls_conta_proc_v.vl_unitario%type, vl_liberado_out_p INOUT pls_conta_proc_v.vl_liberado%type, vl_liberado_co_out_p INOUT pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_out_p INOUT pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_out_p INOUT pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_out_p INOUT pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_out_p INOUT pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_out_p INOUT pls_conta_proc_v.vl_lib_taxa_servico%type) AS $body$
BEGIN

	SELECT * FROM pls_cta_alt_valor_pck.pls_calcula_ajuste_valor(qt_liberada_p, vl_unitario_p, vl_liberado_p, vl_liberado_co_p, vl_liberado_hi_p, vl_liberado_material_p, vl_lib_taxa_co_p, vl_lib_taxa_material_p, vl_lib_taxa_servico_p, tx_intercambio_imp_p, nr_seq_item_p, ie_tipo_item_p, ie_opcao_p, ie_intercambio_p, nm_usuario_p, vl_unitario_out_p, vl_liberado_out_p, vl_liberado_co_out_p, vl_liberado_hi_out_p, vl_liberado_material_out_p, vl_lib_taxa_co_out_p, vl_lib_taxa_material_out_p, vl_lib_taxa_servico_out_p) INTO STRICT vl_unitario_out_p, vl_liberado_out_p, vl_liberado_co_out_p, vl_liberado_hi_out_p, vl_liberado_material_out_p, vl_lib_taxa_co_out_p, vl_lib_taxa_material_out_p, vl_lib_taxa_servico_out_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_calcula_ajuste_valor_html5 ( qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_p pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_p pls_conta_proc_v.vl_lib_taxa_servico%type, tx_intercambio_imp_p pls_conta_proc_v.tx_intercambio_imp%type, nr_seq_item_p pls_conta_proc_v.nr_sequencia%type, ie_tipo_item_p text, ie_opcao_p text, ie_intercambio_p text, nm_usuario_p usuario.nm_usuario%type, vl_unitario_out_p INOUT pls_conta_proc_v.vl_unitario%type, vl_liberado_out_p INOUT pls_conta_proc_v.vl_liberado%type, vl_liberado_co_out_p INOUT pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_out_p INOUT pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_out_p INOUT pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_out_p INOUT pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_out_p INOUT pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_out_p INOUT pls_conta_proc_v.vl_lib_taxa_servico%type) FROM PUBLIC;

