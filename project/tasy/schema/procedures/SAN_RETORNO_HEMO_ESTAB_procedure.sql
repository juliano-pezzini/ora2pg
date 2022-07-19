-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_retorno_hemo_estab ( nr_seq_emp_estab_hem_p text, nr_seq_motivo_retorno_p bigint, ds_motivo_retorno_p text, nr_seq_emp_estab_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_emp_estab_hem_w	bigint;
nr_seq_producao_w	bigint;
cd_estab_origem_w	smallint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_producao
	from	san_emp_estab_hem
	where	obter_se_contido(nr_sequencia,nr_seq_emp_estab_hem_p) = 'S';

BEGIN

select	max(cd_estab_origem)
into STRICT	cd_estab_origem_w
from	san_emp_estab
where	nr_sequencia = nr_seq_emp_estab_p;


open C01;
loop
fetch C01 into
	nr_seq_emp_estab_hem_w,
	nr_seq_producao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	san_emp_estab_hem
	set	nr_seq_motivo_retorno 	= nr_seq_motivo_retorno_p,
		ds_motivo_retorno	= ds_motivo_retorno_p,
		ie_status		= 'T'
	where	nr_sequencia 		= nr_seq_emp_estab_hem_w;

	update	san_producao
	set	cd_estab_atual	= cd_estab_origem_w
	where	nr_sequencia 	= nr_seq_producao_w;

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_retorno_hemo_estab ( nr_seq_emp_estab_hem_p text, nr_seq_motivo_retorno_p bigint, ds_motivo_retorno_p text, nr_seq_emp_estab_p bigint, nm_usuario_p text) FROM PUBLIC;

