-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_autor_item_conta (nr_atendimento_p bigint, nr_seq_autorizacao_p bigint, cd_convenio_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_proc_autor_w		bigint;
cd_mat_autor_w		bigint;
ie_origem_proced_w	varchar(255);
nr_seq_material_w	bigint;
nr_seq_mat_autor_w	bigint;
nr_seq_proc_autor_w	bigint;
nr_seq_procedimento_w	bigint;

c01 CURSOR FOR
SELECT 	cd_procedimento,
	ie_origem_proced,
	nr_sequencia
from 	procedimento_autorizado
where	nr_sequencia_autor	= nr_seq_autorizacao_p;

c02 CURSOR FOR
SELECT 	cd_material,
	nr_sequencia
from 	material_autorizado
where	nr_sequencia_autor	= nr_seq_autorizacao_p;

c03 CURSOR FOR
SELECT 	nr_sequencia
from 	procedimento_paciente
where	cd_procedimento		= cd_proc_autor_w
and 	ie_origem_proced 	= ie_origem_proced_w
and 	nr_atendimento		= nr_atendimento_p
and 	cd_convenio		= cd_convenio_p
and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
and 	coalesce(cd_motivo_exc_conta::text, '') = '';

c04 CURSOR FOR
SELECT 	nr_sequencia
from 	material_atend_paciente
where	cd_material		= cd_mat_autor_w
and 	nr_atendimento		= nr_atendimento_p
and 	cd_convenio_p		= cd_convenio_p
and	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
and 	coalesce(cd_motivo_exc_conta::text, '') = '';


BEGIN

open c01;
loop
fetch c01 into
	cd_proc_autor_w,
	ie_origem_proced_w,
	nr_seq_proc_autor_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c03;
	loop
	fetch c03 into
		nr_seq_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */

		update	procedimento_paciente
		set	nr_seq_proc_autor	= coalesce(nr_seq_proc_autor,nr_seq_proc_autor_w)
		where	nr_sequencia		= nr_seq_procedimento_w;

	end loop;
	close c03;

end loop;
close c01;


open c02;
loop
fetch c02 into
	cd_mat_autor_w,
	nr_seq_mat_autor_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	open c04;
	loop
	fetch c04 into
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */

		update	material_atend_paciente
		set	nr_seq_mat_autor	= coalesce(nr_seq_mat_autor,nr_seq_mat_autor_w)
		where	nr_sequencia		= nr_seq_material_w;

	end loop;
	close c04;

end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_autor_item_conta (nr_atendimento_p bigint, nr_seq_autorizacao_p bigint, cd_convenio_p bigint, nm_usuario_p text) FROM PUBLIC;

