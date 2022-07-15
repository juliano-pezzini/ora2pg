-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_erro_prescr_material (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_regra_p bigint, ie_permite_liberar_p text, ds_compl_erro_p text, cd_perfil_p bigint, nm_usuario_p text, nr_seq_erro_p INOUT bigint, nr_seq_solucao_p bigint default null, ie_agrupador_p bigint default null, ie_justificado_p text default null) AS $body$
DECLARE

													
ds_cor_w			varchar(15);
ie_regra_w			varchar(15);
ds_regra_w			varchar(255);
ds_msg_perfil_w		varchar(4000);
ds_msg_wheb_w		varchar(4000);
ds_inf_w			varchar(2000);
ie_prioridade_w		smallint;
ie_agrupador_w		smallint;
nr_seq_erro_w		bigint;
ie_tipo_item_w		varchar(255):=null;
nr_seq_mat_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
ie_controle_tempo_w	cpoe_material.ie_controle_tempo%type;
ie_material_w		cpoe_material.ie_material%type;	

c01 CURSOR FOR
SELECT	ds_mensagem_cliente
from	regra_consiste_prescr_par
where	nr_seq_regra 		= nr_regra_p
and	coalesce(cd_perfil,cd_perfil_p)	= cd_perfil_p
order by
	nr_sequencia;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (ie_permite_liberar_p IS NOT NULL AND ie_permite_liberar_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	
	ie_agrupador_w	:= ie_agrupador_p;
	if (coalesce(ie_agrupador_p::text, '') = '') then
		select	ie_agrupador
		into STRICT	ie_agrupador_w
		from	prescr_material
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_material_p;	
	end if;
	open c01;
	loop
	fetch c01 into ds_msg_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_msg_perfil_w := ds_msg_perfil_w;
		end;
	end loop;
	close c01;
	
	select	max(ie_tipo_regra),
		max(obter_desc_expressao(cd_exp_descricao,ds_regra_prescr)),
		max(obter_desc_expressao(cd_exp_mensagem,ds_mensagem_usuario)),
		max(obter_desc_expressao(cd_exp_informacao_adic,ds_informacao_adic)),
		max(ie_prioridade),
		max(ds_cor)
	into STRICT	ie_regra_w,
		ds_regra_w,
		ds_msg_wheb_w,
		ds_inf_w,
		ie_prioridade_w,
		ds_cor_w
	from	regra_consiste_prescr
	where	nr_sequencia = nr_regra_p;
	
	select	nextval('prescr_medica_erro_seq')
	into STRICT	nr_seq_erro_w
	;

	if (ie_justificado_p = 'S') then

	insert into prescr_medica_erro_just(
		nr_sequencia,
		nr_prescricao,
		nr_seq_medic,
		ie_agrupador,
		nr_regra,
		ds_inconsistencia,
		ds_erro,
		ds_compl_erro,
		ie_libera,
		ie_tipo_regra,		
		ds_inf_adicional,
		ie_prioridade,
		ds_cor,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario,
		dt_atualizacao,
		nr_seq_solucao)
	values (
		nr_seq_erro_w,
		nr_prescricao_p,
		nr_seq_material_p,
		ie_agrupador_w,
		nr_regra_p,
		ds_regra_w,
		coalesce(ds_msg_perfil_w,ds_msg_wheb_w),
		ds_compl_erro_p,
		ie_permite_liberar_p,
		ie_regra_w,		
		ds_inf_w,
		ie_prioridade_w,
		ds_cor_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_solucao_p);

	else

	insert into prescr_medica_erro(
		nr_sequencia,
		nr_prescricao,
		nr_seq_medic,
		ie_agrupador,
		nr_regra,
		ds_inconsistencia,
		ds_erro,
		ds_compl_erro,
		ie_libera,
		ie_tipo_regra,		
		ds_inf_adicional,
		ie_prioridade,
		ds_cor,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario,
		dt_atualizacao,
		nr_seq_solucao)
	values (
		nr_seq_erro_w,
		nr_prescricao_p,
		nr_seq_material_p,
		ie_agrupador_w,
		nr_regra_p,
		ds_regra_w,
		coalesce(ds_msg_perfil_w,ds_msg_wheb_w),
		ds_compl_erro_p,
		ie_permite_liberar_p,
		ie_regra_w,		
		ds_inf_w,
		ie_prioridade_w,
		ds_cor_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_solucao_p);

	end if;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

	
	if (obter_funcao_origem_prescr(nr_prescricao_p) = 2314) and --CPOE
	   (cpoe_obter_se_consiste(nr_regra_p) = 'S') then
	
		if (ie_agrupador_w in (1,2,4,3,7,9)) then
		
			select max(nr_seq_mat_cpoe)
			into STRICT nr_seq_mat_cpoe_w
			from prescr_material
			where nr_prescricao = nr_prescricao_p
			and nr_sequencia = nr_seq_material_p;
			
			select	max(ie_controle_tempo),
				max(ie_material)
			into STRICT	ie_controle_tempo_w,
				ie_material_w
			from	cpoe_material
			where	nr_sequencia = nr_seq_mat_cpoe_w;
			
			if (ie_material_w	= 'S') then
				ie_tipo_item_w	:= 'MAT';
			elsif (ie_controle_tempo_w	= 'S') then	
				ie_tipo_item_w	:= 'SOL';
			elsif (ie_controle_tempo_w	= 'N') then
				ie_tipo_item_w	:= 'M';
			end if;					

		elsif (ie_agrupador_w = 8) then
			ie_tipo_item_w	:= 'SNE';
		elsif (ie_agrupador_w = 10) then
			ie_tipo_item_w	:= 'NPTA';
		elsif (ie_agrupador_w = 11) then
			ie_tipo_item_w	:= 'NPTI';	
		elsif (ie_agrupador_w = 12) then
			ie_tipo_item_w	:= 'S';	
		elsif (ie_agrupador_w in (16,17)) then
			ie_tipo_item_w	:= 'LD';	
		end if;
	
		if (ie_tipo_item_w IS NOT NULL AND ie_tipo_item_w::text <> '') then		
			nr_seq_erro_p := gerar_erro_cpoe(obter_nr_sequencia_cpoe(nr_seq_material_p,nr_prescricao_p, ie_tipo_item_w), ie_tipo_item_w, nr_regra_p, coalesce(ie_justificado_p,ie_permite_liberar_p), ds_compl_erro_p, cd_perfil_p, nm_usuario_p, obter_atendimento_prescr(nr_prescricao_p), nr_prescricao_p, nr_seq_erro_p);
		end if;	
	end if;	
	
	nr_seq_erro_p	:= nr_seq_erro_w;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_erro_prescr_material (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_regra_p bigint, ie_permite_liberar_p text, ds_compl_erro_p text, cd_perfil_p bigint, nm_usuario_p text, nr_seq_erro_p INOUT bigint, nr_seq_solucao_p bigint default null, ie_agrupador_p bigint default null, ie_justificado_p text default null) FROM PUBLIC;

