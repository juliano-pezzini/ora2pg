-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_altera_grupo_exame ( nr_seq_exame_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_w		bigint;
nr_seq_superior_w	bigint;
nr_seq_grupo_w		bigint;
nr_seq_grupo_sup_w	bigint;
qt_exames_grupo_w	bigint;WITH RECURSIVE cte AS (


C01 CURSOR FOR
	SELECT 	nr_seq_exame
	from 	exame_laboratorio WHERE nr_seq_superior = nr_seq_exame_p
  UNION ALL


C01 CURSOR FOR
	SELECT 	nr_seq_exame
	from 	exame_laboratorio JOIN cte c ON (c.prior nr_seq_exame = nr_seq_superior)

) SELECT * FROM cte WHERE nr_seq_exame = nr_seq_exame_p
	
union

	SELECT 	nr_seq_exame
	from 	exame_laboratorio;
;WITH RECURSIVE cte AS (


C02 CURSOR FOR
	SELECT 	nr_seq_exame,nr_seq_grupo,nr_seq_superior
	from 	exame_laboratorio WHERE nr_seq_superior = nr_seq_exame_p
  UNION ALL


C02 CURSOR FOR
	SELECT 	nr_seq_exame,nr_seq_grupo,nr_seq_superior
	from 	exame_laboratorio JOIN cte c ON (c.prior nr_seq_exame = nr_seq_superior)

) SELECT * FROM cte WHERE nr_seq_exame = nr_seq_exame_p
	
union

	SELECT 	nr_seq_exame,
		nr_seq_grupo,
		nr_seq_superior
	from 	exame_laboratorio;
;



BEGIN


open C01;
loop
fetch C01 into
	nr_seq_exame_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	exame_laboratorio
	set	nr_seq_grupo = nr_seq_grupo_p,
		nr_seq_superior = CASE WHEN nr_seq_exame=nr_seq_exame_p THEN  null  ELSE nr_seq_superior END ,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_exame = nr_seq_exame_w;

	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_exame_w,
	nr_seq_grupo_w,
	nr_seq_superior_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then
		select 	max(nr_seq_grupo)
		into STRICT	nr_seq_grupo_sup_w
		from	exame_laboratorio
		where	nr_seq_exame = nr_seq_superior_w;

		if (nr_seq_grupo_sup_w <> nr_seq_grupo_w) then
			--(-20011,'Problemas ao trocra o exame. verifique se o exame superior é do mesmo grupo de destino #@#@');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263993);
		end if;
	end if;

	select 	count(*)
	into STRICT	qt_exames_grupo_w
	from 	exame_laboratorio
	where	nr_seq_superior = nr_seq_exame_w
	and	nr_seq_grupo 	<> nr_seq_grupo_w;

	if (qt_exames_grupo_w > 0) then
		--(-20011,'Problemas ao troca o exame. verifique se o exame superior é do mesmo grupo de destino #@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263993);
	end if;


	end;
end loop;
close C02;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_altera_grupo_exame ( nr_seq_exame_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text) FROM PUBLIC;

