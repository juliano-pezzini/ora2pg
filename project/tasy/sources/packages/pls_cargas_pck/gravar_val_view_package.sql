-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Gravar se a view e valida



CREATE OR REPLACE PROCEDURE pls_cargas_pck.gravar_val_view ( ie_valido_p text) AS $body$
BEGIN
-- Dizer se o select da view e valido

update	pls_cg_view_ref
set	ie_valido	= coalesce(ie_valido_p,'N')
where	nr_seq_regra	= nr_seq_regra_w;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cargas_pck.gravar_val_view ( ie_valido_p text) FROM PUBLIC;