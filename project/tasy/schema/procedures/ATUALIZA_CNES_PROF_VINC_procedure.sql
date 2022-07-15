-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_cnes_prof_vinc ( CD_CBO_P text, NR_SEQ_VINCULO_P bigint, QT_HORA_AMBULATORIAL_P text, QT_HORA_HOSPITALAR_P text, QT_HORA_OUTROS_P text, NR_REGISTRO_P text, SG_UF_EMISSOR_P text, NR_SEQ_CNES_PROF_VINC_P bigint) AS $body$
BEGIN

update  cnes_profissional_vinculo
set	CD_CBO			= CD_CBO_P,
	NR_SEQ_VINCULO 		= NR_SEQ_VINCULO_P,
	QT_HORA_AMBULATORIAL	= QT_HORA_AMBULATORIAL_P,
	QT_HORA_HOSPITALAR	= QT_HORA_HOSPITALAR_P,
	QT_HORA_OUTROS		= QT_HORA_OUTROS_P,
	NR_REGISTRO		= NR_REGISTRO_P,
	SG_UF_EMISSOR		= SG_UF_EMISSOR_P
where	nr_sequencia = nr_seq_cnes_prof_vinc_p;

commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_cnes_prof_vinc ( CD_CBO_P text, NR_SEQ_VINCULO_P bigint, QT_HORA_AMBULATORIAL_P text, QT_HORA_HOSPITALAR_P text, QT_HORA_OUTROS_P text, NR_REGISTRO_P text, SG_UF_EMISSOR_P text, NR_SEQ_CNES_PROF_VINC_P bigint) FROM PUBLIC;

