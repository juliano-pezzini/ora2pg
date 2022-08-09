-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_retirada_item (nm_usuario_p text, nr_seq_protocolo_p bigint, nr_seq_item_p bigint) AS $body$
BEGIN
update	protocolo_doc_item
set	dt_atualizacao          = clock_timestamp(),
	nm_usuario              = nm_usuario_p,
	nm_usuario_retirada     = '',
	dt_retirada              = NULL
where   nr_sequencia = nr_seq_protocolo_p
and     (dt_retirada IS NOT NULL AND dt_retirada::text <> '')
and     nr_seq_item = nr_seq_item_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_retirada_item (nm_usuario_p text, nr_seq_protocolo_p bigint, nr_seq_item_p bigint) FROM PUBLIC;
