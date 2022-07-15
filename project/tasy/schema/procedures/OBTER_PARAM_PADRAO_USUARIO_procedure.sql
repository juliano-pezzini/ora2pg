-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_param_padrao_usuario ( cd_funcao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, vl_parametro_p INOUT text) AS $body$
DECLARE


cd_estabelecimento_w	integer;
i			integer;



c01 CURSOR FOR
	SELECT	vl_parametro
	FROM funcao_param_perfil
	WHERE cd_funcao    = cd_funcao_p
	  AND nr_sequencia = nr_sequencia_p
	  AND cd_perfil    = cd_perfil_p
	  AND coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	ORDER BY coalesce(cd_estabelecimento,0);


BEGIN

cd_estabelecimento_w	:= coalesce(cd_estabelecimento_p, 1);

SELECT	vl_parametro
INTO STRICT	vl_parametro_p
FROM funcao_param_Usuario
WHERE cd_funcao    = cd_funcao_p
  AND nr_sequencia = nr_sequencia_p
  AND nm_usuario_param = nm_usuario_p
  AND coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;
EXCEPTION
	WHEN OTHERS THEN
		BEGIN
		i := 0;
		OPEN c01;
		LOOP
		FETCH c01 INTO vl_parametro_p;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		i := i + 1;
		END LOOP;
		CLOSE c01;

		IF (i = 0) THEN
			BEGIN
			SELECT	vl_parametro
			INTO STRICT	vl_parametro_p
			FROM funcao_param_estab
			WHERE cd_funcao    = cd_funcao_p
			  AND nr_seq_param = nr_sequencia_p
			  AND cd_estabelecimento    = cd_estabelecimento_p;
			EXCEPTION
				WHEN OTHERS THEN
					BEGIN
				    	SELECT vl_parametro_padrao
					INTO STRICT vl_parametro_p
					FROM funcao_parametro
				    	WHERE cd_funcao    = cd_funcao_p
		      			  AND nr_sequencia = nr_sequencia_p;
				    	EXCEPTION
    						WHEN OTHERS THEN
					           vl_parametro_p := 'S';
					END;
				END;
		END IF;
		END;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_param_padrao_usuario ( cd_funcao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, vl_parametro_p INOUT text) FROM PUBLIC;

