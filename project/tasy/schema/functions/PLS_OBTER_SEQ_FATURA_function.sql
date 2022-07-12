-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_fatura (nm_usuario_p usuario.nm_usuario%type) RETURNS bigint AS $body$
DECLARE


nr_seq_fatura_w		ptu_fatura.nr_sequencia%type;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_fatura_w
from	ptu_fatura
where	nm_usuario_nrec		= nm_usuario_p
and	dt_atualizacao_nrec	= (SELECT	max(dt_atualizacao_nrec)
				   from		ptu_fatura
				   where	nm_usuario_nrec		= nm_usuario_p);

return	nr_seq_fatura_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_fatura (nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
