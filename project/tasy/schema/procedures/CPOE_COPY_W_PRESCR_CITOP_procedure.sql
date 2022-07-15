-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_copy_w_prescr_citop ( NR_CPOE_OLD_ANATOMIA_P bigint, NR_CPOE_NEW_ANATOMIA_P bigint ) AS $body$
DECLARE


qtde		bigint;

BEGIN

	select count(*)
	into STRICT qtde
	FROM W_CPOE_PRESCR_CITOP
	WHERE NR_SEQ_PROC_ANATOMIA = NR_CPOE_OLD_ANATOMIA_P;

	if (qtde > 0) then
		INSERT INTO CPOE_PRESCR_CITOPATOLOGICO(NR_SEQUENCIA,
		DT_ATUALIZACAO,
		 NM_USUARIO,
		 DT_ATUALIZACAO_NREC,
		 NM_USUARIO_NREC,
		 IE_EXAME_PREVENTIVO,
		 DT_ULTIMO_EXAME,
		 IE_USA_DIU,
		 IE_GRAVIDA,
		 IE_PILULA,
		 IE_HORMONIO,
		 IE_RADIOTERAPIA,
		 IE_ULTIMA_MENSTRUACAO,
		 DT_ULTIMA_MENSTRUACAO,
		 IE_SANGRAMENTO,
		 IE_SANGR_APOS_MENOP,
		 IE_INSPECAO_COLO,
		 IE_DST,
		 DT_PRIM_HORARIO,
		 NR_ATENDIMENTO,
		 CD_PERFIL_ATIVO,
		 HR_PRIM_HORARIO,
		 DT_LIBERACAO,
		 DT_SUSPENSAO,
		 NM_USUARIO_SUSP,
		 IE_DURACAO,
		 IE_PERIODO,
		 DT_PROX_GERACAO,
		 DT_INICIO,
		 DT_FIM,
		 IE_ADMINISTRACAO,
		 IE_EVENTO_UNICO,
		 NR_SEQ_CPOE_ANTERIOR,
		 DT_LIB_SUSPENSAO,
		 NR_SEQ_TRANSCRICAO,
		 DS_STACK,
		 CD_PESSOA_FISICA,
		 IE_RETROGRADO,
		 NM_USUARIO_LIB_ENF,
		 CD_FARMAC_LIB,
		 CD_FUNCAO_ORIGEM,
		 IE_BAIXADO_POR_ALTA,
		 IE_CPOE_FARM,
		 NR_CPOE_INTERF_FARM,
		 IE_MOTIVO_PRESCRICAO,
		 IE_ITEM_VALIDO,
		 IE_INTERVENCAO_FARM,
		 IE_ITEM_ALTA,
		 CD_SETOR_ATENDIMENTO,
		 NR_SEQ_PROC_ANATOMIA
		)
		SELECT
		 nextval('cpoe_prescr_citopatologico_seq'),
		 DT_ATUALIZACAO,
		 NM_USUARIO,
		 DT_ATUALIZACAO_NREC,
		 NM_USUARIO_NREC,
		 IE_EXAME_PREVENTIVO,
		 DT_ULTIMO_EXAME,
		 IE_USA_DIU,
		 IE_GRAVIDA,
		 IE_PILULA,
		 IE_HORMONIO,
		 IE_RADIOTERAPIA,
		 IE_ULTIMA_MENSTRUACAO,
		 DT_ULTIMA_MENSTRUACAO,
		 IE_SANGRAMENTO,
		 IE_SANGR_APOS_MENOP,
		 IE_INSPECAO_COLO,
		 IE_DST,
		 DT_PRIM_HORARIO,
		 NR_ATENDIMENTO,
		 CD_PERFIL_ATIVO,
		 HR_PRIM_HORARIO,
		 DT_LIBERACAO,
		 DT_SUSPENSAO,
		 NM_USUARIO_SUSP,
		 IE_DURACAO,
		 IE_PERIODO,
		 DT_PROX_GERACAO,
		 DT_INICIO,
		 DT_FIM,
		 IE_ADMINISTRACAO,
		 IE_EVENTO_UNICO,
		 NR_SEQ_CPOE_ANTERIOR,
		 DT_LIB_SUSPENSAO,
		 NR_SEQ_TRANSCRICAO,
		 DS_STACK,
		 CD_PESSOA_FISICA,
		 IE_RETROGRADO,
		 NM_USUARIO_LIB_ENF,
		 CD_FARMAC_LIB,
		 CD_FUNCAO_ORIGEM,
		 IE_BAIXADO_POR_ALTA,
		 IE_CPOE_FARM,
		 NR_CPOE_INTERF_FARM,
		 IE_MOTIVO_PRESCRICAO,
		 IE_ITEM_VALIDO,
		 IE_INTERVENCAO_FARM,
		 IE_ITEM_ALTA,
		 CD_SETOR_ATENDIMENTO,
		 NR_CPOE_NEW_ANATOMIA_P
		FROM W_CPOE_PRESCR_CITOP
		WHERE NR_SEQ_PROC_ANATOMIA = NR_CPOE_OLD_ANATOMIA_P;
	else
		INSERT INTO CPOE_PRESCR_CITOPATOLOGICO(NR_SEQUENCIA,
		DT_ATUALIZACAO,
		 NM_USUARIO,
		 DT_ATUALIZACAO_NREC,
		 NM_USUARIO_NREC,
		 IE_EXAME_PREVENTIVO,
		 DT_ULTIMO_EXAME,
		 IE_USA_DIU,
		 IE_GRAVIDA,
		 IE_PILULA,
		 IE_HORMONIO,
		 IE_RADIOTERAPIA,
		 IE_ULTIMA_MENSTRUACAO,
		 DT_ULTIMA_MENSTRUACAO,
		 IE_SANGRAMENTO,
		 IE_SANGR_APOS_MENOP,
		 IE_INSPECAO_COLO,
		 IE_DST,
		 DT_PRIM_HORARIO,
		 NR_ATENDIMENTO,
		 CD_PERFIL_ATIVO,
		 HR_PRIM_HORARIO,
		 DT_LIBERACAO,
		 DT_SUSPENSAO,
		 NM_USUARIO_SUSP,
		 IE_DURACAO,
		 IE_PERIODO,
		 DT_PROX_GERACAO,
		 DT_INICIO,
		 DT_FIM,
		 IE_ADMINISTRACAO,
		 IE_EVENTO_UNICO,
		 NR_SEQ_CPOE_ANTERIOR,
		 DT_LIB_SUSPENSAO,
		 NR_SEQ_TRANSCRICAO,
		 DS_STACK,
		 CD_PESSOA_FISICA,
		 IE_RETROGRADO,
		 NM_USUARIO_LIB_ENF,
		 CD_FARMAC_LIB,
		 CD_FUNCAO_ORIGEM,
		 IE_BAIXADO_POR_ALTA,
		 IE_CPOE_FARM,
		 NR_CPOE_INTERF_FARM,
		 IE_MOTIVO_PRESCRICAO,
		 IE_ITEM_VALIDO,
		 IE_INTERVENCAO_FARM,
		 IE_ITEM_ALTA,
		 CD_SETOR_ATENDIMENTO,
		 NR_SEQ_PROC_ANATOMIA
		)
		SELECT
		 nextval('cpoe_prescr_citopatologico_seq'),
		 DT_ATUALIZACAO,
		 NM_USUARIO,
		 DT_ATUALIZACAO_NREC,
		 NM_USUARIO_NREC,
		 IE_EXAME_PREVENTIVO,
		 DT_ULTIMO_EXAME,
		 IE_USA_DIU,
		 IE_GRAVIDA,
		 IE_PILULA,
		 IE_HORMONIO,
		 IE_RADIOTERAPIA,
		 IE_ULTIMA_MENSTRUACAO,
		 DT_ULTIMA_MENSTRUACAO,
		 IE_SANGRAMENTO,
		 IE_SANGR_APOS_MENOP,
		 IE_INSPECAO_COLO,
		 IE_DST,
		 DT_PRIM_HORARIO,
		 NR_ATENDIMENTO,
		 CD_PERFIL_ATIVO,
		 HR_PRIM_HORARIO,
		 DT_LIBERACAO,
		 DT_SUSPENSAO,
		 NM_USUARIO_SUSP,
		 IE_DURACAO,
		 IE_PERIODO,
		 DT_PROX_GERACAO,
		 DT_INICIO,
		 DT_FIM,
		 IE_ADMINISTRACAO,
		 IE_EVENTO_UNICO,
		 NR_SEQ_CPOE_ANTERIOR,
		 DT_LIB_SUSPENSAO,
		 NR_SEQ_TRANSCRICAO,
		 DS_STACK,
		 CD_PESSOA_FISICA,
		 IE_RETROGRADO,
		 NM_USUARIO_LIB_ENF,
		 CD_FARMAC_LIB,
		 CD_FUNCAO_ORIGEM,
		 IE_BAIXADO_POR_ALTA,
		 IE_CPOE_FARM,
		 NR_CPOE_INTERF_FARM,
		 IE_MOTIVO_PRESCRICAO,
		 IE_ITEM_VALIDO,
		 IE_INTERVENCAO_FARM,
		 IE_ITEM_ALTA,
		 CD_SETOR_ATENDIMENTO,
		 NR_CPOE_NEW_ANATOMIA_P
		FROM CPOE_PRESCR_CITOPATOLOGICO
		WHERE NR_SEQ_PROC_ANATOMIA = NR_CPOE_OLD_ANATOMIA_P;
	end if;

	DELETE FROM W_CPOE_PRESCR_CITOP
	WHERE nr_seq_proc_anatomia = NR_CPOE_OLD_ANATOMIA_P;

	DELETE FROM W_CPOE_PRESCR_PROC_PECA
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';

	DELETE FROM W_CPOE_PRESCR_HISTOPATOL
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';

	DELETE FROM W_CPOE_PRESCR_CITOP
	WHERE DT_ATUALIZACAO_NREC <= clock_timestamp() - interval '2 days';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_copy_w_prescr_citop ( NR_CPOE_OLD_ANATOMIA_P bigint, NR_CPOE_NEW_ANATOMIA_P bigint ) FROM PUBLIC;

