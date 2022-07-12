-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE audc_auditoria_concorrente_pck.audc_gerar_notificacao ( nr_seq_lote_atend_imp_p audc_lote_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE



nr_seq_audc_atend_w		audc_atendimento.nr_sequencia%type;
nr_seq_audc_atend_proc_w	audc_atend_proc.nr_sequencia%type;
ie_origem_auditoria_w		audc_atendimento.ie_origem_auditoria%type;
qt_material_w			bigint;

C01 CURSOR(  nr_seq_lote_atend_imp_pc	audc_lote_atendimento_imp.nr_sequencia%type ) FOR
	SELECT 	nr_sequencia
	from 	audc_atendimento a
	where	a.nr_seq_lote_atend_imp = nr_seq_lote_atend_imp_pc;

BEGIN

for c01_w in c01( nr_seq_lote_atend_imp_p ) loop

	/*Rotina utilizada para gerar notificacao para auditor e prestador, nao executa commit diretamente*/
			
	CALL pls_gerar_alerta_web_pck.pls_gerar_alerta_evento_audc(14, '1', c01_w.nr_sequencia,'N', nm_usuario_p);
	
end loop;	
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE audc_auditoria_concorrente_pck.audc_gerar_notificacao ( nr_seq_lote_atend_imp_p audc_lote_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
