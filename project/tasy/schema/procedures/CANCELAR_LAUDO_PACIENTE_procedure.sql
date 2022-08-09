-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_laudo_paciente ( nr_seq_laudo_p bigint, ie_opcao_p text, nm_usuario_p text, nr_seq_motivo_canc_p text) AS $body$
DECLARE


ie_opcao_w  varchar(10);


BEGIN


if (nr_seq_laudo_p IS NOT NULL AND nr_seq_laudo_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	select CASE WHEN ie_opcao_p='C' THEN 6  ELSE 8 END
	into STRICT   ie_opcao_w
	;

	CALL gravar_log_status_laudo(nr_seq_laudo_p,ie_opcao_w,nm_usuario_p);

	if (ie_opcao_p = 'C') then
		update 	laudo_paciente
		set 	dt_cancelamento = clock_timestamp(),
			nm_usuario_cancel = nm_usuario_p,
			nr_seq_motivo_canc = nr_seq_motivo_canc_p
		where nr_sequencia  = nr_seq_laudo_p;
	elsif (ie_opcao_p = 'D') then
		update 	laudo_paciente
		set 	dt_cancelamento  = NULL,
			nm_usuario_cancel  = NULL,
			nr_seq_motivo_canc  = NULL
		where nr_sequencia  = nr_seq_laudo_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_laudo_paciente ( nr_seq_laudo_p bigint, ie_opcao_p text, nm_usuario_p text, nr_seq_motivo_canc_p text) FROM PUBLIC;
