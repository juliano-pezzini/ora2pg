-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_qt_item_requisicao ( nr_seq_item_p bigint, qt_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(qt_item_p,0) > 0) and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then

	if (ie_tipo_item_p = 'P') then
		update	pls_requisicao_proc
		set	qt_solicitado	= qt_item_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_item_p;
	elsif (ie_tipo_item_p = 'M') then
		update	pls_requisicao_mat
		set	qt_solicitado	= qt_item_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_item_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_qt_item_requisicao ( nr_seq_item_p bigint, qt_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) FROM PUBLIC;

