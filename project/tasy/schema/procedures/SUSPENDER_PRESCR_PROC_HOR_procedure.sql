-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_prescr_proc_hor ( nr_sequencia_p bigint, nm_usuario_p text, ie_prescr_alteracao_p text default 'N') AS $body$
DECLARE



nr_seq_proc_interno_w 	prescr_proc_hor.nr_seq_proc_interno%type;
cd_procedimento_w	 	prescr_proc_hor.cd_procedimento%type;
ie_origem_proced_w		prescr_proc_hor.ie_origem_proced%type;
nr_seq_alteracao_w		prescr_mat_alteracao.nr_sequencia%type;
ds_justificativa_w		prescr_mat_alteracao.ds_justificativa%type;
nr_seq_procedimento_w	integer;
nr_prescricao_w			bigint;
nr_seq_material_w		integer;
nr_atendimento_w		bigint;
cd_material_w			integer;
dt_horario_w			timestamp;
nr_seq_mat_hor_w		bigint;
ie_gravar_justif_w		varchar(1);


c01 CURSOR FOR
SELECT	c.nr_sequencia,
	b.cd_material,
	b.nr_sequencia
from	prescr_material b,
	prescr_mat_hor c
where	b.nr_prescricao = c.nr_prescricao
and	b.nr_sequencia	= c.nr_seq_material
and	b.nr_sequencia_proc = nr_seq_procedimento_w
and	b.nr_prescricao = nr_prescricao_w
and	c.nr_prescricao = nr_prescricao_w
and	c.dt_horario	= dt_horario_w
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = '';


BEGIN

ie_gravar_justif_w := Obter_Param_Usuario(924, 890, obter_perfil_ativo, nm_usuario_p, 0, ie_gravar_justif_w);

select	max(nr_seq_procedimento),
	max(nr_prescricao),
	max(dt_horario),
	max(nr_seq_proc_interno),
	max(cd_procedimento),
	max(ie_origem_proced),
	CASE WHEN ie_gravar_justif_w='S' THEN  PERFORM obter_desc_expressao(727956) END
into STRICT	nr_seq_procedimento_w,
	nr_prescricao_w,
	dt_horario_w,
	nr_seq_proc_interno_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	ds_justificativa_w
from	prescr_proc_hor
where	nr_sequencia	= nr_sequencia_p;

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_w;

update	prescr_proc_hor
set	dt_suspensao	= clock_timestamp(),
	nm_usuario_susp	= nm_usuario_p
where	nr_sequencia 	= nr_sequencia_p
and	coalesce(dt_fim_horario::text, '') = ''
and	coalesce(dt_suspensao::text, '') = '';

update	prescr_procedimento
set	ie_horario_susp	= 'S'
where	nr_prescricao	= nr_prescricao_w
and	nr_sequencia	= nr_seq_procedimento_w;

if ((nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and ie_prescr_alteracao_p = 'S') then
	CALL gerar_alter_hor_prescr_adep( nr_atendimento_w, 'P', cd_procedimento_w,
						nr_prescricao_w, nr_seq_procedimento_w, nr_sequencia_p,
						dt_horario_w, 5, ds_justificativa_w, null, null, nm_usuario_p);
end if;

open C01;
loop
fetch C01 into
	nr_seq_mat_hor_w,
	cd_material_w,
	nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL Suspender_prescr_mat_hor(nr_seq_mat_hor_w,nm_usuario_p,null,null,'N',null);
	CALL Gerar_Alter_Hor_Prescr_Adep(nr_atendimento_w, 'IA', cd_material_w, nr_prescricao_w, nr_seq_material_w, nr_seq_mat_hor_w, dt_horario_w, 12,null,Obter_desc_expressao(729634),null,nm_usuario_p);
	update	prescr_material
	set	ie_horario_susp	= 'S'
	where	nr_prescricao	= nr_prescricao_w
	and	nr_sequencia	= nr_seq_material_w;
	end;
end loop;
close C01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_prescr_proc_hor ( nr_sequencia_p bigint, nm_usuario_p text, ie_prescr_alteracao_p text default 'N') FROM PUBLIC;
