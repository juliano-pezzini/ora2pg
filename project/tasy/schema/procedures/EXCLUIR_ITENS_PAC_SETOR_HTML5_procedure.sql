-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_itens_pac_setor_html5 (nr_seq_paciente_p bigint) AS $body$
BEGIN

delete	
from	paciente_protocolo_medic
where	nr_seq_paciente = nr_seq_paciente_p;

delete
from	paciente_protocolo_soluc
where	nr_seq_paciente = nr_seq_paciente_p;

delete
from	paciente_protocolo_proc
where	nr_seq_paciente = nr_seq_paciente_p;

delete
from	paciente_protocolo_rec
where	nr_seq_paciente = nr_seq_paciente_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_itens_pac_setor_html5 (nr_seq_paciente_p bigint) FROM PUBLIC;

