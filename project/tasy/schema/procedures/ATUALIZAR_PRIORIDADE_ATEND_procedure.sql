-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_prioridade_atend (NR_ATENDIMENTO_P bigint, NR_SEQ_TRIAGEM_PRIORIDADE_P bigint) AS $body$
DECLARE


qt_reg_triagem_w	bigint;	
nr_sequencia_w		triagem_pronto_atend.nr_sequencia%type;	
nr_seq_triagem_w	atendimento_paciente.nr_seq_triagem%type;
					

BEGIN

select	max(nr_seq_triagem)
into STRICT	nr_seq_triagem_w
from 	regra_triagem_classif
where 	nr_seq_triagem_prioridade = nr_seq_triagem_prioridade_p;

UPDATE ATENDIMENTO_PACIENTE
SET NR_SEQ_TRIAGEM_PRIORIDADE = NR_SEQ_TRIAGEM_PRIORIDADE_P
WHERE NR_ATENDIMENTO = NR_ATENDIMENTO_P;

IF (NR_SEQ_TRIAGEM_W IS NOT NULL AND NR_SEQ_TRIAGEM_W::text <> '') THEN
	UPDATE	ATENDIMENTO_PACIENTE
	SET 	NR_SEQ_TRIAGEM = NR_SEQ_TRIAGEM_W
	WHERE 	NR_ATENDIMENTO = NR_ATENDIMENTO_P;
END IF;

select 	count(*)
into STRICT	qt_reg_triagem_w
from	triagem_pronto_atend
where	nr_atendimento = nr_atendimento_p;

if (qt_reg_triagem_w > 0) then

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	triagem_pronto_atend
	where	nr_atendimento = nr_atendimento_p;

	update	triagem_pronto_atend
	set	NR_SEQ_TRIAGEM_PRIORIDADE = NR_SEQ_TRIAGEM_PRIORIDADE_P
	where	nr_sequencia = nr_sequencia_w;
	
end if;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_prioridade_atend (NR_ATENDIMENTO_P bigint, NR_SEQ_TRIAGEM_PRIORIDADE_P bigint) FROM PUBLIC;

