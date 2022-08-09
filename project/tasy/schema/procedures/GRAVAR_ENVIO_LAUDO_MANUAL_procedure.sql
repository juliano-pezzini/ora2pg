-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_envio_laudo_manual (nr_seq_laudo_p bigint, nm_usuario_p text, ie_opcao_p bigint, ie_retorno_p INOUT text) AS $body$
DECLARE


nr_sequencia_w	bigint;
qt_existente_w	bigint;


BEGIN

/*
ie_opcao_p:
1 - Marcar como envio manual
2 - Desfazer marcação
*/
if (ie_opcao_p = 1) then

	SELECT	nextval('laudo_paciente_envio_seq')
	INTO STRICT	nr_sequencia_w
	;

	INSERT INTO laudo_paciente_envio(
		nr_sequencia,
		nr_seq_laudo,
		dt_atualizacao,
		nm_usuario,
		ie_medico_paciente)
	VALUES (nr_sequencia_w,
		nr_seq_laudo_p,
		clock_timestamp(),
		nm_usuario_p,
		SUBSTR('S',1,1));

        ie_retorno_p := 'M';

end if;

if (ie_opcao_p = 2) then

	select 	count(*)
	into STRICT	qt_existente_w
	from	laudo_paciente_envio
	where	nr_seq_laudo = nr_seq_laudo_p
	and		ie_medico_paciente = 'S';

	if (qt_existente_w > 0) then

		update	laudo_paciente_envio
		set		ie_medico_paciente = 'N'
		where	nr_seq_laudo = nr_seq_laudo_p
		and		ie_medico_paciente = 'S';

		ie_retorno_p := 'D';

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_envio_laudo_manual (nr_seq_laudo_p bigint, nm_usuario_p text, ie_opcao_p bigint, ie_retorno_p INOUT text) FROM PUBLIC;
