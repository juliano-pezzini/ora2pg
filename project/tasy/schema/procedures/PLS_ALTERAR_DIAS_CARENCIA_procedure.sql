-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_dias_carencia ( nr_seq_grupo_carencia_p bigint, nr_seq_w_carencia_p bigint, qt_dias_p bigint, ie_carencia_grupo_p text) AS $body$
BEGIN

if (ie_carencia_grupo_p	= 'G') then
	if (nr_seq_grupo_carencia_p IS NOT NULL AND nr_seq_grupo_carencia_p::text <> '') then
		update	pls_grupo_carencia
		set	qt_dias_manutencao	= qt_dias_p
		where	nr_sequencia		= nr_seq_grupo_carencia_p;


		update	w_pls_carencia
		set	qt_dias_carencia	= qt_dias_p
		where	nr_seq_grupo		= nr_seq_grupo_carencia_p;
	else
		update	w_pls_carencia
		set	qt_dias_carencia	= qt_dias_p
		where	coalesce(nr_seq_grupo::text, '') = '';
	end if;
elsif (ie_carencia_grupo_p	= 'C') then
	update	w_pls_carencia
	set	qt_dias_carencia	= qt_dias_p
	where	nr_sequencia		= nr_seq_w_carencia_p;
	/*and	ie_origem_carencia	<> 'P';	Lepinski - OS 310736 */

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_dias_carencia ( nr_seq_grupo_carencia_p bigint, nr_seq_w_carencia_p bigint, qt_dias_p bigint, ie_carencia_grupo_p text) FROM PUBLIC;
