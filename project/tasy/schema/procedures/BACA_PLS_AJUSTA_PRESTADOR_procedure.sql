-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_ajusta_prestador ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_w			bigint;
cd_medico_executor_w		varchar(10);
nr_seq_prestador_w		bigint;
cd_estabelecimento_w		smallint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_medico_executor,
		cd_estabelecimento
	from	pls_conta
	where	nr_seq_protocolo	= nr_seq_protocolo_p
	and	(cd_medico_executor IS NOT NULL AND cd_medico_executor::text <> '')
	and	coalesce(nr_seq_prestador_exec::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_conta_w,
	cd_medico_executor_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_prestador_w	:= pls_obter_credenciado(cd_medico_executor_w, cd_estabelecimento_w);

	if (coalesce(nr_seq_prestador_w,0) > 0) then
		update	pls_conta
		set	nr_seq_prestador_exec	= nr_seq_prestador_w
		where	nr_sequencia		= nr_seq_conta_w
		and	coalesce(nr_seq_prestador_exec::text, '') = '';
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_ajusta_prestador ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

