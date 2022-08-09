-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gerar_log_integracao ( nr_documento_p bigint, nr_docto_externo_p text, ie_acao_p text, ie_status_p text, dt_documento_p timestamp, dt_processo_p timestamp, ds_consistencia_p text, ie_evento_p text, nm_usuario_p text, ie_tipo_p text, ie_tipo_doc_p text) AS $body$
BEGIN

insert into sup_log_integracao(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_documento,
	nr_docto_externo,
	ie_acao,
	ie_status,
	dt_documento,
	dt_processo,
	dt_envio_email,
	ds_consistencia,
	ie_evento,
	ie_tipo,
	ie_tipo_doc)
values (	nextval('sup_log_integracao_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_documento_p,
	nr_docto_externo_p,
	ie_acao_p,
	ie_status_p,
	dt_documento_p,
	dt_processo_p,
	null,
	ds_consistencia_p,
	ie_evento_p,
	ie_tipo_p,
	ie_tipo_doc_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gerar_log_integracao ( nr_documento_p bigint, nr_docto_externo_p text, ie_acao_p text, ie_status_p text, dt_documento_p timestamp, dt_processo_p timestamp, ds_consistencia_p text, ie_evento_p text, nm_usuario_p text, ie_tipo_p text, ie_tipo_doc_p text) FROM PUBLIC;
