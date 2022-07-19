-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_limpar_campo_armazenamento ( nr_seq_documento_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	qua_documento
set	ie_forma_armazenamento 			 = NULL,
	ds_forma_recuperacao 			 = NULL,
	ds_forma_protecao 				 = NULL,
	ie_forma_descarte 				 = NULL,
	qt_tempo_retencao 				 = NULL,
	ie_tempo_retencao 				 = NULL,
	ie_permanente 				= 'N',
	ie_armazena_arq_morto 			= 'N',
	ie_forma_descarte_arq_morto 			 = NULL,
	qt_tempo_retencao_arq_morto 		 = NULL,
	ie_tempo_retencao_arq_morto 		 = NULL,
	nm_usuario 				= nm_usuario_p,
	dt_atualizacao				= clock_timestamp()
where	nr_sequencia				= nr_seq_documento_p;

delete	FROM qua_doc_local
where	nr_seq_doc	= nr_seq_documento_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_limpar_campo_armazenamento ( nr_seq_documento_p bigint, nm_usuario_p text) FROM PUBLIC;

