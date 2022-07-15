-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_pacote ( cd_setor_atendimento_p bigint, dt_entrada_unidade_p timestamp, nr_seq_interno_p bigint, dt_pacote_p timestamp, nr_seq_procedimento_p bigint) AS $body$
BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (dt_entrada_unidade_p IS NOT NULL AND dt_entrada_unidade_p::text <> '') and (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') and (dt_pacote_p IS NOT NULL AND dt_pacote_p::text <> '') and (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then
	begin
	update	procedimento_paciente
	set	cd_setor_atendimento	= cd_setor_atendimento_p,
		dt_entrada_unidade		= dt_entrada_unidade_p,
		nr_seq_atepacu		= nr_seq_interno_p,
		dt_procedimento		= dt_pacote_p,
		dt_conta			= dt_procedimento
	where	nr_sequencia		= nr_seq_procedimento_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_pacote ( cd_setor_atendimento_p bigint, dt_entrada_unidade_p timestamp, nr_seq_interno_p bigint, dt_pacote_p timestamp, nr_seq_procedimento_p bigint) FROM PUBLIC;

