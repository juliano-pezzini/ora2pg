-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE load_achi_proc () AS $body$
DECLARE


	qt_registro_procedimento_w bigint;

	qt_registro_proc_versao_w  bigint;

	cd_code_id_w               integer;

	ds_error_w                 varchar(2000);

	get_seq_procedimento_w     bigint;

	cd_grupo_proc_w            bigint;

	cd_procedimento_w          bigint;

	cd_mbs_w                   varchar(5);

	cd_mbs_exist_w             smallint;

	cd_procedimento_mbs_w      bigint;



  c01 CURSOR FOR

	SELECT * from w_achiload_proc;

  r1 c01%rowtype;


BEGIN

open c01;

loop

fetch c01 into r1;

  if c01%notfound then

      update mbs_import_log

      set dt_end = clock_timestamp()

      where ie_status = 'IACHI'

      and coalesce(dt_end::text, '') = '';

      exit;

  end if;

BEGIN

	BEGIN

    CALL gravar_processo_longo('Importing item '||r1.ds_code_id||' - '||substr(r1.ds_ascii_desc,1,255),'INSERT_ACHI_PROCEDIMENTO',null);

		SELECT cd_grupo_proc

		INTO STRICT cd_grupo_proc_w

		FROM grupo_proc

		WHERE cd_original   =r1.cd_block

		AND IE_SITUACAO='A'

		AND ie_origem_proced=19;

		

		SELECT COUNT(*)

		INTO STRICT qt_registro_procedimento_w

		FROM procedimento

		WHERE cd_procedimento_loc     =r1.ds_code_id

		and CD_GRUPO_PROC=cd_grupo_proc_w

		AND ie_origem_proced          =19;

		

		IF (cd_grupo_proc_w            >0) THEN

			IF (qt_registro_procedimento_w=0) THEN

				BEGIN

					SELECT nextval('procedimento_seq')

					INTO STRICT get_seq_procedimento_w

					;

					INSERT

					INTO procedimento(

							cd_procedimento,

							cd_procedimento_loc,

							cd_grupo_proc,

							ds_procedimento,

							ie_situacao,

							ie_sexo_sus,

							qt_idade_minima_sus,

							qt_idade_maxima_sus,

							ie_alta_complexidade,

							ie_ativ_prof_bpa,

							ie_localizador,

							ie_classificacao,

							ie_origem_proced,

							dt_atualizacao,

							nm_usuario,

							ie_gera_associado,

							ie_assoc_adep,

							ie_classif_custo,

							qt_exec_barra,

							ie_cobra_adep,

							ie_ignora_origem,

							ie_exige_autor_sus

						)

						VALUES (

							get_seq_procedimento_w,

							r1.ds_code_id,

							cd_grupo_proc_w,

							SUBSTR(r1.ds_ascii_desc, 1, 255),

							CASE WHEN coalesce(r1.dt_inactive_from::text, '') = '' THEN  'A'  ELSE 'I' END ,

							CASE WHEN r1.ie_sexo=1 THEN  'M' WHEN r1.ie_sexo=2 THEN  'F'  ELSE 'E' END ,

							r1.cd_agel,

							r1.cd_ageh,

							'N',

							'N',

							'S',

							1,

							19,

							clock_timestamp(),

							r1.nm_usuario,

							'S',

							'S',

							'B',

							1,

							'S',

							'N',

							'N'

						);

					cd_mbs_w:=SUBSTR(r1.ds_code_id, 1, 5);

					SELECT COUNT(*)

					INTO STRICT cd_mbs_exist_w

					FROM procedimento

					WHERE cd_procedimento_loc=cd_mbs_w

					AND ie_origem_proced     =20;

					IF (cd_mbs_exist_w        =1) THEN

						SELECT cd_procedimento

						INTO STRICT cd_procedimento_mbs_w

						FROM procedimento

						WHERE cd_procedimento_loc=cd_mbs_w

						AND ie_origem_proced     =20;

						INSERT

						INTO procedimento_conv_sus(

								nr_sequencia,

								dt_atualizacao,

								nm_usuario,

								cd_procedimento,

								ie_origem_proced,

								cd_procedimento_sus,

								ie_origem_proced_sus,

								ie_tipo_atendimento,

								ie_clinica,

								cd_procedimento_loc

							)

							VALUES (

								nextval('procedimento_conv_sus_seq'),

								clock_timestamp(),

								r1.nm_usuario,

								cd_procedimento_mbs_w,

								20,

								get_seq_procedimento_w,

								19,

								NULL,

								NULL,

								r1.ds_code_id

							);

					END IF;

				END;

			ELSE

				UPDATE procedimento

				SET ie_situacao          ='A',

					nm_usuario              =r1.nm_usuario,

					dt_atualizacao          =clock_timestamp(),

					ds_procedimento         =SUBSTR(r1.ds_ascii_desc, 1, 255)

				WHERE cd_procedimento_loc=r1.ds_code_id

				and CD_GRUPO_PROC=cd_grupo_proc_w

				AND ie_origem_proced     =19;

			END IF;

		END IF;

	END;

	BEGIN

		SELECT cd_procedimento

		INTO STRICT cd_procedimento_w

		FROM procedimento

		WHERE cd_procedimento_loc=r1.ds_code_id

		and CD_GRUPO_PROC=cd_grupo_proc_w

		AND ie_origem_proced     =19;

		SELECT COUNT(*)

		INTO STRICT qt_registro_proc_versao_w

		FROM procedimento_versao

		WHERE cd_procedimento       =cd_procedimento_w

		AND ie_origem_proced        =19;

		IF (qt_registro_proc_versao_w=0) THEN

			BEGIN

				INSERT

				INTO procedimento_versao(

						nr_sequencia,

						dt_versao,

						dt_atualizacao,

						nm_usuario,

						dt_atualizacao_nrec,

						nm_usuario_nrec,

						dt_vigencia_inicial,

						dt_vigencia_final,

						cd_procedimento,

						ie_origem_proced,

						cd_versao

					)

					VALUES (

						nextval('procedimento_versao_seq'),

						NULL,

						clock_timestamp(),

						r1.nm_usuario,

						clock_timestamp(),

						r1.nm_usuario,

						r1.dt_effective_from,

						r1.dt_inactive_from,

						get_seq_procedimento_w,

						19,

						NULL

					);

			END;

		ELSE

			UPDATE procedimento_versao

			SET nm_usuario       =r1.nm_usuario,

				dt_atualizacao      =clock_timestamp(),

				dt_vigencia_inicial =r1.dt_effective_from,

				dt_vigencia_final   =r1.dt_inactive_from

			WHERE cd_procedimento=cd_procedimento_w

			AND ie_origem_proced =19;

		END IF;

	END;

EXCEPTION

when others then

	ds_error_w:= 'error ==>  '|| sqlerrm(SQLSTATE) || ' occurred for code id  ' || r1.ds_code_id;

    insert into mbs_import_log(dt_start,ie_status,ds_error) values (clock_timestamp(),'EACHI',ds_error_w);

	ds_error_w := null;

 end;

end loop;

delete FROM w_achiload_proc;

close c01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE load_achi_proc () FROM PUBLIC;
