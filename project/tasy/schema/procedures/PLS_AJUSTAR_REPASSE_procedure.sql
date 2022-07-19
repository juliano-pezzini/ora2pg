-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_repasse () AS $body$
DECLARE


-- Ajuste para o projeto da RN 430
BEGIN

update 	pls_itens_contrato_benef
set 	ds_item = 'Compartilhamento de risco'
where 	nr_sequencia = 15;

update	pls_segurado_repasse
set	ie_tipo_compartilhamento = 1
where	coalesce(ie_tipo_compartilhamento::text, '') = '';

update	pls_segurado_repasse
set	ie_portal = 'S'
where	coalesce(ie_portal::text, '') = '';

commit;

CALL exec_sql_dinamico('Tasy', ' alter table pls_segurado_repasse modify (ie_tipo_compartilhamento number(2) not null) ');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_repasse () FROM PUBLIC;

