-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cid_rotina_antib_prescr (nr_prescricao_p bigint, nr_seq_item_p bigint, nr_seq_cid_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cid_rotina_w	varchar(10);
nr_seq_antib_w	bigint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (nr_seq_cid_p IS NOT NULL AND nr_seq_cid_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* obter cid rotina */

	select	cd_doenca
	into STRICT	cd_cid_rotina_w
	from	cid_rotina
	where	nr_sequencia = nr_seq_cid_p;

	/* obter sequencia */

	select	nextval('prescr_material_cid_seq')
	into STRICT	nr_seq_antib_w
	;

	/* gerar cid antibiotico */

	insert into prescr_material_cid(
						nr_sequencia,
						cd_doenca_cid,
						nr_prescricao,
						nr_sequencia_medic,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec
						)
	values (
						nr_seq_antib_w,
						cd_cid_rotina_w,
						nr_prescricao_p,
						nr_seq_item_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p
						);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cid_rotina_antib_prescr (nr_prescricao_p bigint, nr_seq_item_p bigint, nr_seq_cid_p bigint, nm_usuario_p text) FROM PUBLIC;
