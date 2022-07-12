-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.atualiza_item (item_w INOUT item) AS $body$
BEGIN

	update	imp_dem_ret_item
	set	dt_atualizacao 	= clock_timestamp(),
		nm_usuario     	= current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type,
		ie_status 	= item_w.ie_status,
		ds_erro		= item_w.ds_erro
	where	nr_sequencia 	= item_w.nr_sequencia;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.atualiza_item (item_w INOUT item) FROM PUBLIC;
