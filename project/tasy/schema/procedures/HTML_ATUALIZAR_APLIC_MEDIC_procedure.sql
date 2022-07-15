-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_atualizar_aplic_medic ( nr_sequencia_p bigint, nr_atendimento_p bigint, qt_hora_p bigint, qt_minuto_p bigint, nm_usuario_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) AS $body$
DECLARE


nr_prescricao_w				prescr_medica.nr_prescricao%type;
nr_seq_prescr_mat_w			prescr_material.nr_sequencia%type;
nr_prescricao_vigente_w		prescr_medica.nr_prescricao%type;

c01 CURSOR FOR
SELECT	a.nr_prescricao,
		a.nr_sequencia
from	prescr_material a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		b.nr_prescricao >= nr_prescricao_vigente_w
and		((b.nr_atendimento = nr_atendimento_p) or (b.cd_pessoa_fisica = cd_pessoa_fisica_p and coalesce(b.nr_atendimento::text, '') = ''))
and		a.nr_seq_mat_cpoe = nr_sequencia_p;


BEGIN

nr_prescricao_vigente_w := gpt_obter_prescricao_vigente(nr_sequencia_p, 'M');

update	cpoe_material
set	qt_hora_aplicacao	= qt_hora_p,
	qt_min_aplicacao	= qt_minuto_p
where	nr_sequencia	= nr_sequencia_p;
	
open c01;
loop
fetch c01 into
	nr_prescricao_w,
	nr_seq_prescr_mat_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	update	prescr_material
	set	ds_diluicao_edit	= '',
		qt_hora_aplicacao	= qt_hora_p,
		qt_min_aplicacao	= qt_minuto_p
	where	nr_prescricao		= nr_prescricao_w
	and	nr_sequencia		= nr_seq_prescr_mat_w;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_atualizar_aplic_medic ( nr_sequencia_p bigint, nr_atendimento_p bigint, qt_hora_p bigint, qt_minuto_p bigint, nm_usuario_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) FROM PUBLIC;

