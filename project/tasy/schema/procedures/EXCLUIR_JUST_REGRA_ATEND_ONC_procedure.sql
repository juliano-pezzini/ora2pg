-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_just_regra_atend_onc ( NR_SEQ_ATENDIMENTO_P bigint, NR_SEQ_MATERIAL_P bigint, NR_SEQ_REGRA_p bigint) AS $body$
DECLARE


qtd_regra_atend_w     bigint;


BEGIN

select COUNT(obter_just_regra_atend_onc(NR_SEQ_ATENDIMENTO_P, NR_SEQ_MATERIAL_P, NR_SEQ_REGRA_p))
INTO STRICT  qtd_regra_atend_w
;

IF (qtd_regra_atend_w > 0)THEN
	DELETE FROM paciente_atend_erro_just
	WHERE nr_seq_atendimento = NR_SEQ_ATENDIMENTO_P
	and nr_seq_material = NR_SEQ_MATERIAL_P
	and nr_seq_regra = NR_SEQ_REGRA_p;
END IF;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_just_regra_atend_onc ( NR_SEQ_ATENDIMENTO_P bigint, NR_SEQ_MATERIAL_P bigint, NR_SEQ_REGRA_p bigint) FROM PUBLIC;

