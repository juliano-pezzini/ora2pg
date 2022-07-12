-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuarios_proc_aprov ( nr_sequencia_p bigint, nr_seq_proc_aprov_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_w		varchar(60);
Resultado_w	 	varchar(2000);

c01 CURSOR FOR
SELECT	nm_usuario
from	pessoas_processo_aprovacao_v
where	nr_sequencia		= nr_sequencia_p
and	nr_seq_proc_aprov	= nr_seq_proc_aprov_p;


BEGIN


OPEN C01;
LOOP
FETCH C01 into
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if (coalesce(resultado_w::text, '') = '') then
		resultado_w	:= nm_usuario_w;
	else
		resultado_w	:= Resultado_w || ', ' || nm_usuario_w;
	end if;

END LOOP;

RETURN resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuarios_proc_aprov ( nr_sequencia_p bigint, nr_seq_proc_aprov_p bigint) FROM PUBLIC;
