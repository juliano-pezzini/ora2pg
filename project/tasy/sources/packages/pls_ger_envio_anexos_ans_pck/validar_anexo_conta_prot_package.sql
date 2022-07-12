-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ger_envio_anexos_ans_pck.validar_anexo_conta_prot ( nr_protocolo_prestador_p pls_anexo_imp.nr_protocolo_prestador%type, nr_seq_prestador_p pls_anexo_imp.nr_seq_prestador%type, nr_seq_protocolo_p INOUT pls_protocolo_conta.nr_sequencia%type, cd_motivo_glosa_p INOUT pls_anexo_imp.cd_motivo_glosa%type, ds_motivo_glosa_p INOUT pls_anexo_imp.ds_motivo_glosa%type, ie_status_p INOUT pls_anexo_imp.ie_status%type) AS $body$
BEGIN

	select  max(a.nr_sequencia)
	into STRICT  	current_setting('pls_ger_envio_anexos_ans_pck.nr_seq_protocolo_temp_w')::pls_protocolo_conta.nr_sequencia%type
	from 	pls_protocolo_conta a
	where   nr_sequencia = nr_protocolo_prestador_p
	and   	nr_seq_prestador = nr_seq_prestador_p;

	if ( current_setting('pls_ger_envio_anexos_ans_pck.nr_seq_protocolo_temp_w')::pls_protocolo_conta.nr_sequencia%coalesce(type::text, '') = '') then
		-- se nao encontrou protocolo para a combinacao protocolo e prestador informado, entao emite glosa de codigo de protocolo nao encontrado
		cd_motivo_glosa_p := '3162';
		ds_motivo_glosa_p := obter_texto_dic_objeto(1211643, wheb_usuario_pck.get_nr_seq_idioma, null);
		ie_status_p := 'G';
	else
		nr_seq_protocolo_p := current_setting('pls_ger_envio_anexos_ans_pck.nr_seq_protocolo_temp_w')::pls_protocolo_conta.nr_sequencia%type;
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ger_envio_anexos_ans_pck.validar_anexo_conta_prot ( nr_protocolo_prestador_p pls_anexo_imp.nr_protocolo_prestador%type, nr_seq_prestador_p pls_anexo_imp.nr_seq_prestador%type, nr_seq_protocolo_p INOUT pls_protocolo_conta.nr_sequencia%type, cd_motivo_glosa_p INOUT pls_anexo_imp.cd_motivo_glosa%type, ds_motivo_glosa_p INOUT pls_anexo_imp.ds_motivo_glosa%type, ie_status_p INOUT pls_anexo_imp.ie_status%type) FROM PUBLIC;