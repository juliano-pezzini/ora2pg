-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE identifica_agenda_retorno ( DT_AGENDA_P timestamp, CD_PESSOA_FISICA_P text, CD_CONVENIO_P bigint, NM_USUARIO_P text, CD_AGENDA_P bigint, NR_SEQ_AGEINT_ITEM_P bigint, DS_RETORNO_P INOUT text, IE_CLASSIF_RETORNO_P INOUT text, NR_ATENDIMENTO_CONSULTA_P INOUT bigint, NR_SEQ_REGRA_MSG_P INOUT bigint, DS_MSG_REGRA_P INOUT text, IE_BLOQ_AGEN_P INOUT text, CD_MEDICO_P text DEFAULT NULL, CD_ESTABELECIMENTO_P bigint DEFAULT NULL) AS $body$
DECLARE


QT_DIA_CONV_W			integer;
NR_SEQ_AGENDA_PAC_W		agenda_paciente.nr_sequencia%type;
NR_SEQ_AGENDA_CONS_W		agenda_consulta.nr_sequencia%type;
NR_SEQ_AGEPAC_EXAME_W		agenda_paciente.nr_sequencia%type;
DT_AGENDA_W			timestamp;
NR_ATENDIMENTO_W		bigint;
QT_DIA_RETORNO_W		bigint;
IE_CLASSIF_AGENDA_W		varchar(5);
IE_TIPO_CLASSIF_W		varchar(1);
IE_CLASSIF_RETORNO_W		varchar(5);

QT_DIA_CONSULTA_W		bigint;
QT_DIA_EXAME_W			bigint;

DS_RETORNO_W			varchar(4000) := '';
NR_SEQ_TIPO_CLASSIF_W		bigint;
DS_PROCEDIMENTO_W		varchar(60);
CD_ESPECIALIDADE_W		integer;
DS_MOTIVO_W			varchar(80);
CD_ESPECIALIDADE_AGENDA_W	integer;
IE_TIPO_ATENDIMENTO_W		smallint;
IE_MESMO_TIPO_ATEND_W		varchar(1);
IE_MESMA_ESPEC_W		varchar(1);
IE_MESMO_CONV_W			varchar(1);
IE_MESMO_PROC_W			varchar(1);
IE_MESMO_MEDICO_W		varchar(1);
DS_CONVENIO_W			varchar(100);
CD_PROCEDIMENTO_W		bigint;
CD_MOTIVO_ALTA_W		integer;
CD_MEDICO_AGENDA_W		varchar(10);
IE_REGRA_AGENDA_W		varchar(1);
IE_MESMO_TIPO_AGENDA_W		varchar(1);
NR_ATENDIMENTO_CONSULTA_W	bigint;
IE_CLASSIF_AGENDA_ITEM_W	varchar(5);
IE_MESMA_AGENDA_W		varchar(1);
DS_MENSAGEM_W			varchar(4000);
NR_SEQ_REGRA_W			bigint;
CD_TIPO_AGENDA_W		bigint;
NR_SEQ_MOTIVO_AGENDAMENTO_W	bigint;
PARAM_396_W			varchar(1);
ie_bloqueia_agendamento_w 	REGRA_ATEND_RETORNO.IE_BLOQUEIA_AGENDAMENTO%type;
ds_mensagem_bloq_w		varchar(255);
ie_bloq_agen_w			varchar(1) := 'N';
ie_mesmo_estab_w 	varchar(1) := 'S';
cd_estabelecimento_w	agenda.cd_estabelecimento%type;
dt_atend_origem_w		atendimento_paciente.dt_entrada%type;
cd_estab_origem_w		atendimento_paciente.cd_estabelecimento%type;
ds_estab_origem_w		varchar(255);
dt_termino_retorno_w		timestamp;
dt_limite_retorno_w		timestamp;
cd_convenio_w       		agenda_integrada.cd_convenio%TYPE;
cd_pessoa_fisica_w  		agenda_integrada.cd_pessoa_fisica%TYPE;



/* obter parametro retorno */

