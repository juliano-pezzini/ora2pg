-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_medicacao_pac_quimio ( nr_seq_via_acesso_p bigint, nr_seq_via_acesso_old_p bigint, qt_dose_prescricao_p text, nr_seq_atendimento_p bigint, ie_via_aplicacao_p text, nr_seq_material_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_msg_dialog_p INOUT text, ds_msg_dialog_2_p INOUT text, ds_msg_pergunta_p INOUT text) AS $body$
DECLARE


ie_exibe_alerta_via_acesso_w	varchar(1);
ie_tem_itens_w		varchar(1);
ie_itens_zerados_w		varchar(1);


BEGIN

/* Quimioterapia - Parâmetro 91 - Ao informar a via de acesso, exibir alerta caso a dose esteja zerada */

ie_exibe_alerta_via_acesso_w := obter_param_usuario(3130, 91, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exibe_alerta_via_acesso_w);

if (nr_seq_via_acesso_p <> nr_seq_via_acesso_old_p) and (ie_exibe_alerta_via_acesso_w = 'S') and (qt_dose_prescricao_p = 0) then
		ds_msg_dialog_p	:= substr(obter_texto_tasy(57822, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
into STRICT	ie_itens_zerados_w
from	paciente_atend_medic
where	nr_seq_atendimento	= nr_seq_atendimento_p
and	nr_seq_material	<> nr_seq_material_p
and	coalesce(nr_seq_diluicao::text, '') = ''
and (coalesce(qt_dose_prescricao::text, '') = '' or qt_dose_prescricao = 0);

if (ie_exibe_alerta_via_acesso_w = 'S') and (ie_itens_zerados_w = 'S') then
	ds_msg_dialog_2_p	:= substr(obter_texto_tasy(57824, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

select	CASE WHEN count(*)=0 THEN  'N' WHEN count(*)=1 THEN  'N'  ELSE 'S' END
into STRICT	ie_tem_itens_w
from	paciente_atend_medic
where	nr_seq_atendimento	= nr_seq_atendimento_p
and	coalesce(nr_seq_diluicao::text, '') = ''
and	ie_via_aplicacao	= ie_via_aplicacao_p;

if (coalesce(nr_seq_via_acesso_p,0) <> coalesce(nr_seq_via_acesso_old_p,0)) and (ie_tem_itens_w = 'S') then
	ds_msg_pergunta_p	:= substr(obter_texto_tasy(57825, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_medicacao_pac_quimio ( nr_seq_via_acesso_p bigint, nr_seq_via_acesso_old_p bigint, qt_dose_prescricao_p text, nr_seq_atendimento_p bigint, ie_via_aplicacao_p text, nr_seq_material_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_msg_dialog_p INOUT text, ds_msg_dialog_2_p INOUT text, ds_msg_pergunta_p INOUT text) FROM PUBLIC;
