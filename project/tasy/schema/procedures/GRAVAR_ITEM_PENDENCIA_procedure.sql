-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_item_pendencia (nr_seq_item_p bigint, nr_seq_pendencia_p bigint, ie_proc_mat_p text, nm_usuario_p text) AS $body$
DECLARE


qt_item_w		double precision;
vl_item_w		double precision;
cd_item_w		bigint;
dt_item_w		timestamp;
ie_origem_proced_w	integer;
nr_seq_proc_interno_w	bigint;



BEGIN

nr_seq_proc_interno_w:= null;

if (ie_proc_mat_p = 'M') then
	select	cd_material,
		qt_material,
		vl_material,
		dt_atendimento
	into STRICT	cd_item_w,
		qt_item_w,
		vl_item_w,
		dt_item_w
	from 	material_atend_paciente
	where 	nr_sequencia = nr_seq_item_p;

end if;


if (ie_proc_mat_p = 'P') then
	select	cd_procedimento,
		qt_procedimento,
		vl_procedimento,
		ie_origem_proced,
		dt_procedimento,
		nr_seq_proc_interno
	into STRICT	cd_item_w,
		qt_item_w,
		vl_item_w,
		ie_origem_proced_w,
		dt_item_w,
		nr_seq_proc_interno_w
	from 	procedimento_paciente
	where 	nr_sequencia = nr_seq_item_p;

end if;


insert into cta_pendencia_item(
		nr_sequencia,
		nr_seq_pend,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_proc_mat,
		nr_seq_item,
		cd_item,
		qt_item,
		vl_item,
		ie_origem_proced,
		dt_item,
		nr_seq_proc_interno)
	values (nextval('cta_pendencia_item_seq'),
		nr_seq_pendencia_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_proc_mat_p,
		nr_seq_item_p,
		cd_item_w,
		qt_item_w,
		vl_item_w,
		ie_origem_proced_w,
		dt_item_w,
		nr_seq_proc_interno_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_item_pendencia (nr_seq_item_p bigint, nr_seq_pendencia_p bigint, ie_proc_mat_p text, nm_usuario_p text) FROM PUBLIC;

