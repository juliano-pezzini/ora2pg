-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ponto_amb (NR_SEQUENCIA_P bigint, NM_USUARIO_P text, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, VL_PTO_PROCEDIMENTO_P bigint, VL_PTO_CUSTO_OPERAC_P bigint, VL_PTO_ANESTESISTA_P bigint, VL_PTO_MEDICO_P bigint, VL_PTO_AUXILIARES_P bigint, VL_PTO_MATERIAIS_P bigint) AS $body$
DECLARE


DT_ATUALIZACAO_W        timestamp 		:= clock_timestamp();
NR_SEQ_PROC_W		integer	:=0;


BEGIN

begin
delete	from proc_paciente_valor
where 	nr_seq_procedimento	= nr_sequencia_p
and 		ie_tipo_valor		= 2;
exception
     when others then
		nr_seq_proc_w	:= 0;
end;

select 	coalesce(max(nr_sequencia),0) + 1
into STRICT 		nr_seq_proc_w
from 		proc_paciente_valor
where 	nr_seq_procedimento 	= nr_sequencia_p;

insert 	into 	proc_paciente_valor(
			NR_SEQ_PROCEDIMENTO	,
			NR_SEQUENCIA           ,
			IE_TIPO_VALOR          ,
			DT_ATUALIZACAO         ,
			NM_USUARIO             ,
			VL_PROCEDIMENTO        ,
			VL_MEDICO              ,
			VL_ANESTESISTA         ,
			VL_MATERIAIS           ,
			VL_AUXILIARES          ,
			VL_CUSTO_OPERACIONAL   ,
			CD_CONVENIO			,
			CD_CATEGORIA)
		values (
			nr_sequencia_p,
			nr_seq_proc_w,
			2,
			dt_atualizacao_w,
			nm_usuario_p,
			vl_pto_procedimento_p,
			vl_pto_medico_p,
			vl_pto_anestesista_p,
			vl_pto_materiais_p,
			vl_pto_auxiliares_p,
			vl_pto_custo_operac_p,
			cd_convenio_p,
			cd_categoria_p);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ponto_amb (NR_SEQUENCIA_P bigint, NM_USUARIO_P text, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, VL_PTO_PROCEDIMENTO_P bigint, VL_PTO_CUSTO_OPERAC_P bigint, VL_PTO_ANESTESISTA_P bigint, VL_PTO_MEDICO_P bigint, VL_PTO_AUXILIARES_P bigint, VL_PTO_MATERIAIS_P bigint) FROM PUBLIC;
