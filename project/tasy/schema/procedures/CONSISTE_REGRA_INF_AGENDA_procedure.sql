-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_regra_inf_agenda ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, ds_mensagem_p INOUT text, ie_acao_p INOUT text) AS $body$
DECLARE



ie_informacao_w		varchar(10);
ie_acao_w		varchar(10);
qt_registros_w		bigint;
ds_mensagem_w		varchar(4000);
quebra_w		varchar(10)	:= chr(13)||chr(10);
ie_inconsistente_w	boolean;
nr_seq_tipo_avaliacao_w	bigint;
ie_diagn_princ_w	varchar(1);
ie_evolucao_dia_w	varchar(1)	:= 'N';
cd_convenio_w		bigint;
ie_evolucao_clinica_w	varchar(3);
ie_tipo_justificativa_w	varchar(3);
ie_tipo_atendimento_w	varchar(10);
nr_seq_template_w		bigint;
cd_estabelecimento_w	bigint;
CD_PESSOA_FISICA_w		varchar(10);


C01 CURSOR FOR
	SELECT	ie_informacao,
		ie_acao,
		nr_seq_tipo_avaliacao,
		IE_EVOLUCAO_CLINICA,
		IE_TIPO_JUSTIFICATIVA,
		nr_seq_template
	from	REGRA_CONSISTE_INF_AGENDA
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0))	= coalesce(cd_setor_atendimento_p,0)
	and	coalesce(cd_perfil,cd_perfil_p)							= cd_perfil_p
	and	coalesce(cd_convenio,cd_convenio_w)						= cd_convenio_w
	and coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)		= ie_tipo_atendimento_w
	and	coalesce(CD_PESSOA_FISICA,CD_PESSOA_FISICA_w)			= CD_PESSOA_FISICA_w;

BEGIN

ie_acao_p	:= 'A';
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

