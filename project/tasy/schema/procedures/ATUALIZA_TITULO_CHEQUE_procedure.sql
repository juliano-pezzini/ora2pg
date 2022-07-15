-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_titulo_cheque ( nr_titulo_p bigint, nr_seq_cheque_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
qt_titulo_w	bigint;					
					

BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	
	select	count(*)
	into STRICT	qt_titulo_w
	from	titulo_receber a
	where	a.nr_titulo = nr_titulo_p;
	
	if (qt_titulo_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1098371);
	end if;
	
	update 	cheque_cr
	set 	nr_titulo = nr_titulo_p, 
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where 	nr_seq_cheque = nr_seq_cheque_p;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_titulo_cheque ( nr_titulo_p bigint, nr_seq_cheque_p bigint, nm_usuario_p text) FROM PUBLIC;

