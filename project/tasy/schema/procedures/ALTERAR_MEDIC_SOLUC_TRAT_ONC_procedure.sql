-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_medic_soluc_trat_onc ( nr_seq_paciente_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
cd_material_w			bigint;
nr_agrupamento_w		bigint;
nr_seq_diluicao_w		bigint;
cd_material_diluido_w		bigint;
nr_seq_atendimento_w		bigint;
nr_seq_solucao_w		bigint;
nr_seq_material_w		bigint;
nr_seq_int_prot_medic_w		bigint;
nr_seq_interno_w		bigint;

c01 CURSOR FOR
	SELECT	*
	from	paciente_protocolo_medic
	where	nr_seq_paciente		= nr_seq_paciente_p
	and	nr_seq_solucao		= nr_seq_solucao_p;

c01_w	c01%rowtype;

c02 CURSOR FOR
	SELECT	a.nr_seq_atendimento,
		b.nr_seq_solucao,
		b.nr_seq_interno
	from	paciente_atendimento a,
		paciente_atend_medic b
	where	a.nr_seq_atendimento	= b.nr_seq_atendimento
	and	a.nr_seq_paciente	= nr_seq_paciente_p
	and	coalesce(a.nr_prescricao::text, '') = ''
	and	b.nr_seq_int_prot_medic	= nr_seq_int_prot_medic_w;



BEGIN
select	coalesce(max(b.cd_estabelecimento),1)
into STRICT	cd_estabelecimento_w
from	paciente_setor		b
where	b.nr_seq_paciente = nr_seq_paciente_p;

CALL wheb_usuario_pck.set_ie_executar_trigger('N');

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_material_w		:= c01_w.cd_material;
	--nr_agrupamento_w	:= c01_w.nr_agrupamento;
	nr_seq_material_w	:= c01_w.nr_seq_material;
	nr_seq_int_prot_medic_w	:= c01_w.nr_seq_interno;

	open C02;
	loop
	fetch C02 into
		nr_seq_atendimento_w,
		nr_seq_solucao_w,
		nr_seq_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		update	paciente_atend_medic
		set	CD_MATERIAL		= c01_w.CD_MATERIAL,
			CD_UNID_MED_DOSE	= c01_w.CD_UNIDADE_MEDIDA,
			QT_DOSE			= c01_w.QT_DOSE,
			CD_UNID_MED_PRESCR	= c01_w.CD_UNID_MED_PRESCR,
			QT_DOSE_PRESCRICAO	= c01_w.QT_DOSE_PRESCR,
			IE_PRE_MEDICACAO	= c01_w.IE_PRE_MEDICACAO,
			PR_REDUCAO		= C01_W.PR_REDUCAO
		where	nr_seq_interno	= nr_seq_interno_w;

		end;

	end loop;
	close C02;

	end;
end loop;
close C01;

CALL wheb_usuario_pck.set_ie_executar_trigger('S');
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_medic_soluc_trat_onc ( nr_seq_paciente_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) FROM PUBLIC;
