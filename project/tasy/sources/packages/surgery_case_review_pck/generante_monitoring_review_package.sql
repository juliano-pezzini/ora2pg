-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE surgery_case_review_pck.generante_monitoring_review (nr_cirurgia_p bigint, nm_usuario_p text ) AS $body$
DECLARE


	vl_campo varchar(100);

	tquery varchar(500);

	cmr CURSOR FOR SELECT
						*
					from
						ATENDIMENTO_MONIT_RESP a
					where
						nr_cirurgia = nr_cirurgia_p
						and not exists (select 1
						 from revisao_cirurgia
						where nr_cirurgia = nr_cirurgia_p
						  and ie_tabela_referencia = 'ATENDIMENTO_MONIT_RESP'
						  and nr_seq_origem = a.nr_sequencia);

	cmh CURSOR FOR SELECT
						*
					from
						ATEND_MONIT_HEMOD a
					where
						nr_cirurgia = nr_cirurgia_p
						and not exists (select 1
						 from revisao_cirurgia
						where nr_cirurgia = nr_cirurgia_p
						  and ie_tabela_referencia = 'ATEND_MONIT_HEMOD'
						  and nr_seq_origem = a.nr_sequencia);
						
	cms CURSOR FOR SELECT
						*
					from
						ATENDIMENTO_SINAL_VITAL a
					where
						nr_cirurgia = nr_cirurgia_p
						and not exists (select 1
						 from revisao_cirurgia
						where nr_cirurgia = nr_cirurgia_p
						  and ie_tabela_referencia = 'ATENDIMENTO_SINAL_VITAL'
						  and nr_seq_origem = a.nr_sequencia);

	
  columnItem RECORD;
