-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_envio_nfse ( nr_seq_nota_p bigint, ie_status_envio_p text, nm_usuario_p text) AS $body$
BEGIN

update 	nota_fiscal
set	ie_status_envio = ie_status_envio_p
where	nr_sequencia = nr_seq_nota_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_envio_nfse ( nr_seq_nota_p bigint, ie_status_envio_p text, nm_usuario_p text) FROM PUBLIC;