c01 CURSOR FOR
SELECT	coalesce(qt_dia,0),
		ie_mesmo_tipo_atend,
		CASE WHEN ie_regra='E' THEN  'S'  ELSE 'N' END ,
		CASE WHEN coalesce(cd_convenio::text, '') = '' THEN  'N'  ELSE 'S' END ,
		CASE WHEN ie_regra='P' THEN  'S'  ELSE 'N' END ,
		cd_motivo_alta,
		CASE WHEN ie_regra='M' THEN  'S'  ELSE CASE WHEN ie_regra='G' THEN 'S'  ELSE 'N' END  END ,
		ie_regra_agenda,
		coalesce(ie_mesmo_tipo_Agenda,'N'),
		CASE WHEN ie_regra='A' THEN 'S'  ELSE 'N' END ,
		ds_mensagem,
		nr_sequencia,
		coalesce(ie_bloqueia_agendamento,'N'),
		coalesce(IE_MESMO_ESTAB,'S')
from	regra_atend_retorno
where (coalesce(cd_convenio, cd_convenio_w) = cd_convenio_w or coalesce(cd_convenio_w::text, '') = '')
and (coalesce(cd_especialidade_medica,cd_especialidade_agenda_w) = cd_especialidade_agenda_w or coalesce(cd_especialidade_agenda_w::text, '') = '')
and (coalesce(ie_tipo_Atendimento, ie_tipo_atendimento_w) = ie_tipo_atendimento_w or coalesce(ie_tipo_atendimento_w::text, '') = '')
and (coalesce(ie_classif_agenda,ie_classif_agenda_item_w) = ie_classif_agenda_item_w or coalesce(ie_classif_agenda_item_w::text, '') = '')
and	((ie_regra = 'A' AND cd_agenda = cd_agenda_p) or (ie_regra <> 'A'))
and	ie_regra_agenda	in ('A','C','E','G','O')
and (coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p or coalesce(cd_estabelecimento_p::text, '') = '')
and clock_timestamp() between coalesce(dt_inicio_vigencia, clock_timestamp()) and coalesce(dt_fim_vigencia, clock_timestamp())
and coalesce(ie_situacao,'A') = 'A'
order by coalesce(cd_convenio,0),
	 coalesce(cd_agenda,0),
	 qt_dia;

/* Agenda de Exames */

c05 CURSOR FOR
SELECT	coalesce(qt_dia,0),
		ie_mesmo_tipo_atend,
		CASE WHEN ie_regra='E' THEN  'S'  ELSE 'N' END ,
		CASE WHEN coalesce(cd_convenio::text, '') = '' THEN  'N'  ELSE 'S' END ,
		CASE WHEN ie_regra='P' THEN  'S'  ELSE 'N' END ,
		cd_motivo_alta,
		CASE WHEN ie_regra='M' THEN  'S'  ELSE CASE WHEN ie_regra='G' THEN 'S'  ELSE 'N' END  END ,
		ie_regra_agenda,
		coalesce(ie_mesmo_tipo_Agenda,'N'),
		CASE WHEN ie_regra='A' THEN 'S'  ELSE 'N' END ,
		ds_mensagem,
		nr_sequencia,
		nr_seq_motivo_agendamento,
		coalesce(ie_bloqueia_agendamento,'N'),
		coalesce(IE_MESMO_ESTAB,'S')
from	regra_atend_retorno
where (coalesce(cd_convenio, cd_convenio_w) = cd_convenio_w or coalesce(cd_convenio_w::text, '') = '')
and (coalesce(cd_especialidade_medica,cd_especialidade_agenda_w) = cd_especialidade_agenda_w or coalesce(cd_especialidade_agenda_w::text, '') = '')
and (coalesce(ie_tipo_Atendimento, ie_tipo_atendimento_w) = ie_tipo_atendimento_w or coalesce(ie_tipo_atendimento_w::text, '') = '')
and (coalesce(ie_classif_agenda,ie_classif_agenda_item_w) = ie_classif_agenda_item_w or coalesce(ie_classif_agenda_item_w::text, '') = '')
and	ie_regra_agenda	in ('A','E','G')
and (coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p or coalesce(cd_estabelecimento_p::text, '') = '')
and clock_timestamp() between coalesce(dt_inicio_vigencia, clock_timestamp()) and coalesce(dt_fim_vigencia, clock_timestamp())
and coalesce(ie_situacao,'A') = 'A'
order by coalesce(cd_convenio,0),
	 coalesce(cd_agenda,0),
	 qt_dia;

/* obter agenda cirurgia periodo */

