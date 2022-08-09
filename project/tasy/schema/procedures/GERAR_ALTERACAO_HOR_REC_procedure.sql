-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alteracao_hor_rec ( nr_prescricao_p text, nr_seq_horario_p bigint, cd_item_p text, nr_atendimento_p bigint, ie_tipo_alteracao_p text, nm_usuario_p text, dt_alteracao_p timestamp) AS $body$
DECLARE

					
nr_seq_alteracao_w	bigint;
nr_prescricao_w		bigint;
dt_horario_w  		timestamp;
ie_permite_terminar_w	varchar(1);
dt_inicio_w		timestamp;
ds_material_w		varchar(255);
cd_item_w		bigint;


BEGIN

begin
	cd_item_w	:=	cd_item_p;
exception when data_exception then
	cd_item_w	:= 0;
end;

if (ie_tipo_alteracao_p = 20) then
	/* Verifica se permite terminar com itens pendentes  */

	if (cd_item_w > 0) then
		select	coalesce(ie_permite_terminar,'S')
		into STRICT	ie_permite_terminar_w
		from	tipo_recomendacao
		where	cd_tipo_recomendacao = cd_item_p;
	else
		ie_permite_terminar_w	:= 'S';
	end if;
	
	select	max(dt_alteracao)
	into STRICT	dt_inicio_w
	from	prescr_mat_alteracao
	where	nr_seq_horario_rec	= nr_seq_horario_p
	and	ie_alteracao		= 19;
	
	/* Se nao permitir terminar com horarios pendentes ele verifica se tem algum pendente */

	if (ie_permite_terminar_w = 'N') then
		select	max(c.dt_horario),
			substr(max(obter_desc_material(b.cd_material)),1,255)
		into STRICT	dt_horario_w,
			ds_material_w
		from	prescr_mat_hor	c,
			prescr_material b,
			prescr_medica	a
		where	a.nr_prescricao  = b.nr_prescricao
		and	a.nr_prescricao  = c.nr_prescricao
		and	b.nr_prescricao  = c.nr_prescricao
		and	b.nr_sequencia   = c.nr_seq_material
		and	c.dt_horario between dt_inicio_w and clock_timestamp()
		and	a.dt_validade_prescr between clock_timestamp() - interval '2 days' and clock_timestamp() + interval '2 days'
		and	a.nr_atendimento = nr_atendimento_p
		and	coalesce(ie_horario_especial,'N') = 'N'
		and	coalesce(c.dt_fim_horario::text, '') = ''
		and	coalesce(c.dt_suspensao::text, '') = ''
		and	(c.dt_lib_horario IS NOT NULL AND c.dt_lib_horario::text <> '')
		and	b.ie_agrupador   = 1;
		
		/* Se houver horarios pendentes ele apresenta uma mensagem para o usuario */

		if (dt_horario_w IS NOT NULL AND dt_horario_w::text <> '') then
			-- O medicamento #@DS_MEDIC#@ possui o horario #@DS_HOR#@ nao administrado. Favor verificar!
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(198169,'DS_MEDIC='||ds_material_w||';DS_HOR='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
		end if;
	end if;
	/* Termina a recomedacao se as regras permitirem  */

	update	prescr_rec_hor
	set	dt_fim_horario	= clock_timestamp(),
		nm_usuario_adm	= nm_usuario_p
	where	nr_sequencia	= nr_seq_horario_p
	and	coalesce(dt_fim_horario::text, '') = ''
	and	coalesce(dt_suspensao::text, '') = '';
end if;

select	max(nr_prescricao)
into STRICT		nr_prescricao_w
from		prescr_rec_hor
where	nr_sequencia	= nr_seq_horario_p;

select	nextval('prescr_mat_alteracao_seq')
into STRICT	nr_seq_alteracao_w
;

insert	into	prescr_mat_alteracao(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_prescricao,	
	nr_seq_horario_rec,
	dt_alteracao,
	cd_pessoa_fisica,
	ie_alteracao,
	ie_tipo_item,
	dt_horario,
	nr_atendimento,
	cd_item
	)
values (
	nr_seq_alteracao_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_prescricao_w,
	nr_seq_horario_p,
	dt_alteracao_p,
	obter_dados_usuario_opcao(nm_usuario_p,'C'),
	ie_tipo_alteracao_p,
	'R',
	dt_alteracao_p,
	nr_atendimento_p,
	cd_item_p
	);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alteracao_hor_rec ( nr_prescricao_p text, nr_seq_horario_p bigint, cd_item_p text, nr_atendimento_p bigint, ie_tipo_alteracao_p text, nm_usuario_p text, dt_alteracao_p timestamp) FROM PUBLIC;
