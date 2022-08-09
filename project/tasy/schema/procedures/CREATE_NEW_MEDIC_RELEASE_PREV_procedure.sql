-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_new_medic_release_prev ( NR_SEQUENCIA_P atend_previsao_alta.nr_sequencia%TYPE, NR_ATENDIMENTO_P atend_previsao_alta.nr_atendimento%TYPE, DT_PREVISTO_ALTA_P atend_previsao_alta.dt_previsto_alta%TYPE, NR_SEQ_CLASSIF_MEDICO_P atend_previsao_alta.nr_seq_classif_medico%TYPE, IE_PROBABILIDADE_ALTA_P atend_previsao_alta.ie_probabilidade_alta%TYPE, IE_ALTA_HOSPITALAR_P atend_previsao_alta.ie_alta_hospitalar%TYPE, NR_DIAS_PREV_ALTA_P atend_previsao_alta.nr_dias_prev_alta%TYPE, IE_REFEICAO_P atend_previsao_alta.ie_refeicao%TYPE default null, DS_OBSERVACAO_P atend_previsao_alta.ds_observacao%TYPE default null, DT_ALTA_MEDICA_P atend_previsao_alta.dt_alta_medica%TYPE default null, CD_MOTIVO_ALTA_P atend_previsao_alta.cd_motivo_alta%TYPE default null, DT_SUSPENCAO_DIETA_P atend_previsao_alta.dt_suspencao_dieta%TYPE default null, CD_PROCESSO_ALTA_P atend_previsao_alta.cd_processo_alta%TYPE default null) AS $body$
DECLARE


    cd_pessoa_fisica_w atend_previsao_alta.cd_profissional%TYPE;
    nm_usuario_w varchar(15) := wheb_usuario_pck.get_nm_usuario;
	cd_evolucao_w  bigint;
    ie_gerar_clinical_notes_w varchar(1) := 'N';
	nr_sequencia_w atend_previsao_alta.nr_sequencia%TYPE;
    ie_situaco_w varchar(1) := 'N';


