-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_inativar_usuario ( dt_referencia_p timestamp) AS $body$
DECLARE


nm_usuario_w			varchar(15);
qt_dia_senha_w			integer;
dt_alteracao_senha_w		timestamp;
dt_atualizacao_w		timestamp;
dt_prev_troca_senha_w		timestamp;
dt_referencia_w			timestamp;
cd_estabelecimento_w		integer;
qt_prazo_inativar_w			integer;
qt_prazo_w			integer;
qt_prazo_inativar_usu_w		integer;
vl_param_18_usu_w		integer;
ie_inativar_w			varchar(1);
ie_limpar_par_estab_setor_w	varchar(1);
nm_usu_w			varchar(15);

c01 CURSOR FOR
SELECT	a.nm_usuario,
	a.qt_dia_senha,
	a.dt_alteracao_senha,
	a.dt_atualizacao,
	TRUNC(coalesce(dt_alteracao_senha,dt_atualizacao_nrec)) + coalesce(a.qt_dia_senha,0) dt_prev_troca_senha,
	a.cd_estabelecimento
FROM	usuario a
WHERE	a.ie_situacao IN ('A','B')
AND	(a.qt_dia_senha IS NOT NULL AND a.qt_dia_senha::text <> '')
ORDER BY 1;


BEGIN

dt_referencia_w	:= fim_dia(coalesce(dt_referencia_p,clock_timestamp()));
nm_usu_w	:= wheb_usuario_pck.get_nm_usuario;


SELECT	coalesce(vl_parametro,vl_parametro_padrao)
INTO STRICT	qt_prazo_inativar_w
FROM	funcao_parametro
WHERE	cd_funcao	= 0
AND	nr_sequencia	= 108;

ie_limpar_par_estab_setor_w := obter_valor_param_usuario(6001,161,obter_perfil_ativo,nm_usu_w,wheb_usuario_pck.get_cd_estabelecimento);

IF (qt_prazo_inativar_w > 0) THEN
	BEGIN
	
	OPEN C01;
	LOOP
	FETCH C01 INTO
		nm_usuario_w,
		qt_dia_senha_w,
		dt_alteracao_senha_w,
		dt_atualizacao_w,
		dt_prev_troca_senha_w,
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
		qt_prazo_w	:= qt_prazo_inativar_w;
		ie_inativar_w	:= 'S';

		
		SELECT	COUNT(*)
		INTO STRICT	qt_prazo_inativar_usu_w
		FROM	funcao_param_usuario a
		WHERE	a.nm_usuario_param 	= nm_usuario_w
		AND	a.cd_funcao 		= 0
		AND	a.nr_sequencia		= 108;

		IF (coalesce(qt_prazo_inativar_usu_w,0) > 0) THEN
			BEGIN
			SELECT	coalesce(a.vl_parametro,0)
			INTO STRICT	vl_param_18_usu_w
			FROM	funcao_param_usuario a
			WHERE	a.nm_usuario_param 	= nm_usuario_w
			AND	a.cd_funcao 		= 0
			AND	a.nr_sequencia		= 108;
			END;

			qt_prazo_w := vl_param_18_usu_w;
			IF (coalesce(vl_param_18_usu_w,0) = 0) THEN
				ie_inativar_w := 'N';
			END IF;
		END IF;

		IF	((dt_prev_troca_senha_w + qt_prazo_w) < dt_referencia_w) AND (ie_inativar_w = 'S') THEN
			BEGIN

			UPDATE	usuario
			SET 	ie_situacao	= 'I',
				dt_atualizacao	= clock_timestamp(),
				dt_inativacao	= clock_timestamp()
			WHERE	nm_usuario	= nm_usuario_w;

			IF (coalesce(ie_limpar_par_estab_setor_w,'N') = 'S') THEN
				BEGIN
				CALL limpar_parametros_usuario(nm_usuario_w,nm_usu_w);
				CALL limpar_setores_usuario(nm_usuario_w,nm_usu_w);
				CALL limpar_estab_usuario(nm_usuario_w,nm_usu_w);
				END;
			END IF;

			INSERT  INTO  usuario_hist(nr_sequencia,
				nm_usuario,
				nm_usuario_ref,
				ds_alteracao,
				dt_atualizacao)
			VALUES (nextval('usuario_hist_seq'),
				'JOB_INATIVAR',
				nm_usuario_w,
				 wheb_mensagem_pck.get_texto(1204270),
				clock_timestamp());
			END;
		END IF;
		END;
	END LOOP;
	CLOSE C01;
	END;
END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_inativar_usuario ( dt_referencia_p timestamp) FROM PUBLIC;

