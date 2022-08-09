-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_gerar_origem_os_revisao () AS $body$
DECLARE


nr_seq_os_revisao_w	bigint;
nr_seq_os_origem_w	bigint;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	x.nr_seq_os
from	w_migracao_ordem_servico x,
	man_ordem_servico a
where  	x.nr_seq_os_migracao = a.nr_sequencia
and	trunc(a.dt_ordem_servico,'dd') = trunc(clock_timestamp(),'dd')
and     a.cd_pessoa_solicitante = '4464'
order by
	2,1;


BEGIN
open c01;
loop
fetch c01 into	nr_seq_os_revisao_w,
		nr_seq_os_origem_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	man_ordem_servico
	set	nr_seq_origem = nr_seq_os_origem_w
	where	nr_sequencia = nr_seq_os_revisao_w;
	end;
end loop;
close c01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_gerar_origem_os_revisao () FROM PUBLIC;
