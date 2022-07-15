-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_medic_mat_associados (cd_protocolo_p bigint, nr_seq_protocolo_p bigint, nr_seq_material_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN
select	nextval('w_exc_protocolo_seq')
into STRICT	nr_sequencia_w
;

if (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '') and (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	insert into w_exc_protocolo(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_protocolo,
		nr_seq_protocolo,
		nr_seq_material)
	values (nr_sequencia_w,
	        clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_protocolo_p,
		nr_seq_protocolo_p,
		nr_seq_material_p
		);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_medic_mat_associados (cd_protocolo_p bigint, nr_seq_protocolo_p bigint, nr_seq_material_p bigint, nm_usuario_p text ) FROM PUBLIC;

