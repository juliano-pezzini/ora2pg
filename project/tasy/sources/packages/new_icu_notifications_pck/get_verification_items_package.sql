-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION new_icu_notifications_pck.get_verification_items (nm_usuario_p text, cd_pessoa_fisica_p text, cd_perfil_p bigint, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_verif_items_w	bigint := 0;


BEGIN

	select	sum(qt_verif_item)
	into STRICT	qt_verif_items_w
	from
	(SELECT	count(*) qt_verif_item
	from    cpoe_material
	where   nr_atendimento = nr_atendimento_p
	and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and     ie_ordered_on_behalf = 'S'
	and     coalesce(dt_ciencia_medico::text, '') = ''
	and     ((CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih, dt_fim)  ELSE coalesce(dt_suspensao, dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih, dt_fim)  ELSE coalesce(dt_suspensao, dt_fim) coalesce(END::text, '') = ''))
	and     ((cd_medico = cd_pessoa_fisica_p) or (cpoe_verifica_regra_aprovacao(cd_perfil_p, nm_usuario_p, 'NO') = 'S'))
	
union all

	SELECT	count(*) qt_verif_item
	from    cpoe_procedimento
	where   nr_atendimento = nr_atendimento_p
	and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and     ie_ordered_on_behalf = 'S'
	and     coalesce(dt_ciencia_medico::text, '') = ''
	and    	((CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END  >= clock_timestamp())
	or (CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) coalesce(END::text, '') = ''))
	and     ((cd_medico = cd_pessoa_fisica_p) or (cpoe_verifica_regra_aprovacao(cd_perfil_p, nm_usuario_p, 'NO') = 'S'))) alias35;

	return qt_verif_items_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION new_icu_notifications_pck.get_verification_items (nm_usuario_p text, cd_pessoa_fisica_p text, cd_perfil_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
