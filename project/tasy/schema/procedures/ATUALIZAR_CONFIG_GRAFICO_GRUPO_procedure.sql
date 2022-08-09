-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_config_grafico_grupo ( nr_sequencia_p bigint, nr_seq_apres_p bigint, ie_grafico_p text) AS $body$
BEGIN

update	pepo_grupo_item_grafico
set	nr_seq_apresent		= nr_seq_apres_p,
	ie_grupo_selecionado	= ie_grafico_p
where	nr_sequencia		= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_config_grafico_grupo ( nr_sequencia_p bigint, nr_seq_apres_p bigint, ie_grafico_p text) FROM PUBLIC;