c02 CURSOR FOR
SELECT	coalesce(b.nr_sequencia,0)
from	agenda a,
	agenda_paciente b
where	a.cd_tipo_agenda	= 1
and	a.cd_agenda		= b.cd_agenda
and	b.ie_status_agenda	= 'E'
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	((b.cd_convenio = cd_convenio_w) or (ie_mesmo_conv_w = 'N'))
and	((a.cd_especialidade = cd_especialidade_agenda_w) or (ie_mesma_espec_w = 'N'))
and ((a.ie_tipo_atendimento = ie_Tipo_atendimento_w) or (ie_mesmo_tipo_atend_w = 'N'))
and	(((SELECT cd_motivo_alta
	from atendimento_paciente
	where nr_atendimento = b.nr_atendimento) = cd_motivo_alta_w) or (coalesce(cd_motivo_alta_w::text, '') = ''))
and	b.hr_inicio		>= dt_agenda_p - qt_dia_conv_w
order by
	b.hr_inicio;

/* obter agenda consulta periodo */

c03 CURSOR FOR
SELECT	coalesce(b.nr_sequencia,0)
from	agenda a,
	agenda_consulta b
where	a.cd_tipo_agenda	= 3
and	((ie_mesmo_estab_w = 'N' and a.cd_estabelecimento = cd_estabelecimento_w) or ie_mesmo_estab_w = 'S')
and	a.cd_agenda		= b.cd_agenda
and	b.ie_status_agenda	= 'E'
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	b.dt_agenda		>= dt_agenda_p - qt_dia_conv_w
and	((b.cd_convenio = cd_convenio_w) or (ie_mesmo_conv_w = 'N'))
--and	((a.cd_pessoa_fisica = cd_medico_agenda_w) or (ie_mesmo_medico_w = 'N'))
AND	(((PARAM_396_W = 'N' AND (A.CD_PESSOA_FISICA = CD_MEDICO_AGENDA_W))
	OR (PARAM_396_W = 'S' AND (coalesce(CD_MEDICO_P,CD_MEDICO_AGENDA_W) = B.CD_MEDICO_REQ)))
		OR (IE_MESMO_MEDICO_W = 'N'))
and	((a.cd_especialidade = cd_especialidade_agenda_w) or (ie_mesma_espec_w = 'N') or (coalesce(a.cd_especialidade::text, '') = ''))
and ((a.ie_tipo_atendimento = ie_Tipo_atendimento_w) or (ie_mesmo_tipo_atend_w = 'N') or (coalesce(a.ie_tipo_atendimento::text, '') = ''))
and	((ie_mesma_agenda_w = 'S' AND a.cd_agenda = cd_agenda_p) or (ie_mesma_agenda_w = 'N'))
and	obter_tipo_classif_agecons(ie_classif_agenda) = 'C'
and	(((SELECT cd_motivo_alta
	from atendimento_paciente
	where nr_atendimento = b.nr_atendimento) = cd_motivo_alta_w) or (coalesce(cd_motivo_alta_w::text, '') = ''))
order by
	b.dt_agenda;

/* obter agenda exame periodo */

c04 CURSOR FOR
SELECT	coalesce(b.nr_sequencia,0)
from	agenda a,
	agenda_paciente b
where	a.cd_tipo_agenda	= 2
and	((ie_mesmo_estab_w = 'N' and a.cd_estabelecimento = cd_estabelecimento_w) or ie_mesmo_estab_w = 'S')
and	a.cd_agenda		= b.cd_agenda
and	b.ie_status_agenda	= 'E'
and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
and	((b.cd_convenio = cd_convenio_w) or (ie_mesmo_conv_w = 'N'))
and	((a.cd_especialidade = cd_especialidade_agenda_w) or (ie_mesma_espec_w = 'N'))
and ((a.ie_tipo_atendimento = ie_Tipo_atendimento_w) or (ie_mesmo_tipo_atend_w = 'N'))
and 	((b.cd_procedimento = cd_procedimento_w) or (ie_mesmo_proc_w = 'N'))
and	((b.nr_seq_motivo_agendamento = nr_seq_motivo_agendamento_w) or (coalesce(nr_seq_motivo_agendamento_w::text, '') = ''))
and	b.hr_inicio		>= dt_agenda_p - qt_dia_conv_w
and	(((SELECT cd_motivo_alta
	from atendimento_paciente
	where nr_atendimento = b.nr_atendimento) = cd_motivo_alta_w) or (coalesce(cd_motivo_alta_w::text, '') = ''))
