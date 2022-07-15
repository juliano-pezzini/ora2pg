-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_nr_seq_exame_agecons (nr_seq_exame_p bigint, cd_exame_p INOUT text) AS $body$
DECLARE

cd_exame_w varchar(255):=null;


BEGIN

	SELECT MAX(cd_exame) cd_exame
	into STRICT	cd_exame_w
	 FROM (
	 SELECT A.CD_EXAME
	 FROM   PROCEDIMENTO B,
	        EXAME_LABORATORIO A
	 WHERE  A.CD_PROCEDIMENTO  = B.CD_PROCEDIMENTO
	 AND    A.IE_ORIGEM_PROCED = B.IE_ORIGEM_PROCED
	 AND    A.IE_SOLICITACAO   = 'S'
	 AND    a.nr_seq_exame 	 = nr_seq_exame_p
	
UNION

	 SELECT MAX(A.CD_EXAME)
	 FROM   EXAME_LABORATORIO A,
	        PROCEDIMENTO B,
	        EXAME_LAB_PSEUDO C
	 WHERE  A.NR_SEQ_EXAME     = C.NR_SEQ_EXAME
	 AND    A.CD_PROCEDIMENTO  = B.CD_PROCEDIMENTO
	 AND    A.IE_ORIGEM_PROCED = B.IE_ORIGEM_PROCED
	 AND    A.IE_SOLICITACAO   = 'S'
	 AND    a.nr_seq_exame 	 = nr_seq_exame_p) alias2;

cd_exame_p := cd_exame_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_nr_seq_exame_agecons (nr_seq_exame_p bigint, cd_exame_p INOUT text) FROM PUBLIC;

