-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pb_duplica_lista_espera (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p > 0 AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	INSERT INTO RP_LISTA_ESPERA_MODELO(
	NR_SEQUENCIA,
	DT_ATUALIZACAO,
	NM_USUARIO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	NR_SEQ_MODELO,
	CD_PESSOA_FISICA,
	DT_INCLUSAO_LISTA,
	DT_LIBERACAO_MEDICO,
	IE_STATUS,
	NR_SEQ_TIPO_DEFICIENCIA,
	CD_ESTABELECIMENTO,
	DS_OBSERVACAO,
	DT_PEDIDO,
	CD_MEDICO_RESP,
	CD_TIPO_AGENDA,
	CD_AGENDA,
	CD_PROCEDIMENTO,
	IE_ORIGEM_PROCED,
	NR_SEQ_PROC_INTERNO,
	DT_PREV_INICIO,
	DT_PREV_FIM,
	CD_MEDICO_EXEC,
	CD_ESPECIALIDADE,
	NR_MINUTO_MANHA,
	NR_MINUTO_TARDE,
	NR_MINUTO_LIVRE,
	NR_SESSOES,
	IE_FREQUENCIA,
	CD_CONVENIO,
	CD_PROC_SERV,
	IE_ORIGEM_PROCED_SERV,
	NR_SEQ_PROC_INTERNO_SERV,
	IE_EXCLUSIVO,
	NR_SEQ_CLASSIF
	)
	(SELECT
	nextval('rp_lista_espera_modelo_seq'),
	clock_timestamp(),
	NM_USUARIO_P,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	NR_SEQ_MODELO,
	CD_PESSOA_FISICA,
	DT_INCLUSAO_LISTA,
	DT_LIBERACAO_MEDICO,
	IE_STATUS,
	NR_SEQ_TIPO_DEFICIENCIA,
	CD_ESTABELECIMENTO,
	DS_OBSERVACAO,
	DT_PEDIDO,
	CD_MEDICO_RESP,
	CD_TIPO_AGENDA,
	CD_AGENDA,
	CD_PROCEDIMENTO,
	IE_ORIGEM_PROCED,
	NR_SEQ_PROC_INTERNO,
	DT_PREV_INICIO,
	DT_PREV_FIM,
	CD_MEDICO_EXEC,
	CD_ESPECIALIDADE,
	NR_MINUTO_MANHA,
	NR_MINUTO_TARDE,
	NR_MINUTO_LIVRE,
	NR_SESSOES,
	IE_FREQUENCIA,
	CD_CONVENIO,
	CD_PROC_SERV,
	IE_ORIGEM_PROCED_SERV,
	NR_SEQ_PROC_INTERNO_SERV,
	IE_EXCLUSIVO,
	NR_SEQ_CLASSIF
	from RP_LISTA_ESPERA_MODELO
	where 1 = 1
	and nr_sequencia = nr_sequencia_p
	);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pb_duplica_lista_espera (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

