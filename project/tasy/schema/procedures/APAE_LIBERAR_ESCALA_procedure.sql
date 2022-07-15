-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apae_liberar_escala ( nr_sequencia_p bigint, ie_opcao_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	if (ie_opcao_p = 6) then	
		update	escala_risco_pulmonar
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 7) then		
		update	escala_risco_insuf_renal
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 8)then
		update	escala_child_pugh
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 9)then
		update	escala_risco_delirium
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 3)then
		update	pac_clereance_creatinina
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 2)then
		update	ESCALA_POSSUM
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 1)then
		update	ESCALA_LEE
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 10) then
		update	ESCALA_EIF
		set		dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
	end if;
	
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apae_liberar_escala ( nr_sequencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;

