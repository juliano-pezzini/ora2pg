-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.exibir_dados_item (item_w item) AS $body$
BEGIN
	CALL CALL CALL conciliar_integracao_ret_pck.print('item (sequencia tabela) = ' || item_w.nr_sequencia);
	CALL CALL CALL conciliar_integracao_ret_pck.print('cd_procedimento = ' || item_w.cd_procedimento);
	CALL CALL CALL conciliar_integracao_ret_pck.print('ie_tipo_guia = ' || item_w.ie_tipo_guia);
	CALL CALL CALL conciliar_integracao_ret_pck.print('dt_realizacao = ' || item_w.dt_realizacao);
	CALL CALL CALL conciliar_integracao_ret_pck.print('ie_tipo_pagamento = ' || item_w.ie_tipo_pagamento);
	CALL CALL CALL conciliar_integracao_ret_pck.print('cd_setor_exec = ' || item_w.cd_setor_exec);
	CALL CALL CALL conciliar_integracao_ret_pck.print('cd_funcao = ' || item_w.cd_funcao);
	CALL CALL CALL conciliar_integracao_ret_pck.print('vl_informado = ' || item_w.vl_informado);
	CALL CALL CALL conciliar_integracao_ret_pck.print('qt_executada = ' || item_w.qt_executada);
	CALL CALL CALL conciliar_integracao_ret_pck.print('vl_liberado = ' || item_w.vl_liberado);
	CALL CALL CALL conciliar_integracao_ret_pck.print('cd_glosa = ' || item_w.cd_glosa);
	CALL CALL CALL conciliar_integracao_ret_pck.print('cd_motivo_interno = ' || item_w.cd_motivo_interno);
	CALL CALL CALL conciliar_integracao_ret_pck.print('vl_glosado = ' || item_w.vl_glosado);
	CALL CALL CALL conciliar_integracao_ret_pck.print('ie_status = ' || item_w.ie_status);
	CALL CALL CALL conciliar_integracao_ret_pck.print('ie_conciliado = ' || item_w.ie_conciliado);
	CALL CALL CALL conciliar_integracao_ret_pck.print('nr_seq_ret_item = ' || item_w.nr_seq_ret_item);
	CALL CALL CALL conciliar_integracao_ret_pck.print('nr_seq_dem_ret_guia = ' || item_w.nr_seq_dem_ret_guia);
	CALL CALL CALL conciliar_integracao_ret_pck.print('nr_seq_propaci = ' || item_w.nr_seq_propaci);
	CALL CALL CALL conciliar_integracao_ret_pck.print('nr_seq_matpaci = ' || item_w.nr_seq_matpaci);	
	CALL CALL CALL conciliar_integracao_ret_pck.print('-----------------------------------------');
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.exibir_dados_item (item_w item) FROM PUBLIC;
