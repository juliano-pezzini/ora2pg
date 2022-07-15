-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_pac_hist_leitura ( nr_seq_historico_p bigint, nm_usuario_p text) AS $body$
DECLARE

ie_insere_w	varchar(1);


BEGIN

begin
select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
into STRICT	ie_insere_w
from	agenda_pac_hist_leitura
where	nr_seq_historico	= nr_seq_historico_p
and	nm_usuario_leitura	= nm_usuario_p;

if (nr_seq_historico_p IS NOT NULL AND nr_seq_historico_p::text <> '') and (ie_insere_w = 'S') then
	insert	into agenda_pac_hist_leitura(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_historico,
		nm_usuario_leitura,
		dt_leitura)
		SELECT nextval('agenda_pac_hist_leitura_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_historico_p,
		nm_usuario_p,
		clock_timestamp();
	commit;
end if;
exception
	when others then
	ie_insere_w := 'N';
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_pac_hist_leitura ( nr_seq_historico_p bigint, nm_usuario_p text) FROM PUBLIC;

