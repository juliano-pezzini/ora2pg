-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.atualiza_guia_protocolo (protocolo_w INOUT protocolo) AS $body$
BEGIN

	update	imp_dem_retorno_guia
	set	dt_atualizacao = clock_timestamp(),
		nm_usuario     = current_setting('conciliar_integracao_ret_pck.nm_usuario_const_w')::convenio_retorno.nm_usuario%type,
		ie_status      = protocolo_w.ie_status
	where	nr_seq_dem_ret_prot = protocolo_w.nr_sequencia;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.atualiza_guia_protocolo (protocolo_w INOUT protocolo) FROM PUBLIC;