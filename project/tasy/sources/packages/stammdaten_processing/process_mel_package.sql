-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE stammdaten_processing.process_mel ( import_p w_xdok_import.NR_SEQUENCIA%type, nm_usuario_p grupo_proc.NM_USUARIO%TYPE default 'TASYLOAD') AS $body$
DECLARE


	  cd_area_count_w                 bigint;
	  nm_counter_w                    bigint;
	  cd_area_procedimento_seq_w      area_procedimento.cd_area_procedimento%type;
	  CD_GRUPO_PROC_W                 GRUPO_PROC.CD_GRUPO_PROC%type;
	  current_setting('stammdaten_processing.ds_area_procedimento_w')::AREA_PROCEDIMENTO.DS_AREA_PROCEDIMENTO%type          AREA_PROCEDIMENTO.DS_AREA_PROCEDIMENTO%type:='MEL_CATALOG_PROCEDURES';
	  IE_ORIGEM_PROCED_W              AREA_PROCEDIMENTO.IE_ORIGEM_PROCED%type := 40;
	  CD_GROUP_W                      GRUPO_PROC.CD_GRUPO_PROC%type;
	  CD_GRUPO_PROC_LOC_V_W           GRUPO_PROC.CD_GRUPO_PROC_LOC%type := 'MEL99.99';
	  cd_procedimento_count_w         numeric(20);
	  cd_compl_procedimento_count_w   numeric(20);
	  cd_procedimento_w               PROCEDIMENTO.CD_PROCEDIMENTO%type;
	  cd_grupo_w                      GRUPO_PROC.CD_GRUPO_PROC%type;
	  cd_grupo_proc_ww                GRUPO_PROC.CD_GRUPO_PROC_LOC%type;
	  cd_procedimento_versao_count_w  numeric(20);
	  cd_versao_w                     PROCEDIMENTO_VERSAO.CD_VERSAO%type;

	  CD_ESPECIALIDADE_W              ESPECIALIDADE_PROC.CD_ESPECIALIDADE%type;
	  CD_DEFAULT_SPECIALITY_W         ESPECIALIDADE_PROC.CD_ESPECIALIDADE_LOC%type := 'MEL99';
	  DS_DEF_ESPECIALIDADE_W          ESPECIALIDADE_PROC.DS_ESPECIALIDADE%type := 'MEL - Others';
	  DS_ESPECIALIDADE_W              ESPECIALIDADE_PROC.DS_ESPECIALIDADE%type;

	c01 CURSOR(NR_SEQ_IMPORT_V W_XDOK_HDG_STRUCTURE_AUT.NR_SEQ_IMPORT%type) FOR
		SELECT HDGMEL, TEXT FROM W_XDOK_HDGMEL
		WHERE HDGMEL LIKE 'MEL%'
		AND NR_SEQ_IMPORT = NR_SEQ_IMPORT_V;

	c02 CURSOR(NR_SEQ_IMPORT_V W_XDOK_HDG_STRUCTURE_AUT.NR_SEQ_IMPORT%type) FOR
		SELECT GRUPPE, BEZEICHNUNG, BEREICH from W_XDOK_TREELIST
		where BEREICH LIKE 'MEL%'
		AND NR_SEQ_IMPORT = NR_SEQ_IMPORT_V;

	c03 CURSOR(NR_SEQ_IMPORT_V W_XDOK_HDG_STRUCTURE_AUT.NR_SEQ_IMPORT%type)
	FOR
	SELECT LEISTUNG,
		KURZTEXT,
		GESCHLECHT,
		MINDESTALTER,
		HOCHSTALTER,
		GRUPPE,
		ANATOMIEFEIN,
		LEISTUNGSART,
		ZUGANG,
		LEISTUNGSEINHEIT,
		LGR,
		WARNINGANZAHLAUFENTHALT,
		ERRORANZAHLTAG,
		MEL_AMBULANT,
		MEL0_TAGE,
		MEL_TKL,
		MEL_OP,
		QUELLE,
		ERFASSUNGSTATIONAR,
		GRUPPEAMBULANT,
		LGRAMBULANT,
		WARNINGANZAHLAMBULANT,
		ERRORANZAHLAMBULANT,
		DIAGNOSEAMBULANT,
		ERFASSUNGAMBULANT,
		BETTENFUHRENDERFUCO,
		ANATOMIEGROB,
		ERRORANZAHLAUFENTHALT,
		WARNINGANZAHLTAG
		FROM W_XDOK_MELLIST
		WHERE NR_SEQ_IMPORT = NR_SEQ_IMPORT_V;

		
