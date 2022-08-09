-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE exportar_regras_carta_medica ( NR_SEQ_MODELO_P bigint, NR_SEQ_MODELO_DESTINO_P bigint, IE_SECAO_REGRA_P text, NM_USUARIO_P text) AS $body$
DECLARE


nr_regra_carta_med_w		bigint;
nr_regra_carta_med_old_w	bigint;
qt_regra_destino_w			bigint;

C01 CURSOR FOR
	SELECT  IE_SECAO,
			NR_SEQUENCIA nr_seq_regra
	from    CARTA_MEDICA_REGRA
	where   NR_SEQ_MODELO = nr_seq_modelo_p
	and (ie_secao_regra_p = 'TD' or ie_secao = ie_secao_regra_p);

C02 CURSOR FOR
	SELECT  CD_AREA_PROCEDIMENTO,
			CD_CLASSE_MATERIAL,
			CD_GRUPO_MATERIAL,
			CD_GRUPO_PROC,
			CD_MATERIAL,
			CD_SUBGRUPO_MATERIAL,
			IE_CLASSIFICACAO_DOENCA,
			IE_EVOLUCAO_CLINICA,
			IE_FORA_FAIXA,
			IE_INSERIR_AUT,
			IE_TIPO_DIAGNOSTICO,
			IE_TODOS,
			NR_PROC_INTERNO,
			NR_SEQ_EXAME,
			CD_TIPO_RECOMENDACAO,
			IE_TIPO_REGRA,
			NR_SEQ_CLASSIF_RECOMENDACAO
	from    CARTA_MEDICA_REGRA_ITEM
	where   NR_SEQ_REGRA = nr_regra_carta_med_old_w;
BEGIN
	select 	count(*)
	into STRICT	qt_regra_destino_w
	from    CARTA_MEDICA_REGRA
	where   NR_SEQ_MODELO = nr_seq_modelo_destino_p
	and (ie_secao_regra_p = 'TD' or ie_secao = ie_secao_regra_p);

	if (qt_regra_destino_w = 0) then
		for c01_w in C01 loop
			begin
				nr_regra_carta_med_old_w := c01_w.nr_seq_regra;

				select 	nextval('carta_medica_regra_seq')
				into STRICT	nr_regra_carta_med_w
				;

				insert into CARTA_MEDICA_REGRA(
					NR_SEQUENCIA,
					NR_SEQ_MODELO,
					DT_ATUALIZACAO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO,
					NM_USUARIO_NREC,
					IE_SECAO
				) values (
					nr_regra_carta_med_w,
					nr_seq_modelo_destino_p,
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p,
					c01_w.IE_SECAO);

				commit;

				for c02_w in C02 loop
					begin
						insert into CARTA_MEDICA_REGRA_ITEM(
							NR_SEQUENCIA,
							NM_USUARIO,
							NM_USUARIO_NREC,
							DT_ATUALIZACAO,
							DT_ATUALIZACAO_NREC,
							CD_AREA_PROCEDIMENTO,
							CD_CLASSE_MATERIAL,
							CD_GRUPO_MATERIAL,
							CD_GRUPO_PROC,
							CD_MATERIAL,
							CD_SUBGRUPO_MATERIAL,
							IE_CLASSIFICACAO_DOENCA,
							IE_EVOLUCAO_CLINICA,
							IE_FORA_FAIXA,
							IE_INSERIR_AUT,
							IE_TIPO_DIAGNOSTICO,
							IE_TODOS,
							NR_PROC_INTERNO,
							NR_SEQ_EXAME,
							NR_SEQ_REGRA,
							CD_TIPO_RECOMENDACAO,
							IE_TIPO_REGRA,
							NR_SEQ_CLASSIF_RECOMENDACAO
						) values (
							nextval('carta_medica_regra_item_seq'),
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							clock_timestamp(),
							c02_w.CD_AREA_PROCEDIMENTO,
							c02_w.CD_CLASSE_MATERIAL,
							c02_w.CD_GRUPO_MATERIAL,
							c02_w.CD_GRUPO_PROC,
							c02_w.CD_MATERIAL,
							c02_w.CD_SUBGRUPO_MATERIAL,
							c02_w.IE_CLASSIFICACAO_DOENCA,
							c02_w.IE_EVOLUCAO_CLINICA,
							c02_w.IE_FORA_FAIXA,
							c02_w.IE_INSERIR_AUT,
							c02_w.IE_TIPO_DIAGNOSTICO,
							c02_w.IE_TODOS,
							c02_w.NR_PROC_INTERNO,
							c02_w.NR_SEQ_EXAME,
							nr_regra_carta_med_w,
							c02_w.CD_TIPO_RECOMENDACAO,
							c02_w.IE_TIPO_REGRA,
							c02_w.NR_SEQ_CLASSIF_RECOMENDACAO);

						commit;
					end;
				end loop;
			end;
		end loop;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE exportar_regras_carta_medica ( NR_SEQ_MODELO_P bigint, NR_SEQ_MODELO_DESTINO_P bigint, IE_SECAO_REGRA_P text, NM_USUARIO_P text) FROM PUBLIC;
