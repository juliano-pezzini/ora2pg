-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE localizar_exame_lab (ds_localizar_p text, nr_seq_localizar_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_exames_p INOUT text, ds_grupos_p INOUT text) AS $body$
DECLARE


nr_sequencia_w 		bigint;
nr_seq_exame_w 		bigint;
nr_seq_superior_w		bigint;
nr_seq_superior_w2	bigint;
nr_seq_grupo_w		bigint;
nr_seq_grupo_w2		bigint;
nr_seq_localizar_w	smallint;
nm_exame_w			varchar(255);
nr_seq_grupo_pesquisa_w	bigint;
nr_seq_exame_pesquisa_w	bigint;
nr_seq_superior_pesq_w	bigint;
ie_sair_cursor_w	varchar(1);
ie_gerar_pai_filho_w	varchar(1);


c001 CURSOR FOR
	SELECT a.nr_seq_exame,
		 a.nr_seq_superior,
		 a.nr_seq_grupo
	from grupo_exame_lab b,
		exame_laboratorio a
	where a.nr_seq_grupo =  b.nr_sequencia
	  and elimina_acentuacao(upper(a.nm_exame)) like '%'|| elimina_acentuacao(upper(ds_localizar_p)) || '%'
	order by b.ds_grupo_exame_lab,
		   a.nr_seq_superior,
		   a.nm_exame;

c003 CURSOR FOR
	SELECT a.nr_seq_exame,
		 a.nr_seq_superior,
		 a.nr_seq_grupo,
		 a.nm_exame
	FROM 	grupo_exame_lab b,
		exame_laboratorio a
	WHERE a.nr_seq_grupo =  b.nr_sequencia
	AND  coalesce(a.nr_seq_superior::text, '') = ''
	ORDER BY b.ds_grupo_exame_lab,
		   coalesce(a.nr_seq_superior,0),
		   a.nm_exame;WITH RECURSIVE cte AS (




C002 CURSOR FOR
	SELECT a.nr_seq_exame,a.nr_seq_superior,a.nr_seq_grupo,a.nm_exame
	FROM grupo_exame_lab b,
		exame_laboratorio a
	 WHERE nr_seq_exame = nr_seq_exame_w
  UNION ALL




C002 CURSOR FOR
	SELECT a.nr_seq_exame,a.nr_seq_superior,a.nr_seq_grupo,a.nm_exame
	FROM grupo_exame_lab b,
		exame_laboratorio a
	 JOIN cte c ON (c.nr_seq_exame = b.nr_seq_superior)

) SELECT * FROM cte WHERE nr_seq_grupo =  nr_sequencia
	AND (a.nr_seq_superior IS NOT NULL AND a.nr_seq_superior::text <> '') ORDER BY  CASE WHEN nr_seq_superior=nr_seq_exame_w THEN  a.nM_exame  ELSE OBTER_DESC_EXAME(nr_seq_superior) END , CASE WHEN nr_seq_superior=nr_seq_exame_w THEN  nr_Seq_exame  ELSE nr_seq_superior END , LEVEL;
;



BEGIN

nr_seq_localizar_w := nr_seq_localizar_p;
nr_sequencia_w	 := 0;
ie_gerar_pai_filho_w := Obter_Param_Usuario(746, 12, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_pai_filho_w);

