-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_medic_onco ( nr_prescricao_p bigint, nr_seq_medic_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_ordem_w		bigint;
dt_agenda_w		timestamp;
cd_estabelecimento_w	smallint;
ie_permite_cancelar_w	varchar(1);

C01 CURSOR FOR
	SELECT	b.nr_seq_ordem
	from	can_ordem_item_prescr b,
		prescr_material a
	where	a.nr_prescricao		= nr_prescricao_p
	and	nr_seq_atend_medic	= nr_seq_medic_p
	and	a.nr_prescricao		= b.nr_prescricao
	and	a.nr_sequencia		= b.nr_seq_prescricao;


BEGIN

select	max(coalesce(cd_estabelecimento,0))
into STRICT	cd_estabelecimento_w
from	prescr_medica
where	nr_prescricao	=	nr_prescricao_p;

ie_permite_cancelar_w := Obter_Param_Usuario(281, 282, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_cancelar_w);

select	coalesce(b.dt_real,b.dt_prevista)
into STRICT	dt_agenda_w
from	paciente_atendimento b,
	paciente_atend_medic a
where	a.nr_seq_interno	= nr_seq_medic_p
and	a.nr_seq_atendimento	= b.nr_seq_atendimento;

if (dt_agenda_w < clock_timestamp()) and (ie_permite_cancelar_w = 'N') then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(266289);
end if;

update	paciente_atend_medic
set	ie_cancelada		= 'S',
	dt_cancelamento		= clock_timestamp(),
	nm_usuario_cancel	= nm_usuario_p
where	nr_seq_interno		= nr_seq_medic_p;

update	prescr_material
set	ie_suspenso		= 'S',
	dt_suspensao		= clock_timestamp(),
	nm_usuario_susp		= nm_usuario_p
where	nr_prescricao		= nr_prescricao_p
and	nr_seq_atend_medic	= nr_seq_medic_p;

OPEN C01;
LOOP
FETCH C01 into
	nr_seq_ordem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	update	can_ordem_prod
	set	ie_cancelada	= 'S',
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_ordem_w;
END LOOP;
CLOSE C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_medic_onco ( nr_prescricao_p bigint, nr_seq_medic_p bigint, nm_usuario_p text) FROM PUBLIC;
