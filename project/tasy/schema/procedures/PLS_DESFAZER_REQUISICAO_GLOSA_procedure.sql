-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_requisicao_glosa ( nr_seq_requisicao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_requisicao_proc_w	bigint;
nr_seq_requisicao_mat_w		bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p;


BEGIN

open c01;
loop
fetch c01 into	nr_seq_requisicao_proc_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	delete	from pls_requisicao_glosa
	where	nr_seq_req_proc	= nr_seq_requisicao_proc_w;

end loop;
close c01;

open c02;
loop
fetch c02 into	nr_seq_requisicao_mat_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	delete	from pls_requisicao_glosa
	where	nr_seq_req_mat	= nr_seq_requisicao_mat_w;

end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_requisicao_glosa ( nr_seq_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;

