-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_pepo_anestesista ( nr_cirurgia_p bigint, ie_opcao_p text, nm_usuario_p text, nr_seq_pepo_p bigint default null) AS $body$
DECLARE


nr_cirurgia_w	varchar(10);

C01 CURSOR FOR
	SELECT	nr_cirurgia
	from	cirurgia
	where	nr_seq_Pepo = nr_seq_pepo_p
	order by nr_cirurgia;


BEGIN

if (coalesce(nr_seq_pepo_p,0) = 0) then
	update	cirurgia
	set	dt_liberacao_anestesista	= CASE WHEN ie_opcao_p='D' THEN to_date(null)  ELSE clock_timestamp() END ,
		dt_atualizacao			= clock_timestamp(),
		nm_usuario_lib_anest		= nm_usuario_p,
		nm_usuario			= nm_usuario_p
	where	nr_cirurgia			= nr_cirurgia_p;
elsif (coalesce(nr_seq_pepo_p,0) > 0 ) then
	update	pepo_cirurgia
	set	dt_liberacao_anestesista	= CASE WHEN ie_opcao_p='D' THEN to_date(null)  ELSE clock_timestamp() END ,
		dt_atualizacao			= clock_timestamp(),
		nm_usuario_lib_anest		= nm_usuario_p,
		nm_usuario			= nm_usuario_p
	where	nr_sequencia			= nr_seq_pepo_p;

	open C01;
	loop
	fetch C01 into
		nr_cirurgia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update	cirurgia
		set	dt_liberacao_anestesista	= CASE WHEN ie_opcao_p='D' THEN to_date(null)  ELSE clock_timestamp() END ,
			dt_atualizacao			= clock_timestamp(),
			nm_usuario_lib_anest		= nm_usuario_p,
			nm_usuario			= nm_usuario_p
		where	nr_cirurgia			= nr_cirurgia_w;
		end;
	end loop;
	close C01;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_pepo_anestesista ( nr_cirurgia_p bigint, ie_opcao_p text, nm_usuario_p text, nr_seq_pepo_p bigint default null) FROM PUBLIC;
