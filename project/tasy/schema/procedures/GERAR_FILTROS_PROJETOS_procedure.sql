-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_filtros_projetos (nr_seq_etapa_p bigint, nr_seq_Cronograma_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_filha_w		bigint;
qt_registro_w		bigint;



C01 CURSOR FOR
	SELECT	nr_sequencia
	from 	proj_cron_etapa
	where 	nr_seq_superior = nr_seq_etapa_p
	and	nr_seq_cronograma = nr_seq_cronograma_p;



BEGIN


open C01;
loop
fetch C01 into
	nr_seq_filha_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		insert into w_proj_filtro_etapa values (clock_timestamp(),nm_usuario_p,nr_seq_filha_w);

		select	count(*)
		into STRICT	qt_registro_w
		from	proj_cron_etapa
		where	nr_seq_superior = nr_seq_filha_w;

		if qt_registro_w > 0 then
			CALL gerar_filtros_projetos(nr_seq_Filha_w,nr_seq_cronograma_p,nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE gerar_filtros_projetos (nr_seq_etapa_p bigint, nr_seq_Cronograma_p bigint, nm_usuario_p text) FROM PUBLIC;
