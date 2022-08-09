-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE marcar_diferenca_ortografica ( nr_seq_analise_p bigint, ie_diferenca_p text, nm_usuario_p text) AS $body$
BEGIN

update	analise_ortografica
set	ie_diferenca	= coalesce(ie_diferenca_p,ie_diferenca)
where	nr_sequencia	= nr_seq_analise_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE marcar_diferenca_ortografica ( nr_seq_analise_p bigint, ie_diferenca_p text, nm_usuario_p text) FROM PUBLIC;
