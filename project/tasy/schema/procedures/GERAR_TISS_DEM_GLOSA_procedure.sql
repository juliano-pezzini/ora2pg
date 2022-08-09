-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tiss_dem_glosa (NR_SEQUENCIA_p bigint, NM_USUARIO_p text, NR_SEQ_CONTA_PROC_p bigint, CD_GLOSA_p text, DS_GLOSA_p text, VL_GLOSA_p bigint, NR_SEQ_CONTA_p bigint) AS $body$
BEGIN

insert	into TISS_DEM_GLOSA(NR_SEQUENCIA,
	DT_ATUALIZACAO,
	NM_USUARIO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	NR_SEQ_CONTA_PROC,
	CD_GLOSA,
	DS_GLOSA,
	VL_GLOSA,
	NR_SEQ_CONTA)
values (NR_SEQUENCIA_p,
	clock_timestamp(),
	NM_USUARIO_p,
	clock_timestamp(),
	NM_USUARIO_p,
	NR_SEQ_CONTA_PROC_p,
	CD_GLOSA_p,
	DS_GLOSA_p,
	VL_GLOSA_p,
	NR_SEQ_CONTA_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tiss_dem_glosa (NR_SEQUENCIA_p bigint, NM_USUARIO_p text, NR_SEQ_CONTA_PROC_p bigint, CD_GLOSA_p text, DS_GLOSA_p text, VL_GLOSA_p bigint, NR_SEQ_CONTA_p bigint) FROM PUBLIC;