if (coalesce(nr_atendimento_p,0) > 0) then

	select	coalesce(max(cd_convenio),0)
	into STRICT	cd_convenio_w
	from	resumo_atendimento_paciente_v
	where	nr_atendimento	= nr_atendimento_p;

	select 	max(ie_tipo_atendimento)
	into STRICT	ie_tipo_atendimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;


	select	coalesce(max(cd_pessoa_fisica),'0')
	into STRICT	CD_PESSOA_FISICA_w
	from	usuario
	where	nm_usuario	= wheb_usuario_pck.get_nm_usuario;

	open C01;
	loop
	fetch C01 into
		ie_informacao_w,
		ie_acao_w,
		nr_seq_tipo_avaliacao_w,
		ie_evolucao_clinica_w,
		ie_tipo_justificativa_w,
		nr_seq_template_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ie_inconsistente_w	:= false;
		if (ie_informacao_w	= 'A') then
			select	count(*)
			into STRICT	qt_registros_w
			from	anamnese_paciente
			where	nr_atendimento	= nr_atendimento_p
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(dt_inativacao::text, '') = '';

			if (qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(346443) ||quebra_w;
				ie_inconsistente_w	:= true;
			end if;
		elsif (ie_informacao_w	= 'J') then
			select	count(*)
			into STRICT	qt_registros_w
			from	paciente_justificativa
			where	nr_atendimento	= nr_atendimento_p
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(ie_tipo_justificativa_w::text, '') = '')or (ie_tipo_justificativa	= ie_tipo_justificativa_w))
			and	coalesce(dt_inativacao::text, '') = '';

			if (qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(728752) ||quebra_w;
				ie_inconsistente_w	:= true;
			end if;
		elsif (ie_informacao_w	= 'E') then
			select	count(*)
			into STRICT	qt_registros_w
			from	evolucao_paciente
			where	nr_atendimento	= nr_atendimento_p
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(dt_inativacao::text, '') = ''
			and	((coalesce(ie_evolucao_clinica_w::text, '') = '')or (ie_evolucao_clinica	= ie_evolucao_clinica_w));

			if (qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(346436);
				ie_inconsistente_w	:= true;
			end if;
/*		elsif	(ie_informacao_w	= 'E') then
			select	count(*)
			into	qt_registros_w
			from	paciente_medic_uso
			where 	nr_atendimento	= nr_atendimento_p
			and	dt_liberacao is not null;

			if	(qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w||'Evolução do paciente não foi criada/liberada.';
				ie_inconsistente_w	:= true;
			end if;*/
		elsif (ie_informacao_w	= 'D') then
			select	count(*)
			into STRICT	qt_registros_w
			from	diagnostico_doenca
			where 	nr_atendimento	= nr_atendimento_p;
			--and	dt_liberacao is not null;
			if (qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(517714);
				ie_inconsistente_w	:= true;
			end if;
		elsif (ie_informacao_w	= 'DP') then

			select	coalesce(max('S'),'N')
			into STRICT	ie_diagn_princ_w
			from	diagnostico_doenca
			where 	nr_atendimento	= nr_atendimento_p
			and	substr(obter_cod_tipo_diagnostico(nr_atendimento,dt_diagnostico),1,1) = '2';

			if (ie_diagn_princ_w = 'N') then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(346433);
				ie_inconsistente_w	:= true;
			end if;
		elsif (ie_informacao_w	= 'O') then
			select	count(*)
			into STRICT	qt_registros_w
			from	ATENDIMENTO_ALTA
			where 	nr_atendimento	= nr_atendimento_p
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

			if (qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(346431);
				ie_inconsistente_w	:= true;
			end if;
		elsif (ie_informacao_w	= 'AV') then

			select	count(*)
			into STRICT	qt_registros_w
			from	med_avaliacao_paciente
			where	nr_atendimento	= nr_atendimento_p
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(dt_inativacao::text, '') = ''
			and	((coalesce(nr_seq_tipo_avaliacao_w::text, '') = '')or (nr_seq_tipo_avaliacao	= nr_seq_tipo_avaliacao_w));
			if (qt_registros_w	= '0') then
				ds_mensagem_w := ds_mensagem_w||obter_desc_expressao(301485) || '.' ||quebra_w;
				if (nr_seq_tipo_avaliacao_w IS NOT NULL AND nr_seq_tipo_avaliacao_w::text <> '') then
					ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(728760) ||substr(obter_descricao_padrao('MED_TIPO_AVALIACAO','DS_TIPO', NR_SEQ_TIPO_AVALIACAO_w),1,100) ||quebra_w;
				end if;
				ie_inconsistente_w	:= true;
			end if;
		elsif (ie_informacao_w	= 'T') then
			select	count(*)
			into STRICT	qt_registros_w
			from	ehr_registro a,
					ehr_reg_template b
			where	a.nr_sequencia = b.nr_seq_reg
			and		a.nr_atendimento	= nr_atendimento_p
			and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and		coalesce(a.dt_inativacao::text, '') = ''
			and		((b.nr_seq_template = nr_seq_template_w) or (coalesce(nr_seq_template_w::text, '') = ''));

			if (qt_registros_w	= 0) then
				ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(728764) ||quebra_w;
				if (nr_seq_template_w IS NOT NULL AND nr_seq_template_w::text <> '') then
					ds_mensagem_w := ds_mensagem_w|| obter_desc_expressao(728766) ||substr(obter_descricao_padrao('EHR_TEMPLATE','DS_TEMPLATE', nr_seq_template_w),1,100) ||quebra_w;
				end if;
				ie_inconsistente_w	:= true;
			end if;

		end if;
		if (ie_inconsistente_w) and (ie_acao_w	= 'I') then
			ie_acao_p	:= ie_acao_w;
		end if;
		end;
	end loop;
	close C01;
end if;
ds_mensagem_p	:= ds_mensagem_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_regra_inf_agenda ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, ds_mensagem_p INOUT text, ie_acao_p INOUT text) FROM PUBLIC;

