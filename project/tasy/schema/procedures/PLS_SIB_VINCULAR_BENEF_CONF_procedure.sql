-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_sib_vincular_benef_conf ( nr_seq_inclusao_benef_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	pls_sib_conferencia
set	nr_seq_segurado	= nr_seq_segurado_p
where	nr_sequencia	= nr_seq_inclusao_benef_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_vincular_benef_conf ( nr_seq_inclusao_benef_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text) FROM PUBLIC;

