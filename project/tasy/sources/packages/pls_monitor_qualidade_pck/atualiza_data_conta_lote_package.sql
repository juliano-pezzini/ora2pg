-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_monitor_qualidade_pck.atualiza_data_conta_lote ( dados_conta_qualidade_p pls_monitor_qualidade_pck.dados_conta_qualidade) AS $body$
BEGIN
 
update	pls_cta_qualid_monit_ans 
set	dt_processamento = dados_conta_qualidade_p.dt_processamento 
where	nr_sequencia = dados_conta_qualidade_p.nr_sequencia;
 
commit;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_monitor_qualidade_pck.atualiza_data_conta_lote ( dados_conta_qualidade_p pls_monitor_qualidade_pck.dados_conta_qualidade) FROM PUBLIC;