BEGIN
    SELECT usu.cd_pessoa_fisica INTO STRICT cd_pessoa_fisica_w
    FROM usuario usu
    WHERE usu.nm_usuario = nm_usuario_w;

	ie_gerar_clinical_notes_w := obter_param_usuario(281, 1644, Obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_gerar_clinical_notes_w);

   select CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END  into STRICT ie_situaco_w
   from atend_previsao_alta
   where nr_sequencia=nr_sequencia_p and IE_SITUACAO='A';

    IF (coalesce(nr_sequencia_p::text, '') = '' or ie_situaco_w='N')  THEN

        INSERT INTO atend_previsao_alta(
            NR_SEQUENCIA,
            NR_ATENDIMENTO,
            DT_PREVISTO_ALTA,
            NR_SEQ_CLASSIF_MEDICO,
            IE_PROBABILIDADE_ALTA,
            IE_ALTA_HOSPITALAR,
            NR_DIAS_PREV_ALTA,
            CD_PROFISSIONAL,
            NM_USUARIO,
            NM_USUARIO_NREC,
            IE_SITUACAO,
            DT_REGISTRO,
            DT_ATUALIZACAO,
            DT_LIBERACAO,
            IE_REFEICAO,
			DS_OBSERVACAO,
			DT_ALTA_MEDICA,
			CD_MOTIVO_ALTA,
			DT_SUSPENCAO_DIETA,
			CD_PROCESSO_ALTA)
            VALUES (
                nextval('atend_previsao_alta_seq'),
                NR_ATENDIMENTO_P,
                DT_PREVISTO_ALTA_P,
                NR_SEQ_CLASSIF_MEDICO_P,
                IE_PROBABILIDADE_ALTA_P,
                IE_ALTA_HOSPITALAR_P,
                NR_DIAS_PREV_ALTA_P,
                cd_pessoa_fisica_w,
                nm_usuario_w,
                nm_usuario_w,
                'A',
                clock_timestamp(),
                clock_timestamp(),
                clock_timestamp(),
                IE_REFEICAO_P,
				DS_OBSERVACAO_P,
				DT_ALTA_MEDICA_P,
				CD_MOTIVO_ALTA_P,
				DT_SUSPENCAO_DIETA_P,
				CD_PROCESSO_ALTA_P);

			 select max(nr_sequencia)
             into STRICT nr_sequencia_w
             from atend_previsao_alta
             where nr_atendimento=nr_atendimento_p;

		if ( ie_gerar_clinical_notes_w = 'S' ) then
		begin
		cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_p, nr_sequencia_w, 'MED_DSCHG_REQ', null, 'P', 1, cd_evolucao_w);
		update atend_previsao_alta
		set cd_evolucao = cd_evolucao_w
		where nr_sequencia = nr_sequencia_w;
		end;
		end if;
    ELSE
        UPDATE atend_previsao_alta
        SET
            DT_PREVISTO_ALTA = DT_PREVISTO_ALTA_P,
            NR_SEQ_CLASSIF_MEDICO = NR_SEQ_CLASSIF_MEDICO_P,
            IE_PROBABILIDADE_ALTA = IE_PROBABILIDADE_ALTA_P,
            IE_ALTA_HOSPITALAR = IE_ALTA_HOSPITALAR_P,
            NR_DIAS_PREV_ALTA = NR_DIAS_PREV_ALTA_P,
            CD_PROFISSIONAL = cd_pessoa_fisica_w,
            NM_USUARIO = nm_usuario_w,
            NM_USUARIO_NREC = nm_usuario_w,
            DT_LIBERACAO = clock_timestamp(),
            IE_REFEICAO = IE_REFEICAO_P,
            DS_OBSERVACAO = DS_OBSERVACAO_P,
			DT_ALTA_MEDICA = DT_ALTA_MEDICA_P,
			CD_MOTIVO_ALTA = CD_MOTIVO_ALTA_P,
			DT_SUSPENCAO_DIETA = DT_SUSPENCAO_DIETA_P,
			CD_PROCESSO_ALTA = CD_PROCESSO_ALTA_P
        WHERE
            NR_SEQUENCIA = nr_sequencia_p;

	if (ie_gerar_clinical_notes_w = 'S')then
        begin
            select coalesce(cd_evolucao, 0)
            into STRICT cd_evolucao_w
            from atend_previsao_alta
            where nr_sequencia = nr_sequencia_p;

            if (coalesce(cd_evolucao_w ,0) > 0) then
                CALL clinical_notes_pck.soap_data_after_delete(cd_evolucao_w);
            end if;
        end;
	end if;
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_new_medic_release_prev ( NR_SEQUENCIA_P atend_previsao_alta.nr_sequencia%TYPE, NR_ATENDIMENTO_P atend_previsao_alta.nr_atendimento%TYPE, DT_PREVISTO_ALTA_P atend_previsao_alta.dt_previsto_alta%TYPE, NR_SEQ_CLASSIF_MEDICO_P atend_previsao_alta.nr_seq_classif_medico%TYPE, IE_PROBABILIDADE_ALTA_P atend_previsao_alta.ie_probabilidade_alta%TYPE, IE_ALTA_HOSPITALAR_P atend_previsao_alta.ie_alta_hospitalar%TYPE, NR_DIAS_PREV_ALTA_P atend_previsao_alta.nr_dias_prev_alta%TYPE, IE_REFEICAO_P atend_previsao_alta.ie_refeicao%TYPE default null, DS_OBSERVACAO_P atend_previsao_alta.ds_observacao%TYPE default null, DT_ALTA_MEDICA_P atend_previsao_alta.dt_alta_medica%TYPE default null, CD_MOTIVO_ALTA_P atend_previsao_alta.cd_motivo_alta%TYPE default null, DT_SUSPENCAO_DIETA_P atend_previsao_alta.dt_suspencao_dieta%TYPE default null, CD_PROCESSO_ALTA_P atend_previsao_alta.cd_processo_alta%TYPE default null) FROM PUBLIC;