order by
	b.hr_inicio;


BEGIN

if (coalesce(cd_pessoa_fisica_p,0) > 0) then
    cd_pessoa_fisica_w := cd_pessoa_fisica_p;
else
  if (nr_seq_ageint_item_p IS NOT NULL AND nr_seq_ageint_item_p::text <> '') then
    select  max(a.cd_pessoa_fisica), max(a.cd_convenio)
    into STRICT    cd_pessoa_fisica_w,
            cd_convenio_w
    from    agenda_integrada a, 
            agenda_integrada_item b 
    where   a.nr_sequencia = b.nr_seq_agenda_int
    and     b.nr_sequencia = nr_seq_ageint_item_p;
  end if;
end if;

if (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
	
	if (coalesce(cd_convenio_p,0) > 0) then
		cd_convenio_w := cd_convenio_p;
	end if;

	if (nr_seq_ageint_item_p IS NOT NULL AND nr_seq_ageint_item_p::text <> '') then
		select	max(ie_classif_agenda)
		into STRICT	ie_classif_agenda_item_w
		from	agenda_integrada_item
		where	nr_sequencia = nr_seq_ageint_item_p;
	else
		ie_classif_agenda_item_w := '';
	end if;

	/* obter periodo retorno agenda consulta */

	select	CASE WHEN max(obter_valor_param_usuario(898, 80, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento))=0 THEN  max(obter_valor_param_usuario(821, 61, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento))  ELSE max(obter_valor_param_usuario(898, 80, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)) END ,
		coalesce(max(obter_valor_param_usuario(820, 56, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)),0)
	into STRICT	qt_dia_consulta_w,
		qt_dia_exame_w
	;

	select	max(a.ie_tipo_atendimento),
			max(a.cd_especialidade),
			max(a.cd_pessoa_fisica),
		max(cd_tipo_agenda),
		max(cd_Estabelecimento)
	into STRICT	ie_tipo_atendimento_w,
		cd_especialidade_agenda_w,
		cd_medico_agenda_w,
		cd_tipo_agenda_w,
		cd_estabelecimento_w
	from	agenda a
	where	a.cd_agenda = cd_agenda_p;

	PARAM_396_W := OBTER_VALOR_PARAM_USUARIO(869, 396, WHEB_USUARIO_PCK.GET_CD_PERFIL, NM_USUARIO_P, WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO);

	if (cd_tipo_agenda_w = 2) then
				/* obter periodo retorno convenio  e especialidade regra*/

		open c05;
		loop
		fetch c05 into	qt_dia_conv_w,
						ie_mesmo_tipo_atend_w,
						ie_mesma_espec_w,
						ie_mesmo_conv_w,
						ie_mesmo_proc_w,
						cd_motivo_alta_w,
						ie_mesmo_medico_w,
						ie_regra_Agenda_w,
						ie_mesmo_tipo_Agenda_w,
						ie_mesma_agenda_w,
						ds_mensagem_w,
						nr_seq_regra_w,
						nr_seq_motivo_agendamento_w,
						ie_bloqueia_agendamento_w,
						ie_mesmo_estab_w;
			EXIT WHEN NOT FOUND; /* apply on c05 */
		end loop;
		close c05;

	else
		
		/* obter periodo retorno convenio  e especialidade regra*/

		open c01;
		loop
		fetch c01 into	qt_dia_conv_w,
						ie_mesmo_tipo_atend_w,
						ie_mesma_espec_w,
						ie_mesmo_conv_w,
						ie_mesmo_proc_w,
						cd_motivo_alta_w,
						ie_mesmo_medico_w,
						ie_regra_Agenda_w,
						ie_mesmo_tipo_Agenda_w,
						ie_mesma_agenda_w,
						ds_mensagem_w,
						nr_seq_regra_w,
						ie_bloqueia_agendamento_w,
						ie_mesmo_estab_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
		end loop;
		close c01;
	end if;

	if (coalesce(qt_dia_conv_w,0) > 0) then
		/* obter agenda cirurgia retorno */

		if (ie_mesmo_tipo_Agenda_w	= 'N') or (ie_mesmo_tipo_Agenda_w	= 'S' and (ie_regra_Agenda_w	= 'A' or
			ie_regra_Agenda_w	= 'R' or
			ie_regra_Agenda_w	= 'G' )) then
			open c02;
			loop
			fetch c02 into	nr_seq_agenda_pac_w;
				EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				nr_seq_agenda_pac_w	:= nr_seq_agenda_pac_w;
				end;
			end loop;
			close c02;
		end if;
		/* obter agenda consulta retorno */

		if (ie_mesmo_tipo_Agenda_w	= 'N') or (ie_mesmo_tipo_Agenda_w	= 'S' and (ie_regra_Agenda_w	= 'A' or
			ie_regra_Agenda_w	= 'C' or
			ie_regra_Agenda_w	= 'O' or
			ie_regra_Agenda_w	= 'G' )) then
			
			if (ie_mesma_agenda_w = 'S') or (qt_dia_consulta_w = -1) then
				qt_dia_consulta_w := qt_dia_conv_w;
			end if;
			
			open c03;
			loop
			fetch c03 into	nr_seq_agenda_cons_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
				nr_seq_agenda_cons_w	:= nr_seq_agenda_cons_w;
				end;
			end loop;
			close c03;
		end if;

		/* obter agenda exame retorno */

		if (ie_mesmo_tipo_Agenda_w	= 'N') or (ie_mesmo_tipo_Agenda_w	= 'S' and (ie_regra_Agenda_w	= 'A' or
			ie_regra_Agenda_w	= 'E' or
			ie_regra_Agenda_w	= 'G' )) then
			open c04;
			loop
			fetch c04 into	nr_seq_agepac_exame_w;
				EXIT WHEN NOT FOUND; /* apply on c04 */
				begin
				nr_seq_agepac_exame_w	:= nr_seq_agepac_exame_w;
				end;
			end loop;
			close c04;
		end if;

		/* obter dados agenda cirurgia retorno */

		if (coalesce(nr_seq_agenda_pac_w,0) > 0) then
			select	hr_inicio,
				nr_atendimento,
				substr(obter_exame_agenda(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,60),
				substr(obter_motivo_alta_atend(nr_atendimento), 1, 80)
			into STRICT	dt_agenda_w,
				nr_atendimento_w,
				ds_procedimento_w,
				ds_motivo_w
			from	agenda_paciente
			where	nr_sequencia	= nr_seq_agenda_pac_w;

			/* obter periodo retorno agenda cirurgia */

			qt_dia_retorno_w	:= trunc(trunc(dt_agenda_p) - trunc(dt_agenda_w));

			select	CASE WHEN coalesce(cd_convenio_w::text, '') = '' THEN ''  ELSE substr(obter_nome_convenio(cd_convenio_w),1,40) END
			into STRICT	ds_convenio_w
			;

			/* identificar retorno agenda cirurgia */

			if (coalesce(qt_dia_retorno_w,0) = 1) then
				ds_retorno_w	:=	SUBSTR(obter_desc_expressao(754388)||CHR(13)||CHR(10)||
							obter_desc_expressao(326148) || ds_convenio_w				||CHR(13)||CHR(10)||
							obter_desc_expressao(327180) || ':' || qt_dia_conv_w || ' ' || obter_desc_expressao(326603) ||CHR(13)||CHR(10)||
							obter_desc_expressao(622368) || to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi:ss')	||CHR(13)||CHR(10)||
							obter_desc_expressao(622226) || ds_procedimento_w 				||CHR(13)||CHR(10)||
							obter_desc_expressao(344885) || nr_atendimento_w				||CHR(13)||CHR(10)||
							obter_desc_expressao(293485) || ':' || ds_motivo_w					||CHR(13)||CHR(10)||
							obter_desc_expressao(622367) || substr(obter_dados_agendas(1,nr_seq_agenda_pac_w,'NM'),1,60),1,255);
				ie_classif_retorno_w	:=	'U';
			elsif (coalesce(qt_dia_retorno_w,0) > 1) then
				ds_retorno_w	:=	SUBSTR(obter_desc_expressao(754390)||CHR(13)||CHR(10)||
							obter_desc_expressao(326148) || ds_convenio_w				||CHR(13)||CHR(10)||
							obter_desc_expressao(327180) || ':' || qt_dia_conv_w || ' ' || obter_desc_expressao(326603) ||CHR(13)||CHR(10)||
							obter_desc_expressao(622368) || ':' || to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi:ss')	||CHR(13)||CHR(10)||
							obter_desc_expressao(622226) || ds_procedimento_w 				||CHR(13)||CHR(10)||
							obter_desc_expressao(344885) || nr_atendimento_w				||CHR(13)||CHR(10)||
							obter_desc_expressao(293485) || ':' || ds_motivo_w					||CHR(13)||CHR(10)||
							obter_desc_expressao(622367) || substr(obter_dados_agendas(1,nr_seq_agenda_pac_w,'NM'),1,60),1,255);
				if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
					nr_seq_regra_msg_p := nr_seq_regra_w;
				end if;
				ie_classif_retorno_w	:=	'R';
			end if;
		end if;
			/* obter dados agenda consulta retorno */

		if (coalesce(nr_seq_agenda_cons_w,0) > 0) then
			select	dt_agenda,
				nr_atendimento,
				ie_classif_agenda,
				substr(obter_motivo_alta_atend(nr_atendimento), 1, 80)
			into STRICT	dt_agenda_w,
				nr_atendimento_consulta_w,
				ie_classif_agenda_w,
				ds_motivo_w
			from	agenda_consulta
			where	nr_sequencia	= nr_seq_agenda_cons_w;


			/* obter periodo retorno agenda consulta */

			qt_dia_retorno_w	:= trunc(trunc(dt_agenda_p) - trunc(dt_agenda_w));
			/* obter tipo classificacao agenda consulta */


			/* Rafael em 30/09/2006 OS39055 conforme historico de 29/09/2006 11:18:50
			select	max(ie_tipo_classif)
			into	ie_tipo_classif_w
			from	agenda_classif
			where	cd_classificacao	= ie_classif_agenda_w; */
			if (nr_atendimento_consulta_w IS NOT NULL AND nr_atendimento_consulta_w::text <> '') then
				begin
					select dt_entrada,
						cd_estabelecimento
					into STRICT dt_atend_origem_w,
						cd_estab_origem_w
					from atendimento_paciente
					where nr_atendimento = nr_atendimento_consulta_w;
				exception
				when others then
					dt_atend_origem_w := '';
					cd_estab_origem_w := '';
				end;
			
				if (cd_estab_origem_w IS NOT NULL AND cd_estab_origem_w::text <> '') then
					begin
						select  substr(obter_dados_estab(cd_estab_origem_w,1),1,255)
						into STRICT ds_estab_origem_w
						;
					exception
					when others then
						ds_estab_origem_w := '';
					end;
					
				end if;
				
				if (dt_atend_origem_w IS NOT NULL AND dt_atend_origem_w::text <> '') then
					dt_limite_retorno_w := trunc(dt_atend_origem_w) + coalesce(qt_dia_conv_w, 0) + 86399/86400;
				end if;
			end if;

			select	CASE WHEN coalesce(cd_convenio_w::text, '') = '' THEN ''  ELSE substr(obter_nome_convenio(cd_convenio_w),1,40) END
			into STRICT	ds_convenio_w
			;


			/* identificar retorno agenda consulta */


			/* if	(ie_tipo_classif_w = 'C') then */

			if (coalesce(qt_dia_retorno_w,0) <= qt_dia_consulta_w) then
				if (ie_bloqueia_agendamento_w = 'N') then
					ds_mensagem_bloq_w :=obter_desc_expressao(754392);
				else
					ie_bloq_agen_w := 'S';
					ds_mensagem_bloq_w :=obter_desc_expressao(763629);
				end if;

				ds_retorno_w	:=	SUBSTR(ds_mensagem_bloq_w||CHR(13)||CHR(10)||
							obter_desc_expressao(696048) || ': ' || ds_convenio_w						||CHR(13)||CHR(10)||
							obter_desc_expressao(327180) || ': ' || qt_dia_conv_w || ' ' || obter_desc_expressao(326603) 	||CHR(13)||CHR(10)||
							obter_desc_expressao(286532) || ': ' || to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi:ss')			||CHR(13)||CHR(10)||
							obter_desc_expressao(283863) || ': ' || nr_atendimento_consulta_w					||CHR(13)||CHR(10)||
							obter_desc_expressao(293090) || ': ' || substr(obter_dados_agendas(3,nr_seq_agenda_cons_w,'NM'),1,60)||CHR(13)||CHR(10)||
							obter_desc_expressao(293485) || ': ' || ds_motivo_w							||CHR(13)||CHR(10)||
							obter_desc_expressao(720315) || ': ' || substr(obter_dados_agendas(3,nr_seq_agenda_cons_w,'CL'),1,40) ||' $@$ ' ||CHR(13)||CHR(10)||
							obter_desc_expressao(874425) || ': ' || to_char(dt_atend_origem_w,'dd/mm/yyyy hh24:mi:ss')		||CHR(13)||CHR(10)||
							obter_desc_expressao(1032448) || ' ' || ds_estab_origem_w					||CHR(13)||CHR(10)||
							obter_desc_expressao(1032452) || ' ' || to_char(dt_limite_retorno_w,'dd/mm/yyyy hh24:mi:ss'),1,4000);
				if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
					nr_seq_regra_msg_p := nr_seq_regra_w;
				end if;
				ie_classif_retorno_w		:= 'R';
				nr_atendimento_consulta_p	:= nr_atendimento_consulta_w;
			end if;
		end if;
			/* end if; */


			/* obter dados agenda exame retorno */

		if (coalesce(nr_seq_agepac_exame_w,0) > 0) then
			begin
			select	hr_inicio,
				nr_atendimento,
				substr(obter_exame_agenda(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,60),
				substr(obter_motivo_alta_atend(nr_atendimento), 1, 80),
				coalesce(cd_procedimento,0)
			into STRICT	dt_agenda_w,
				nr_atendimento_w,
				ds_procedimento_w,
				ds_motivo_w,
				cd_procedimento_w
			from	agenda_paciente
			where	nr_sequencia	= nr_seq_agepac_exame_w;

			/* obter periodo retorno agenda consulta */

			qt_dia_retorno_w	:= trunc(trunc(dt_agenda_p) - trunc(dt_agenda_w));

			select	max(nr_sequencia)
			into STRICT	nr_seq_tipo_classif_w
			from	agenda_paciente_classif
			where	ie_tipo_classif = 'X';
			
			if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
				begin
					select dt_entrada,
						cd_estabelecimento
					into STRICT dt_atend_origem_w,
						cd_estab_origem_w
					from atendimento_paciente
					where nr_atendimento = nr_atendimento_w;
				exception
				when others then
					dt_atend_origem_w := '';
					cd_estab_origem_w := '';
				end;
				
				if (cd_estab_origem_w IS NOT NULL AND cd_estab_origem_w::text <> '') then
					begin
						select  substr(obter_dados_estab(cd_estab_origem_w,1),1,255)
						into STRICT ds_estab_origem_w
						;
					exception
					when others then
						ds_estab_origem_w := '';
					end;
				end if;
				
				if (dt_atend_origem_w IS NOT NULL AND dt_atend_origem_w::text <> '') then
					dt_limite_retorno_w := trunc(dt_atend_origem_w) + coalesce(qt_dia_conv_w, 0) + 86399/86400;
				end if;
			end if;

			select	CASE WHEN coalesce(cd_convenio_w::text, '') = '' THEN ''  ELSE substr(obter_nome_convenio(cd_convenio_w),1,40) END
			into STRICT	ds_convenio_w
			;

			if (coalesce(qt_dia_retorno_w,0) <= qt_dia_exame_w) then
				begin
				if (ie_bloqueia_agendamento_w = 'N') then
					ds_mensagem_bloq_w :=obter_desc_expressao(754392);
				else
					ie_bloq_agen_w := 'S';
					ds_mensagem_bloq_w :=obter_desc_expressao(763629);
				end if;
				ds_retorno_w	:=	substr(ds_mensagem_bloq_w ||CHR(13)||CHR(10)||
							obter_desc_expressao(696048) || ': ' || ds_convenio_w				||CHR(13)||CHR(10)||
							obter_desc_expressao(327180) || ': ' || qt_dia_conv_w || ' ' || obter_desc_expressao(326603) ||CHR(13)||CHR(10)||
							obter_desc_expressao(286532) || ': ' || to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi:ss')	||CHR(13)||CHR(10)||
							obter_desc_expressao(296422) || ': ' || ds_procedimento_w 				||CHR(13)||CHR(10)||
							obter_desc_expressao(283863) || ': ' || nr_atendimento_w				||CHR(13)||CHR(10)||
							obter_desc_expressao(293485) || ': ' || ds_motivo_w					||CHR(13)||CHR(10)||
							obter_desc_expressao(293090) || ': ' || substr(obter_dados_agendas(1,nr_seq_agepac_exame_w,'NM'),1,60) ||' $@$ '	||CHR(13)||CHR(10)||
							obter_desc_expressao(874425) || ': ' || to_char(dt_atend_origem_w,'dd/mm/yyyy hh24:mi:ss')		||CHR(13)||CHR(10)||
							obter_desc_expressao(1032448) || ' ' || ds_estab_origem_w					||CHR(13)||CHR(10)||
							obter_desc_expressao(1032452) || ' ' || to_char(dt_limite_retorno_w,'dd/mm/yyyy hh24:mi:ss'),1,4000);
				ie_classif_retorno_p	:= nr_seq_tipo_classif_w;
				ie_classif_retorno_w	:= '';
				end;
			end if;
			end;
		end if;
	end if;

	/* gerar retorno agenda */

	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		begin
			ds_retorno_p	:= replace(ds_retorno_w,' $@$ ','');
		exception when data_exception then
			ds_retorno_p := substr(substr(ds_retorno_w,1,position('$@$' in ds_retorno_w)-1),1,255);
		end;
		
		if (ie_classif_retorno_w = 'R') then
			select	max(cd_classificacao)
			into STRICT	ie_classif_retorno_p
			from	agenda_classif
			where	cd_classif_tasy	= 'R'
			and	ie_tipo_classif	= ie_classif_retorno_w
			and	ie_agenda		in ('A','C')
			and	ie_situacao		= 'A'
			and	dt_atualizacao  	=	(	SELECT	max(dt_atualizacao)
								from	agenda_classif
								where	cd_classif_tasy	= 'R'
								and	ie_tipo_classif	= ie_classif_retorno_w
								and	ie_agenda		in ('A','C')
								and	ie_situacao		= 'A');
		elsif (ie_classif_retorno_w = 'U') then
			select	max(cd_classificacao)
			into STRICT	ie_classif_retorno_p
			from	agenda_classif
			where	cd_classif_tasy	= 'RC'
			and	ie_tipo_classif	= ie_classif_retorno_w
			and	ie_agenda		in ('A','C')
			and	ie_situacao		= 'A'
			and	dt_atualizacao  	=	(	SELECT	max(dt_atualizacao)
								from	agenda_classif
								where	cd_classif_tasy	= 'RC'
								and	ie_tipo_classif	= ie_classif_retorno_w
								and	ie_agenda		in ('A','C')
								and	ie_situacao		= 'A');

		end if;
	end if;

	if (nr_seq_regra_msg_p > 0) then
		begin
		select	substr(max(ds_mensagem), 1, 255) ds_mensagem
		into STRICT	ds_msg_regra_p
		from	regra_atend_retorno
		where	nr_sequencia = nr_seq_regra_msg_p;
		end;
	end if;

	if (ie_bloqueia_agendamento_w = 'S' and obter_funcao_ativa in (869,820,821) ) then
		nr_seq_regra_msg_p := nr_seq_regra_w;
	end if;

	ie_bloq_agen_p := ie_bloq_agen_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE identifica_agenda_retorno ( DT_AGENDA_P timestamp, CD_PESSOA_FISICA_P text, CD_CONVENIO_P bigint, NM_USUARIO_P text, CD_AGENDA_P bigint, NR_SEQ_AGEINT_ITEM_P bigint, DS_RETORNO_P INOUT text, IE_CLASSIF_RETORNO_P INOUT text, NR_ATENDIMENTO_CONSULTA_P INOUT bigint, NR_SEQ_REGRA_MSG_P INOUT bigint, DS_MSG_REGRA_P INOUT text, IE_BLOQ_AGEN_P INOUT text, CD_MEDICO_P text DEFAULT NULL, CD_ESTABELECIMENTO_P bigint DEFAULT NULL) FROM PUBLIC;
