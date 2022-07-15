-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_atualiza_dt_mentor (nr_seq_pend_pac_acao_dest_p bigint) AS $body$
DECLARE


ie_profissional_medico_w varchar(1);


BEGIN

select coalesce(ie_profissional_medico,'N')
into STRICT ie_profissional_medico_w
from gqa_pend_pac_acao_dest
where nr_sequencia = nr_seq_pend_pac_acao_dest_p;

if (coalesce(nr_seq_pend_pac_acao_dest_p, 0) > 0 and ie_profissional_medico_w <> 'S') then

    update gqa_pend_pac_acao_dest
    set    dt_ciencia	= clock_timestamp(),
           dt_encerramento = dt_justificativa 
    where  nr_sequencia     = nr_seq_pend_pac_acao_dest_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_atualiza_dt_mentor (nr_seq_pend_pac_acao_dest_p bigint) FROM PUBLIC;

