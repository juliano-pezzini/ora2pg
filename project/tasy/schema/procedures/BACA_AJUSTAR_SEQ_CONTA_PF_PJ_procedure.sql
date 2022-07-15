-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_seq_conta_pf_pj () AS $body$
BEGIN

update	pessoa_fisica_conta
set	nr_sequencia	= nextval('pessoa_fisica_conta_seq')
where	coalesce(nr_sequencia::text, '') = '';

update	pessoa_juridica_conta
set	nr_sequencia	= nextval('pessoa_juridica_conta_seq')
where	coalesce(nr_sequencia::text, '') = '';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_seq_conta_pf_pj () FROM PUBLIC;