BEGIN

	FOR monitReg IN cmr
	LOOP
		FOR columnItem IN (SELECT distinct
									a.nm_atributo nm_coluna, obter_desc_exp_idioma(a.cd_exp_label, Obter_Nr_Seq_Idioma(NM_USUARIO_P), null) ds_label
								from
									pepo_sv b,
									tabela_atributo a
								where
									a.nm_atributo = b.nm_atributo
								and
									a.nm_tabela = 'ATENDIMENTO_MONIT_RESP'
								and
									obter_desc_exp_idioma(a.cd_exp_label, Obter_Nr_Seq_Idioma(NM_USUARIO_P), null) is not null
								)
		LOOP

			   tquery := 'SELECT ' ||  columnItem.nm_coluna || ' from ATENDIMENTO_MONIT_RESP where nr_sequencia = ' || monitReg.nr_sequencia;
			   EXECUTE tquery into STRICT vl_campo;

			   if ((vl_campo IS NOT NULL AND vl_campo::text <> '') and vl_campo <> '0') then
			   INSERT INTO revisao_cirurgia(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_grupo,
				ds_informacao,
				ds_observacao,
				vl_informacao,
				dt_registro,
				nm_usuario_reg,
				dt_liberacao,
				nm_usuario_lib,
				ie_tabela_referencia,
				ie_campo_referencia,
				nr_seq_origem,
				ie_status,
				ie_campo_ref_valor,
				nr_cirurgia,
				ie_situacao
				)
			 VALUES (
				nextval('revisao_cirurgia_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				'MN',
				columnItem.ds_label,
				vl_campo,
				vl_campo,
				monitReg.DT_MONITORIZACAO,
				monitReg.NM_USUARIO,
				monitReg.DT_MONITORIZACAO,
				monitReg.NM_USUARIO,
				'ATENDIMENTO_MONIT_RESP',
				'NR_SEQUENCIA',
				monitReg.NR_SEQUENCIA,
				'A',
				columnItem.nm_coluna,
				NR_CIRURGIA_P,
				'A'
				);
				end if;
		END LOOP;
	END LOOP;

	-- hemodinamica
	FOR monitReg IN cmh
	LOOP
		FOR columnItem IN (SELECT distinct
									a.nm_atributo nm_coluna, obter_desc_exp_idioma(a.cd_exp_label, Obter_Nr_Seq_Idioma(NM_USUARIO_P), null) ds_label
								from
									pepo_sv b,
									tabela_atributo a
								where
									a.nm_atributo = b.nm_atributo
								and
									a.nm_tabela = 'ATEND_MONIT_HEMOD'
								and
									obter_desc_exp_idioma(a.cd_exp_label, Obter_Nr_Seq_Idioma(NM_USUARIO_P), null) is not null
								)
		LOOP
			   tquery := 'SELECT ' ||  columnItem.nm_coluna || ' from ATEND_MONIT_HEMOD where nr_sequencia = ' || monitReg.nr_sequencia;
			   EXECUTE tquery into STRICT vl_campo;

			   if ((vl_campo IS NOT NULL AND vl_campo::text <> '') and vl_campo <> '0') then
				   INSERT INTO revisao_cirurgia(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_grupo,
					ds_informacao,
					ds_observacao,
					vl_informacao,
					dt_registro,
					nm_usuario_reg,
					dt_liberacao,
					nm_usuario_lib,
					ie_tabela_referencia,
					ie_campo_referencia,
					nr_seq_origem,
					ie_status,
					ie_campo_ref_valor,
					nr_cirurgia,
					ie_situacao
					)
				 VALUES (
					nextval('revisao_cirurgia_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'MN',
					columnItem.ds_label,
					vl_campo,
					vl_campo,
					monitReg.DT_MONITORACAO,
					monitReg.NM_USUARIO,
					monitReg.DT_MONITORACAO,
					monitReg.NM_USUARIO,
					'ATEND_MONIT_HEMOD',
					'NR_SEQUENCIA',
					monitReg.NR_SEQUENCIA,
					'A',
					columnItem.nm_coluna,
					NR_CIRURGIA_P,
					'A'
					);
				end if;
		END LOOP;
	END LOOP;
	
	FOR monitSinal IN cms
	LOOP
		FOR columnItem IN (SELECT distinct
									a.nm_atributo nm_coluna, obter_desc_exp_idioma(a.cd_exp_label, Obter_Nr_Seq_Idioma(NM_USUARIO_P), null) ds_label
								from
									pepo_sv b,
									tabela_visao_atributo a
								where
									a.nm_atributo = b.nm_atributo
								and obter_desc_exp_idioma(a.cd_exp_label, Obter_Nr_Seq_Idioma(NM_USUARIO_P), null) is not null
								and a.nm_atributo = 'QT_SPO2R'
								and a.nr_sequencia = 105137
								)
		LOOP

			   tquery := 'SELECT ' ||  columnItem.nm_coluna || ' from ATENDIMENTO_SINAL_VITAL where nr_sequencia = ' || monitSinal.nr_sequencia;
			   EXECUTE tquery into STRICT vl_campo;

			   if ((vl_campo IS NOT NULL AND vl_campo::text <> '') and vl_campo <> '0') then
			   INSERT INTO revisao_cirurgia(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_grupo,
				ds_informacao,
				ds_observacao,
				vl_informacao,
				dt_registro,
				nm_usuario_reg,
				dt_liberacao,
				nm_usuario_lib,
				ie_tabela_referencia,
				ie_campo_referencia,
				nr_seq_origem,
				ie_status,
				ie_campo_ref_valor,
				nr_cirurgia,
				ie_situacao
				)
			 VALUES (
				nextval('revisao_cirurgia_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				'MN',
				columnItem.ds_label,
				vl_campo,
				vl_campo,
				monitSinal.DT_SINAL_VITAL,
				monitSinal.NM_USUARIO,
				monitSinal.DT_SINAL_VITAL,
				monitSinal.NM_USUARIO,
				'ATENDIMENTO_SINAL_VITAL',
				'NR_SEQUENCIA',
				monitSinal.NR_SEQUENCIA,
				'A',
				columnItem.nm_coluna,
				NR_CIRURGIA_P,
				'A'
				);
				end if;
		END LOOP;
	END LOOP;

	NULL;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE surgery_case_review_pck.generante_monitoring_review (nr_cirurgia_p bigint, nm_usuario_p text ) FROM PUBLIC;