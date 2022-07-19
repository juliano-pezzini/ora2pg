-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desvincular_auditor_aut ( nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		bigint;
qt_min_limite_analise_w		bigint;
nr_seq_grupo_atual_w		bigint;
nr_seq_auditoria_w		bigint;
nm_usuario_exec_w		varchar(50);
dt_inicio_auditoria_w		timestamp;
qt_grupo_w			bigint;
qt_item_pendente_w		bigint;

C00 CURSOR FOR
	SELECT	cd_estabelecimento
	from	pls_outorgante;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_auditoria
	where	cd_estabelecimento = cd_estabelecimento_w
	and	coalesce(dt_liberacao::text, '') = '';


BEGIN
cd_estabelecimento_w := 0;
open C00;
loop
fetch C00 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin

	begin
		select	coalesce(qt_min_limite_analise,0)
		into STRICT	qt_min_limite_analise_w
		from	pls_param_analise_aut
		where	cd_estabelecimento = cd_estabelecimento_w;
	exception
	when others then
		qt_min_limite_analise_w := 0;
	end;

	if (qt_min_limite_analise_w > 0) then
		open C01;
		loop
		fetch C01 into
			nr_seq_auditoria_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			nr_seq_grupo_atual_w := pls_obter_grupo_analise_atual(nr_seq_auditoria_w);

			begin
				select	nm_usuario_exec,
					dt_inicio_auditoria
				into STRICT	nm_usuario_exec_w,
					dt_inicio_auditoria_w
				from	pls_auditoria_grupo
				where	nr_sequencia = nr_seq_grupo_atual_w;
			exception
			when others then
				nm_usuario_exec_w := 'X';
			end;

			if (coalesce(nm_usuario_exec_w,'X') <> 'X') and
				((dt_inicio_auditoria_w + (qt_min_limite_analise_w/24/60)) < clock_timestamp())	then
				CALL pls_desfazer_assumir_grupo_aud(nr_seq_grupo_atual_w,nr_seq_auditoria_w,'L',nm_usuario_p);
			end if;
			end;
		end loop;
		close C01;
	end if;
	end;
end loop;
close C00;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desvincular_auditor_aut ( nm_usuario_p text) FROM PUBLIC;

