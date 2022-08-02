-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cat_carregar_empregador ( nr_seq_cat_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;


BEGIN

select	nr_seq_segurado
into STRICT	nr_seq_segurado_w
from	pls_cat
where	nr_sequencia	= nr_seq_cat_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cat_carregar_empregador ( nr_seq_cat_p bigint, nm_usuario_p text) FROM PUBLIC;

