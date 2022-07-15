-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tiss_dem_conta_proc (NR_SEQUENCIA_P bigint, NM_USUARIO_P text, NR_SEQ_CONTA_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P text, IE_TIPO_TABELA_P text, QT_PROCEDIMENTO_P bigint, VL_PROCESSADO_P bigint, VL_LIBERADO_P bigint, DS_ITEM_P text, CD_PROCEDIMENTO_XML_P text, NR_SEQUENCIA_ITEM_P bigint) AS $body$
BEGIN

insert	into TISS_DEM_CONTA_PROC(NR_SEQUENCIA,
	DT_ATUALIZACAO,
	NM_USUARIO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	NR_SEQ_CONTA,
	CD_PROCEDIMENTO,
	IE_ORIGEM_PROCED,
	IE_TIPO_TABELA,
	QT_PROCEDIMENTO,
	VL_PROCESSADO,
	VL_LIBERADO,
	DS_ITEM,
	CD_PROCEDIMENTO_XML,
	NR_SEQUENCIA_ITEM)
values (NR_SEQUENCIA_p,
	clock_timestamp(),
	NM_USUARIO_p,
	clock_timestamp(),
	NM_USUARIO_p,
	NR_SEQ_CONTA_p,
	CD_PROCEDIMENTO_p,
	IE_ORIGEM_PROCED_p,
	IE_TIPO_TABELA_p,
	QT_PROCEDIMENTO_p,
	VL_PROCESSADO_p,
	VL_LIBERADO_p,
	DS_ITEM_p,
	CD_PROCEDIMENTO_XML_P,
	NR_SEQUENCIA_ITEM_P);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tiss_dem_conta_proc (NR_SEQUENCIA_P bigint, NM_USUARIO_P text, NR_SEQ_CONTA_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P text, IE_TIPO_TABELA_P text, QT_PROCEDIMENTO_P bigint, VL_PROCESSADO_P bigint, VL_LIBERADO_P bigint, DS_ITEM_P text, CD_PROCEDIMENTO_XML_P text, NR_SEQUENCIA_ITEM_P bigint) FROM PUBLIC;