BEGIN
			SELECT COUNT(1) INTO STRICT cd_area_count_w FROM AREA_PROCEDIMENTO
			WHERE DS_AREA_PROCEDIMENTO = current_setting('stammdaten_processing.ds_area_procedimento_w')::AREA_PROCEDIMENTO.DS_AREA_PROCEDIMENTO%type;
			
			begin
				if (cd_area_count_w = 0) then
					SELECT MAX(cd_area_procedimento) + 1 INTO STRICT cd_area_procedimento_seq_w FROM area_procedimento;
					INSERT
					INTO AREA_PROCEDIMENTO(
						CD_AREA_PROCEDIMENTO,
						DS_AREA_PROCEDIMENTO,
						DT_ATUALIZACAO,
						NM_USUARIO,
						IE_ORIGEM_PROCED,
						CD_ORIGINAL,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						CD_SISTEMA_ANT
					)
					VALUES (
						cd_area_procedimento_seq_w,
						current_setting('stammdaten_processing.ds_area_procedimento_w')::AREA_PROCEDIMENTO.DS_AREA_PROCEDIMENTO%type,
						clock_timestamp(),
						nm_usuario_p,
						IE_ORIGEM_PROCED_W,
						cd_area_procedimento_seq_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_area_procedimento_seq_w
					);
				else
				SELECT MAX(cd_area_procedimento) INTO STRICT cd_area_procedimento_seq_w FROM area_procedimento
						  WHERE DS_AREA_PROCEDIMENTO = current_setting('stammdaten_processing.ds_area_procedimento_w')::AREA_PROCEDIMENTO.DS_AREA_PROCEDIMENTO%type;
				end if;
				commit;
				-- end of AREA_PROCEDIMENTO
				FOR r01 in c01(import_p) LOOP
					SELECT COUNT(1) into STRICT nm_counter_w FROM ESPECIALIDADE_PROC where CD_ESPECIALIDADE_LOC = r01.HDGMEL AND ie_origem_proced = IE_ORIGEM_PROCED_W;
					
					if (nm_counter_w = 0) then
						SELECT  MAX(CD_ESPECIALIDADE) + 1 INTO STRICT CD_ESPECIALIDADE_W FROM ESPECIALIDADE_PROC;
						INSERT INTO ESPECIALIDADE_PROC(
						CD_ESPECIALIDADE,
						DS_ESPECIALIDADE,
						DT_ATUALIZACAO,
						NM_USUARIO,
						CD_AREA_PROCEDIMENTO,
						CD_ESPECIALIDADE_MEDICA,
						IE_ORIGEM_PROCED,
						CD_ORIGINAL,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						CD_SISTEMA_ANT,
						CD_ESPECIALIDADE_LOC
						)
						VALUES (
						CD_ESPECIALIDADE_W,
						SUBSTR(r01.TEXT, 1, 240),
						clock_timestamp(),
						nm_usuario_p,
						cd_area_procedimento_seq_w,
						null,
						IE_ORIGEM_PROCED_W,
						cd_area_procedimento_seq_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_area_procedimento_seq_w,
						r01.HDGMEL
						);
					ELSE
						UPDATE especialidade_proc
						SET ds_especialidade = SUBSTR(r01.TEXT, 1, 240),
							DT_ATUALIZACAO_NREC     = clock_timestamp(),
							NM_USUARIO_NREC         = nm_usuario_p,
							CD_AREA_PROCEDIMENTO = cd_area_procedimento_seq_w
						WHERE CD_ESPECIALIDADE_LOC = r01.HDGMEL
						AND ie_origem_proced = IE_ORIGEM_PROCED_W;
					END IF;
				END LOOP;
				COMMIT;

				--CHECK AND INSERT A DEFAULT SPECIALITY if it does not exist
				SELECT COUNT(1) into STRICT nm_counter_w FROM ESPECIALIDADE_PROC where CD_ESPECIALIDADE_LOC = CD_DEFAULT_SPECIALITY_W AND ie_origem_proced = IE_ORIGEM_PROCED_W;
				
				if (nm_counter_w = 0) then
					SELECT  MAX(CD_ESPECIALIDADE) + 1 INTO STRICT CD_ESPECIALIDADE_W FROM ESPECIALIDADE_PROC;
					INSERT INTO ESPECIALIDADE_PROC(
					CD_ESPECIALIDADE,
					DS_ESPECIALIDADE,
					DT_ATUALIZACAO,
					NM_USUARIO,
					CD_AREA_PROCEDIMENTO,
					CD_ESPECIALIDADE_MEDICA,
					IE_ORIGEM_PROCED,
					CD_ORIGINAL,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					CD_SISTEMA_ANT,
					CD_ESPECIALIDADE_LOC
					)
					VALUES (
					CD_ESPECIALIDADE_W,
					SUBSTR(DS_DEF_ESPECIALIDADE_W, 1, 240),
					clock_timestamp(),
					nm_usuario_p,
					cd_area_procedimento_seq_w,
					null,
					IE_ORIGEM_PROCED_W,
					cd_area_procedimento_seq_w,
					clock_timestamp(),
					nm_usuario_p,
					cd_area_procedimento_seq_w,
					CD_DEFAULT_SPECIALITY_W
					);
				ELSE
					UPDATE especialidade_proc
					SET ds_especialidade = SUBSTR(DS_DEF_ESPECIALIDADE_W, 1, 240),
						DT_ATUALIZACAO_NREC     = clock_timestamp(),
						NM_USUARIO_NREC         = nm_usuario_p,
						CD_AREA_PROCEDIMENTO = cd_area_procedimento_seq_w
					WHERE CD_ESPECIALIDADE_LOC = CD_DEFAULT_SPECIALITY_W
					AND ie_origem_proced = IE_ORIGEM_PROCED_W;
				END IF;
				commit;
				--end of ESPECIALIDADE_PROC
				FOR r02 in c02(import_p) LOOP
					--GRUPPE, BEZEICHNUNG, BEREICH
					--CD_GRUPO_PROC_LOC_W,DS_GRUPO_PROC_W,CD_AREA_W;
					SELECT COUNT(1) into STRICT nm_counter_w FROM grupo_proc where cd_grupo_proc_loc = r02.GRUPPE  AND ie_origem_proced = IE_ORIGEM_PROCED_W;

					SELECT  MAX(CD_ESPECIALIDADE) INTO STRICT CD_ESPECIALIDADE_W FROM ESPECIALIDADE_PROC where CD_ESPECIALIDADE_LOC = SUBSTR(r02.GRUPPE,1,5) AND ie_origem_proced = IE_ORIGEM_PROCED_W;

					if (nm_counter_w = 0) then
						SELECT  MAX(cd_grupo_proc)+1 INTO STRICT cd_grupo_proc_w FROM grupo_proc;
						INSERT INTO grupo_proc(
									  cd_grupo_proc,
									  ds_grupo_proc,
									  cd_especialidade,
									  ie_situacao,
									  dt_atualizacao,
									  nm_usuario,
									  ie_origem_proced,
									  cd_original,
									  ds_observacao,
									  cd_sistema_ant,
									  cd_grupo_proc_loc
									  ) VALUES (
									  cd_grupo_proc_w,
									  SUBSTR(r02.BEZEICHNUNG, 1, 240),
									  CD_ESPECIALIDADE_W,
									  'A',
									  clock_timestamp(),
									  nm_usuario_p,
									  IE_ORIGEM_PROCED_W,
									  cd_grupo_proc_w,
									  null,
									  null, --can we update it
									  r02.GRUPPE
									  );
					else
						UPDATE grupo_proc
						SET ds_grupo_proc      = SUBSTR(r02.BEZEICHNUNG, 1, 240),
							dt_atualizacao     = clock_timestamp(),
							nm_usuario         = nm_usuario_p,
							cd_especialidade   = CD_ESPECIALIDADE_W 
						WHERE cd_grupo_proc_loc = r02.GRUPPE AND ie_origem_proced = IE_ORIGEM_PROCED_W;
					END IF;
				END LOOP;
				
				commit;

			EXCEPTION
				WHEN no_data_found THEN
				CALL grava_log_tasy(52026, 'empty tables-'  || substr(dbms_utility.format_call_stack,1,1960), 'praut');
			END;


			--CHECK AND INSERT A DEFAULT GROUP if it does not exist
			SELECT COUNT(1) into STRICT nm_counter_w FROM grupo_proc
			where cd_grupo_proc_loc = CD_GRUPO_PROC_LOC_V_W AND ie_origem_proced = IE_ORIGEM_PROCED_W;

			SELECT MAX(CD_ESPECIALIDADE) INTO STRICT CD_ESPECIALIDADE_W FROM ESPECIALIDADE_PROC
			where CD_ESPECIALIDADE_LOC = CD_DEFAULT_SPECIALITY_W AND ie_origem_proced = IE_ORIGEM_PROCED_W;

			if ( nm_counter_w = 0 ) then
				SELECT MAX(cd_grupo_proc)+1 INTO STRICT cd_grupo_proc_w FROM grupo_proc;
				INSERT INTO grupo_proc(
							  cd_grupo_proc,
							  ds_grupo_proc,
							  cd_especialidade,
							  ie_situacao,
							  dt_atualizacao,
							  nm_usuario,
							  ie_origem_proced,
							  cd_original,
							  ds_observacao,
							  cd_sistema_ant,
							  cd_grupo_proc_loc
						  ) VALUES (
							  cd_grupo_proc_w,
							  SUBSTR(DS_DEF_ESPECIALIDADE_W, 1, 240),
							  CD_ESPECIALIDADE_W,
							  'A',
							  clock_timestamp(),
							  nm_usuario_p,
							  IE_ORIGEM_PROCED_W,
							  cd_grupo_proc_w,
							  null,
							  null, --can we update it
							  CD_GRUPO_PROC_LOC_V_W
						  );
			else
				UPDATE grupo_proc
				SET ds_grupo_proc = SUBSTR(DS_DEF_ESPECIALIDADE_W, 1, 240),
					dt_atualizacao     = clock_timestamp(),
					nm_usuario         = nm_usuario_p,
					cd_especialidade = CD_ESPECIALIDADE_W 
				WHERE cd_grupo_proc_loc = CD_GRUPO_PROC_LOC_V_W AND ie_origem_proced = IE_ORIGEM_PROCED_W;
			END IF;
			
			commit;
			
			FOR r03 in c03(import_p) LOOP

				BEGIN
					select count(1) into STRICT cd_procedimento_count_w from PROCEDIMENTO where CD_PROCEDIMENTO_LOC = r03.LEISTUNG;
					
					if (substr(r03.GRUPPE,1,3) = 'MEL') then
						BEGIN
							select CD_GRUPO_PROC into STRICT cd_grupo_proc_ww from GRUPO_PROC where CD_GRUPO_PROC_loc = r03.GRUPPE;
						EXCEPTION
						WHEN no_data_found THEN
							cd_grupo_proc_ww := NULL;
						END;
					END IF;

					if ( coalesce(cd_grupo_proc_ww::text, '') = '' OR cd_grupo_proc_ww='' or substr(r03.GRUPPE,1,3) != 'MEL') then
						select CD_GRUPO_PROC into STRICT cd_grupo_proc_ww from GRUPO_PROC where CD_GRUPO_PROC_loc = CD_GRUPO_PROC_LOC_V_W;
					END IF;

				if (cd_procedimento_count_w = 0) then
					select MAX(CD_PROCEDIMENTO)+1 into STRICT cd_procedimento_w from procedimento;
					INSERT INTO PROCEDIMENTO(
						CD_PROCEDIMENTO_LOC,
						IE_SITUACAO,
						IE_LOCALIZADOR ,
						IE_CLASSIFICACAO,
						IE_ORIGEM_PROCED,
						IE_CLASSIF_CUSTO,
						QT_EXEC_BARRA,
						IE_ALTA_COMPLEXIDADE,
						IE_ATIV_PROF_BPA,
						IE_IGNORA_ORIGEM,
						IE_EXIGE_AUTOR_SUS,
						IE_GERA_ASSOCIADO,
						ie_assoc_adep,
						ie_cobra_adep,
						ds_procedimento,
						IE_SEXO_SUS,
						QT_IDADE_MINIMA_SUS,
						QT_IDADE_MAXIMA_SUS,
						dt_atualizacao,
						nm_usuario,
						CD_PROCEDIMENTO,
						CD_GRUPO_PROC
					) VALUES (
						r03.LEISTUNG,
						'A',
						'S',
						'1',
						IE_ORIGEM_PROCED_W,
						'B',
						1,
						'N',
						'N',
						'N',
						'N',
						'S',
						'S',
						'S',
						r03.KURZTEXT,
						CASE WHEN r03.GESCHLECHT='M' THEN  'M' WHEN r03.GESCHLECHT='W' THEN  'F'  ELSE 'A' END ,
						r03.MINDESTALTER,
						r03.HOCHSTALTER,
						clock_timestamp(),
						nm_usuario_p,
						cd_procedimento_w,
						cd_grupo_proc_ww
					);
				else
					UPDATE PROCEDIMENTO
					SET
					  ds_procedimento = r03.KURZTEXT,
					  IE_SEXO_SUS = CASE WHEN r03.GESCHLECHT='M' THEN  'M' WHEN r03.GESCHLECHT='W' THEN  'F'  ELSE 'A' END ,
					  QT_IDADE_MINIMA_SUS = r03.MINDESTALTER,
					  QT_IDADE_MAXIMA_SUS = r03.HOCHSTALTER,
					  IE_ORIGEM_PROCED = IE_ORIGEM_PROCED_W,
					  IE_SITUACAO = 'A',
					  nm_usuario = nm_usuario_p
					WHERE CD_PROCEDIMENTO_LOC = r03.LEISTUNG;

					select MAX(CD_PROCEDIMENTO) into STRICT cd_procedimento_w from PROCEDIMENTO where CD_PROCEDIMENTO_LOC = r03.LEISTUNG;
				END IF;

				select count(*) into STRICT cd_compl_procedimento_count_w from COMPL_PROCEDIMENTO where CD_PROCEDIMENTO = cd_procedimento_w;
				if (cd_compl_procedimento_count_w = 0) then
					INSERT INTO COMPL_PROCEDIMENTO(
						NR_SEQUENCIA,
						CD_ANATOMY_FINE,
						CD_SERVICE_TYPE,
						CD_ACCESS,
						CD_POWER_UNIT,
						CD_SERVICE_GROUP,
						QT_W_LIMIT_STAY,
						QT_E_LIMIT_DAY,
						CD_DUMMY,
						IE_MEL_GT_ZERO_DAYS,
						CD_MEL_DAY_CLINIC,
						CD_MEL_OPERATIVE,
						CD_SOURCE,
						IE_REG_MANDATORY,
						CD_OP_GROUP,
						CD_OP_SER_GROUP,
						QT_W_LIMIT_OP,
						QT_E_LIMIT_OP,
						CD_OP_DOC_OBLIGATORY,
						IE_MEL_OP_PERFORMABLE,
						IE_FUCO_PERMITTED,
						CD_PROCEDIMENTO,
						IE_ORIGEM_PROCED,
						NM_USUARIO,
						DT_ATUALIZACAO,
						NM_USUARIO_NREC,
						DT_ATUALIZACAO_NREC,
						CD_ANATOMY_ROUGH,
						CD_GROUP,
						QT_E_LIMIT_STAY,
						QT_W_LIMIT_DAY
					) VALUES (
						nextval('compl_procedimento_seq'),
						r03.ANATOMIEFEIN,
						r03.LEISTUNGSART,     
						r03.ZUGANG,           
						r03.LEISTUNGSEINHEIT,       
						r03.LGR,    
						r03.WARNINGANZAHLAUFENTHALT,     
						r03.ERRORANZAHLTAG,      
						r03.MEL_AMBULANT,            
						r03.MEL0_TAGE, 
						r03.MEL_TKL,   
						r03.MEL_OP,    
						r03.QUELLE,           
						r03.ERFASSUNGSTATIONAR,  
						r03.GRUPPEAMBULANT, 
						r03.LGRAMBULANT, 
						r03.WARNINGANZAHLAMBULANT, 
						r03.ERRORANZAHLAMBULANT, 
						r03.DIAGNOSEAMBULANT, 
						r03.ERFASSUNGAMBULANT, 
						r03.BETTENFUHRENDERFUCO,
						cd_procedimento_w,
						IE_ORIGEM_PROCED_W,
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						r03.ANATOMIEGROB,
						r03.GRUPPE,
						r03.ERRORANZAHLAUFENTHALT,
						r03.WARNINGANZAHLTAG
					);
				else
					UPDATE COMPL_PROCEDIMENTO
					SET 
					CD_ANATOMY_FINE = r03.ANATOMIEFEIN,
					CD_SERVICE_TYPE = r03.LEISTUNGSART,
					CD_ACCESS = r03.ZUGANG,
					CD_POWER_UNIT = r03.LEISTUNGSEINHEIT,
					CD_SERVICE_GROUP = r03.LGR,
					QT_W_LIMIT_STAY = r03.WARNINGANZAHLAUFENTHALT,
					QT_E_LIMIT_DAY = r03.ERRORANZAHLTAG,
					CD_DUMMY = r03.MEL_AMBULANT,
					IE_MEL_GT_ZERO_DAYS = r03.MEL0_TAGE,
					CD_MEL_DAY_CLINIC = r03.MEL_TKL,
					CD_MEL_OPERATIVE = r03.MEL_OP,
					CD_SOURCE = r03.QUELLE,
					IE_REG_MANDATORY = r03.ERFASSUNGSTATIONAR,
					CD_OP_GROUP = r03.GRUPPEAMBULANT,
					CD_OP_SER_GROUP = r03.LGRAMBULANT,
					QT_W_LIMIT_OP = r03.WARNINGANZAHLAMBULANT,
					QT_E_LIMIT_OP = r03.ERRORANZAHLAMBULANT,
					CD_OP_DOC_OBLIGATORY = r03.DIAGNOSEAMBULANT,
					IE_MEL_OP_PERFORMABLE = r03.ERFASSUNGAMBULANT,
					IE_FUCO_PERMITTED = r03.BETTENFUHRENDERFUCO,
					NM_USUARIO_NREC = nm_usuario_p,
					DT_ATUALIZACAO_NREC = clock_timestamp(),
					CD_ANATOMY_ROUGH = r03.ANATOMIEGROB,
					CD_GROUP         = r03.GRUPPE,
					QT_E_LIMIT_STAY  = r03.ERRORANZAHLAUFENTHALT,
					QT_W_LIMIT_DAY   = r03.WARNINGANZAHLTAG
					where CD_PROCEDIMENTO = cd_procedimento_w and IE_ORIGEM_PROCED = IE_ORIGEM_PROCED_W;
				end if;

				select count(*) into STRICT cd_procedimento_versao_count_w from PROCEDIMENTO_VERSAO where CD_PROCEDIMENTO = cd_procedimento_w;
				if (cd_procedimento_versao_count_w = 0) then
					cd_versao_w := 0;
				ELSE
					begin
						select coalesce(MAX((CD_VERSAO)::numeric ), 0) into STRICT cd_versao_w from PROCEDIMENTO_VERSAO where CD_PROCEDIMENTO = cd_procedimento_w;
					exception
					when others then
						cd_versao_w := 0;
					end;
				END IF;

				INSERT INTO PROCEDIMENTO_VERSAO(
					NR_SEQUENCIA,
					CD_VERSAO,
					DT_ATUALIZACAO,
					NM_USUARIO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					DT_VIGENCIA_INICIAL,
					DT_VIGENCIA_FINAL,
					CD_PROCEDIMENTO,
					ie_origem_proced
				) VALUES (
					nextval('procedimento_versao_seq'),
					cd_versao_w+1,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					null,
					cd_procedimento_w,
					IE_ORIGEM_PROCED_W
				);

				if (cd_procedimento_versao_count_w != 0) then
					UPDATE PROCEDIMENTO_VERSAO 
					SET 
					DT_ATUALIZACAO_NREC = clock_timestamp(),
					NM_USUARIO_NREC = nm_usuario_p,
					DT_VIGENCIA_FINAL = clock_timestamp()
					where CD_VERSAO = cd_versao_w and CD_PROCEDIMENTO = cd_procedimento_w and ie_origem_proced = IE_ORIGEM_PROCED_W;
				END IF;

				if (mod(c03%rowcount, 100) = 0) then
					commit;
				end if;

				END;
			end loop;

			COMMIT;

		END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE stammdaten_processing.process_mel ( import_p w_xdok_import.NR_SEQUENCIA%type, nm_usuario_p grupo_proc.NM_USUARIO%TYPE default 'TASYLOAD') FROM PUBLIC;