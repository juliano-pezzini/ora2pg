-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qtde_req_validas ( nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_segurado_p pls_requisicao.nr_seq_segurado%type) RETURNS bigint AS $body$
DECLARE


qt_registros_w	integer := 0;


BEGIN

select	count(1) qt_registros
into STRICT	qt_registros_w
from	pls_requisicao
where	nr_sequencia 	= nr_seq_requisicao_p
and	nr_seq_segurado = nr_seq_segurado_p;

return	qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qtde_req_validas ( nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_segurado_p pls_requisicao.nr_seq_segurado%type) FROM PUBLIC;