if (ie_gerar_pai_filho_w = 'N') then

	open c001;
	loop
	fetch c001 into
		nr_seq_exame_w,
		nr_seq_superior_w,
		nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on c001 */
	nr_sequencia_w := nr_sequencia_w + 1;
	if (nr_sequencia_w > nr_seq_localizar_p) then
		begin
		ds_exames_p := to_char(nr_seq_exame_w);
		nr_seq_localizar_w := nr_seq_localizar_p + 1;
		exit;
		end;
	end if;
	end loop;
	close c001;

	if (ds_exames_p IS NOT NULL AND ds_exames_p::text <> '') and (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then
		begin
		ds_exames_p := to_char(nr_seq_superior_w) || ',' || ds_exames_p;
		nr_seq_superior_w2 := nr_seq_superior_w;
		while (nr_seq_superior_w2 IS NOT NULL AND nr_seq_superior_w2::text <> '') loop
			begin
			select nr_seq_superior
			into STRICT	 nr_seq_superior_w2
			from exame_laboratorio
			where nr_seq_exame = nr_seq_superior_w;
			if (nr_seq_superior_w2 IS NOT NULL AND nr_seq_superior_w2::text <> '') and (length(to_char(nr_seq_superior_w2) || ',' || ds_exames_p) < 255) then
				ds_exames_p := to_char(nr_seq_superior_w2) || ',' || ds_exames_p;
			end if;
			nr_seq_superior_w := nr_seq_superior_w2;
			end;
		end loop;
		end;
	end if;
	if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then
		begin
		ds_grupos_p := to_char(nr_seq_grupo_w);
		nr_seq_grupo_w2 := nr_seq_grupo_w;
		while (nr_seq_grupo_w2 IS NOT NULL AND nr_seq_grupo_w2::text <> '') loop
			begin
			select nr_seq_superior
			into STRICT	 nr_seq_grupo_w2
			from grupo_exame_lab
			where nr_sequencia = nr_seq_grupo_w;
			if (nr_seq_grupo_w2 IS NOT NULL AND nr_seq_grupo_w2::text <> '') then
				ds_grupos_p := to_char(nr_seq_grupo_w2) || ',' || ds_grupos_p;
			end if;
			nr_seq_grupo_w := nr_seq_grupo_w2;
			end;
		end loop;
		end;
	else
		nr_seq_localizar_w := 0;
	end if;
else

	OPEN c003;
	LOOP
	FETCH c003 INTO
		nr_seq_exame_w,
		nr_seq_superior_w,
		nr_seq_grupo_w,
		nm_exame_w;
	EXIT WHEN NOT FOUND; /* apply on c003 */
		BEGIN
		if (ie_sair_cursor_w	= 'S') then
			exit;
		end if;

		ie_sair_cursor_w	:= 'N';

		IF (elimina_acentuacao(UPPER(nm_exame_w)) LIKE '%'|| elimina_acentuacao(UPPER(ds_localizar_p)) || '%') THEN

			nr_sequencia_w := nr_sequencia_w + 1;

			IF (nr_sequencia_w > nr_seq_localizar_p) THEN

				nr_seq_localizar_w := nr_seq_localizar_p + 1;
				ds_exames_p := TO_CHAR(nr_seq_exame_w);
				nr_seq_grupo_pesquisa_w := nr_seq_grupo_w;
				nr_seq_exame_pesquisa_w	:= nr_seq_exame_w;
				nr_seq_superior_pesq_w	:= nr_seq_superior_w;
				EXIT;
			END IF;
		END IF;


		OPEN C002;
		LOOP
		FETCH C002 INTO
			nr_seq_exame_w,
			nr_seq_superior_w,
			nr_seq_grupo_w,
			nm_exame_w;
		EXIT WHEN NOT FOUND; /* apply on C002 */
			BEGIN

			IF (elimina_acentuacao(UPPER(nm_exame_w)) LIKE '%'|| elimina_acentuacao(UPPER(ds_localizar_p)) || '%') THEN
				nr_sequencia_w := nr_sequencia_w + 1;
				IF (nr_sequencia_w > nr_seq_localizar_p) THEN
					nr_seq_localizar_w := nr_seq_localizar_p + 1;
					ds_exames_p := TO_CHAR(nr_seq_exame_w);
					nr_seq_grupo_pesquisa_w := nr_seq_grupo_w;
					nr_seq_exame_pesquisa_w	:= nr_seq_exame_w;
					nr_seq_superior_pesq_w	:= nr_seq_superior_w;
					ie_sair_cursor_w	:= 'S';
					EXIT;
				END IF;
			END IF;
			END;
		END LOOP;
		CLOSE C002;


		END;
	END LOOP;
	CLOSE c003;

	IF (ds_exames_p IS NOT NULL AND ds_exames_p::text <> '') AND (nr_seq_superior_pesq_w IS NOT NULL AND nr_seq_superior_pesq_w::text <> '') THEN
		BEGIN
		ds_exames_p := TO_CHAR(nr_seq_superior_pesq_w) || ',' || ds_exames_p;
		nr_seq_superior_w2 := nr_seq_superior_pesq_w;

		WHILE (nr_seq_superior_w2 IS NOT NULL AND nr_seq_superior_w2::text <> '') LOOP
			BEGIN
			SELECT nr_seq_superior
			INTO STRICT	 nr_seq_superior_w2
			FROM exame_laboratorio
			WHERE nr_seq_exame = nr_seq_superior_pesq_w;
			IF (nr_seq_superior_w2 IS NOT NULL AND nr_seq_superior_w2::text <> '') THEN
				ds_exames_p := TO_CHAR(nr_seq_superior_w2) || ',' || ds_exames_p;
			END IF;
			nr_seq_superior_pesq_w := nr_seq_superior_w2;
			END;
		END LOOP;
		END;
	END IF;

	IF (nr_seq_grupo_pesquisa_w IS NOT NULL AND nr_seq_grupo_pesquisa_w::text <> '') THEN
		BEGIN
		ds_grupos_p := TO_CHAR(nr_seq_grupo_pesquisa_w);
		nr_seq_grupo_w2 := nr_seq_grupo_pesquisa_w;
		WHILE (nr_seq_grupo_w2 IS NOT NULL AND nr_seq_grupo_w2::text <> '') LOOP
			BEGIN
			SELECT nr_seq_superior
			INTO STRICT	 nr_seq_grupo_w2
			FROM grupo_exame_lab
			WHERE nr_sequencia =nr_seq_grupo_pesquisa_w;
			IF (nr_seq_grupo_w2 IS NOT NULL AND nr_seq_grupo_w2::text <> '') THEN
				ds_grupos_p := TO_CHAR(nr_seq_grupo_w2) || ',' || ds_grupos_p;
			END IF;
			nr_seq_grupo_pesquisa_w := nr_seq_grupo_w2;
			END;
		END LOOP;
		END;
	ELSE
		nr_seq_localizar_w := 0;
	END IF;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE localizar_exame_lab (ds_localizar_p text, nr_seq_localizar_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_exames_p INOUT text, ds_grupos_p INOUT text) FROM PUBLIC;
