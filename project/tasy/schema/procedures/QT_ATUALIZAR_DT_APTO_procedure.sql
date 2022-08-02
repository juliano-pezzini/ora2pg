-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_atualizar_dt_apto ( nr_seq_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(nr_seq_atendimento_p,0) > 0) then

	update 	paciente_atendimento
	set 	dt_apto = clock_timestamp()
	where 	nr_seq_atendimento = nr_seq_atendimento_p;
else
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(216085);--Favor selecionar um paciente!
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_atualizar_dt_apto ( nr_seq_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

