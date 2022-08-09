-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_auto_material ( nr_atendimento_p bigint, nr_seq_cpoe_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w		cpoe_material.cd_material%type;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%type;

c01 CURSOR FOR
	SELECT	b.nr_seq_proc_interno,
		b.nr_seq_regra,
		b.nr_seq_lanc,
		b.ie_origem_proced,
		b.cd_procedimento,
		b.qt_lancamento,
		b.tx_procedimento
	from 	regra_lanc_automatico a,
		regra_lanc_aut_pac b
	where 	a.nr_sequencia = b.nr_seq_regra
	and 	a.nr_seq_evento = 132
	and 	a.cd_material = cd_material_w
	and 	coalesce(b.ie_gen_med_guide_fee,'N') = 'S'
	and	a.ie_tipo_atendimento = coalesce(ie_tipo_atendimento_w,8);

c01_w		c01%rowtype;


BEGIN

select 	max(cd_material)
into STRICT	cd_material_w
from 	cpoe_material
where 	nr_sequencia = nr_seq_cpoe_p;

select	max(ie_tipo_atendimento)
into STRICT	ie_tipo_atendimento_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;

open C01;
loop
fetch C01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into MED_GUIDANCE_PRESCR(
		nr_sequencia,
		nr_seq_proc_interno,
		cd_material,
		nr_seq_regra_lanc,
		nm_usuario,
		nr_atendimento,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_cpoe_mat,
		nr_seq_lanc_acao,
		ie_origem_proced,
		cd_procedimento,
		qt_lancamento,
		tx_procedimento)
	values (
		nextval('med_guidance_prescr_seq'),
		c01_w.nr_seq_proc_interno,
		cd_material_w,
		c01_w.nr_seq_regra,
		nm_usuario_p,
		nr_atendimento_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_cpoe_p,
		c01_w.nr_seq_lanc,
		c01_w.ie_origem_proced,
		c01_w.cd_procedimento,
		c01_w.qt_lancamento,
		c01_w.tx_procedimento);
	end;
end loop;
close C01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_auto_material ( nr_atendimento_p bigint, nr_seq_cpoe_p bigint, nm_usuario_p text) FROM PUBLIC;
