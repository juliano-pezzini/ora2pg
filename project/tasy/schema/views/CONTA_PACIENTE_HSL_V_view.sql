-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_hsl_v (ie_proc_mat, vl_item, nr_interno_conta, cd_motivo_exc_conta, nr_sequencia, nr_seq_proc_pacote, nr_seq_protocolo, ie_emite_conta, tp_item) AS SELECT 1 IE_PROC_MAT,
       A.VL_PROCEDIMENTO      VL_ITEM,
       A.NR_INTERNO_CONTA,
       A.CD_MOTIVO_EXC_CONTA,
	A.NR_SEQUENCIA,
	A.NR_SEQ_PROC_PACOTE,
	coalesce(M.NR_SEQ_PROTOCOLO,0) NR_SEQ_PROTOCOLO,
	A.IE_EMITE_CONTA,
	 C.IE_CLASSIFICACAO     TP_ITEM
FROM conta_paciente m, procedimento c, procedimento_paciente a, (a
LEFT OUTER JOIN proc_paciente_valor g ON (A.NR_SEQUENCIA = G.NR_SEQ_PROCEDIMENTO AND 1 = G.IE_TIPO_VALOR)
WHERE (A.NR_INTERNO_CONTA	  = M.NR_INTERNO_CONTA) and (A.CD_PROCEDIMENTO 	=  C.CD_PROCEDIMENTO) AND (A.IE_ORIGEM_PROCED	= C.IE_ORIGEM_PROCED)
UNION

SELECT 2 IE_PROC_MAT,
       X.VL_MATERIAL          VL_ITEM,
       X.NR_INTERNO_CONTA,
	X.CD_MOTIVO_EXC_CONTA,
       X.NR_SEQUENCIA,
       X.NR_SEQ_PROC_PACOTE,
	coalesce(M.NR_SEQ_PROTOCOLO,0) NR_SEQ_PROTOCOLO,
	X.IE_EMITE_CONTA,
	CASE WHEN W.IE_TIPO_MATERIAL=1 THEN '1' WHEN W.IE_TIPO_MATERIAL=2 THEN '2' WHEN W.IE_TIPO_MATERIAL=3 THEN '2'  ELSE '5' END   TP_ITEM
FROM   MATERIAL W,
	MATERIAL_ATEND_PACIENTE X,
 	 CONTA_PACIENTE M
WHERE (X.NR_INTERNO_CONTA	  = M.NR_INTERNO_CONTA)
AND (X.CD_MATERIAL = W.CD_MATERIAL);

