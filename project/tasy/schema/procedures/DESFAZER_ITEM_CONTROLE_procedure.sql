-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_item_controle ( nr_cirurgia_p bigint, cd_material_p bigint, nr_seq_item_cme_p bigint, nm_usuario_p text ) AS $body$
BEGIN

if (nr_cirurgia_p > 0) and
	((cd_material_p > 0) or (nr_seq_item_cme_p > 0)) then
	update	cirurgia_item_controle
	set	ie_acao		= 5,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= (	SELECT	max(nr_sequencia)
					from	cirurgia_item_controle
					where	nr_cirurgia	=	nr_cirurgia_p
					and		((cd_material	=	cd_material_p) or (nr_seq_item_cme = nr_seq_item_cme_p))
					and		ie_acao <> 5);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_item_controle ( nr_cirurgia_p bigint, cd_material_p bigint, nr_seq_item_cme_p bigint, nm_usuario_p text ) FROM PUBLIC;
