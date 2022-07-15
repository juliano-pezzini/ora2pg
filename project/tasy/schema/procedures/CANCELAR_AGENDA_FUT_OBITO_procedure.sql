-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_agenda_fut_obito ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, cd_motivo_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_agenda_w	agenda_consulta.nr_sequencia%type;
qt_itens_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	agenda_consulta
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 365
	and	ie_status_agenda not in ('C','E')
	and	qt_itens_w > 0;


BEGIN

select	count(*)
into STRICT	qt_itens_w
from	agenda_consulta
where	dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 365
and	nr_sequencia <> nr_sequencia_p
and	cd_pessoa_fisica = cd_pessoa_fisica_p
and	ie_status_agenda not in ('C','E');


open C01;
loop
fetch C01 into	
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	update	agenda_consulta
	set	ie_status_agenda	= 'C',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		cd_motivo_cancelamento	= cd_motivo_p,
		ds_observacao	= ds_observacao_p
	where	nr_sequencia	= nr_seq_agenda_w;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_agenda_fut_obito ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, cd_motivo_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

