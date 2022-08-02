-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE same_caixa_after_post_js ( nr_sequencia_p bigint, nr_seq_caixa_superior_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_local_w	bigint;


BEGIN

if (nr_seq_caixa_superior_p > 0) then
	select 	max(nr_seq_local)
	into STRICT	nr_seq_local_w
	from 	same_caixa
	where 	nr_sequencia = nr_seq_caixa_superior_p;


	update 	same_caixa
	set 	nr_seq_local = nr_seq_local_w
	where 	nr_sequencia = nr_sequencia_p;
end if;

commit;

CALL Ajustar_local_Same(nr_sequencia_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE same_caixa_after_post_js ( nr_sequencia_p bigint, nr_seq_caixa_superior_p bigint, nm_usuario_p text) FROM PUBLIC;

