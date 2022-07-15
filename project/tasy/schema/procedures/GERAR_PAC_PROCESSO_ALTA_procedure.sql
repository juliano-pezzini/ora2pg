-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pac_processo_alta ( nm_usuario_p text, nr_atendimento_p bigint, ie_controla_alta_p text, nr_seq_pep_pac_ci_p bigint ) AS $body$
DECLARE

qt_processo_reg	bigint := 0;

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select 	count(*)
	into STRICT	qt_processo_reg
	from	atend_pac_proc_alta
	where 	nr_atendimento = nr_atendimento_p;

	if (qt_processo_reg > 0) then
		CALL atualizar_pac_processo_alta(nm_usuario_p, nr_atendimento_p, ie_controla_alta_p, nr_seq_pep_pac_ci_p);
	else
		insert into atend_pac_proc_alta(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_motivo_cancel,
			nr_atendimento,
			ie_controla_alta,
			ds_justificativa,
			dt_cancelamento)
		values (
			nextval('atend_pac_proc_alta_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			null,
			nr_atendimento_p,
			ie_controla_alta_p,
			null,
			null);

		commit;
	end if;
end if;

if (nr_seq_pep_pac_ci_p IS NOT NULL AND nr_seq_pep_pac_ci_p::text <> '') then
	update 	pep_pac_ci
	set		ie_controla_alta = ie_controla_alta_p
	where	nr_sequencia = nr_seq_pep_pac_ci_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pac_processo_alta ( nm_usuario_p text, nr_atendimento_p bigint, ie_controla_alta_p text, nr_seq_pep_pac_ci_p bigint ) FROM PUBLIC;

