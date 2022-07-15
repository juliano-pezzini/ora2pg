-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_altera_status_consulta ( nr_seq_status_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_executar_agenda_w	varchar(1);
nr_seq_agenda_w         agenda_consulta.nr_sequencia%type;

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_status_p IS NOT NULL AND nr_seq_status_p::text <> '') then
	update	oft_consulta
	set	nr_seq_status	= nr_seq_status_p,
		nm_usuario	= nm_usuario_p
	where	nr_sequencia 	= nr_sequencia_p;
	
	/* Incluido na trigger. Pois pode alterar pelo campo direito na tabela e nao somente pela opcao.
	insert	into	oft_status_consulta_hist(nr_sequencia,
						nr_seq_consulta,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_status,
						dt_status)
	values					(oft_status_consulta_hist_seq.nextval,
						nr_sequencia_p,
						sysdate,
						nm_usuario_p,
						sysdate,
						nm_usuario_p,
						nr_seq_status_p,
						sysdate);	
	*/
	
	select	max(ie_executar_agenda)
	into STRICT	ie_executar_agenda_w
	from	oft_status_consulta
	where 	nr_sequencia = nr_seq_status_p;
		
	if (ie_executar_agenda_w = 'S') then
		select	max(nr_sequencia)
		into STRICT 	nr_seq_agenda_w
		from	agenda_consulta
		where 	nr_seq_oftalmo = nr_sequencia_p;

		update	agenda_consulta
		set	ie_status_agenda		= 'AD',
			nm_usuario_status		= nm_usuario_p,
			dt_status			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_sequencia			= nr_seq_agenda_w;
	end if;
	
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_altera_status_consulta ( nr_seq_status_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

