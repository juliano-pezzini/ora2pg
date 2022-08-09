-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_proc_resumo_alta ( NR_SEQ_ATEND_SUMARIO_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_proc_interno_p bigint, nm_usuario_p text) AS $body$
BEGIN


insert into ATEND_SUMARIO_ALTA_ITEM(
			 NR_SEQUENCIA,
			 CD_DOENCA,
			 DT_ATUALIZACAO,
			 NM_USUARIO,
			 DT_ATUALIZACAO_NREC,
			 NM_USUARIO_NREC,
			 NR_SEQ_EXAME,
			 IE_TIPO_ITEM,
			 CD_RECOMENDACAO,
			 CD_PROCEDIMENTO,
			 IE_ORIGEM_PROCED,
			 nr_proc_interno,
			 NR_SEQ_ATEND_SUMARIO)
		values (
			 nextval('atend_sumario_alta_item_seq'),
			 null,
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 null,
			 'P',
			 null,
			 cd_procedimento_p,
			 ie_origem_proced_p,
			 nr_proc_interno_p,
			 NR_SEQ_ATEND_SUMARIO_p);



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_proc_resumo_alta ( NR_SEQ_ATEND_SUMARIO_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_proc_interno_p bigint, nm_usuario_p text) FROM PUBLIC;
