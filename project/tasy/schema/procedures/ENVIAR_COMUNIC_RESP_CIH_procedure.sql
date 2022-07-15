-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_comunic_resp_cih (nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_perfil_p text, qt_dia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

qt_reg_w		integer;
ds_motivo_w		varchar(150);
nr_atend_anterior_w	bigint;
ie_gerar_alerta_w	varchar(1);


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	atend_paciente_hist
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_evento		= 'I'
and		coalesce(dt_inativacao::text, '') = ''
and	coalesce(dt_final, dt_inicial) >= (clock_timestamp() - qt_dia_p);




nr_atend_anterior_w :=	obter_ultimo_atend_CIH(cd_pessoa_fisica_p,nm_usuario_p);
ds_motivo_w := coalesce(substr(obter_desc_motivo_isol_cih(nr_atend_anterior_w),1,150),wheb_mensagem_pck.get_texto(793287));
ie_gerar_alerta_w := coalesce(substr(obter_se_isol_gera_alerta(nr_atend_anterior_w),1,1),'S');

if (qt_reg_w >= 1)	and (ie_gerar_alerta_w = 'S') then

	insert	into comunic_interna(
		dt_comunicado,
		ds_titulo,
		ds_comunicado,
		nm_usuario,
		dt_atualizacao,
		ie_geral,
		nm_usuario_destino,
		nr_sequencia,
		ie_gerencial,
		nr_seq_classif,
		ds_perfil_adicional,
		cd_setor_destino,
		cd_estab_destino,
		ds_setor_adicional,
		dt_liberacao)
	values (clock_timestamp(),
		wheb_mensagem_pck.get_texto(801995),
		wheb_mensagem_pck.get_texto(791350) || ': '	|| obter_nome_pf(cd_pessoa_fisica_p) || chr(13) || chr(10) ||
		wheb_mensagem_pck.get_texto(307420) || ': '	|| nr_atendimento_p || chr(13) || chr(10) || chr(13) || chr(10) ||
		wheb_mensagem_pck.get_texto(801996, 'QT_DIA='||qt_dia_p) || chr(13) || chr(10) ||
		wheb_mensagem_pck.get_texto(801997) || ': '  || ds_motivo_w ,
		nm_usuario_p,
		clock_timestamp(),
		'N',
		null,
		nextval('comunic_interna_seq'),
		'N',
		null,
		ds_perfil_p,
		null,
		cd_estabelecimento_p,
		null,
		clock_timestamp());
		end	if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_resp_cih (nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_perfil_p text, qt_dia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

