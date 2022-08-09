-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_atend_paciente_espera ( nr_atendimento_p bigint, nr_seq_paciente_espera_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* **************** IE_OPCAO_P ************/

/*	V - Vincular atendimento		*/

/*	D - Desvincular atendimento	*/

/* *****************************************/

BEGIN

if (ie_opcao_p	= 'V') then
	update	paciente_espera
	set	nr_atendimento	= nr_atendimento_p
	where	nr_sequencia	= nr_seq_paciente_espera_p;

 elsif (ie_opcao_p	= 'D') then
	update	paciente_espera
	set	nr_atendimento	 = NULL
	where	nr_sequencia	= nr_seq_paciente_espera_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_atend_paciente_espera ( nr_atendimento_p bigint, nr_seq_paciente_espera_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
