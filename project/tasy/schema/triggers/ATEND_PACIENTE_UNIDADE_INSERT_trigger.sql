-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_paciente_unidade_insert ON atend_paciente_unidade CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_paciente_unidade_insert() RETURNS trigger AS $BODY$
DECLARE
dt_entrada_w			timestamp;
ie_data_futura_w			varchar(1) := 'S';
nr_ramal_w			varchar(5);
qt_existe_tel_w			smallint;
cd_pessoa_fisica_w		varchar(10);
ie_transfere_prontuario_w		varchar(1);
qt_agenda_w			integer;
cd_agenda_w			bigint := null;
/* Rafael em 8/9/2007 OS68015 */


nr_prontuario_w			bigint;
cd_estabelecimento_w		smallint;
cd_estab_atend_w			bigint;
ie_tipo_atendimento_w		smallint;
ie_clinica_w			integer;
ie_prontuario_w			varchar(1);
ie_forma_gerar_w		varchar(1);
ie_consiste_alta_adep_w		varchar(1);
ie_gerar_pront_w		varchar(1) := 'N';
IE_GERAR_PASSAGEM_ALTA_w	varchar(1) := 'S';
dt_alta_w				timestamp;
nr_seq_evento_w			bigint;
ie_tipo_convenio_w			smallint;
cd_classif_setor_w			varchar(2);
QT_PAC_UNIDADE_w		smallint;
qt_em_unidade_w			smallint;
nr_seq_interno_unidade_w		bigint;
ie_permite_passagem_sus_w		varchar(1) := 'S';
qt_idade_w			bigint;
NR_SEQ_LOCAL_PA_w		bigint;
ie_adic_pac_leito_agrup_w	varchar(1);
ie_isol_agrup_w			varchar(1);
nr_agrupamento_w		integer;
ie_permite_menor_dt_entrada_w	varchar(1);
nr_atendimento_w		bigint;
ie_tipo_convenio_ant_w		smallint;
nr_seq_queixa_ant_w		bigint;
ie_bloqueia_atendimento_w	varchar(1);
ds_mensagem_w			varchar(255);
cd_convenio_w			bigint;
cd_categoria_w			varchar(10);
cd_plano_w			varchar(10);
nr_seq_classificacao_w		bigint;
cd_procedencia_w		bigint;
nr_seq_tipo_acidente_w		bigint;
nr_seq_queixa_w			bigint;
cd_empresa_cat_w		bigint;
nr_seq_cobertura_w		bigint;
cd_tipo_acomodacao_w		bigint;
ie_consiste_regra_conv_w	varchar(1);
ie_integracao_epimed_w		integer;
ie_integracao_dynamics_w	varchar(1);
ie_integracao_aghos_w		varchar(1);
nr_seq_atepacu_w		bigint;
nr_internacao_w			bigint;
ds_sqlerror_w			varchar(2000);
ds_erro_aghos_w			varchar(2000);
ie_mostrar_erro_aghos_w		varchar(1);
ie_bloq_unid_ant_w		varchar(1);
nr_seq_unidade_new_w	bigint;
nr_seq_regra_princ_w		bigint;
nr_seq_regra_sec_w		bigint;
qt_regra_w			bigint;
ie_regra_excecao_w		varchar(1);
idf_internacao_w		smallint;
cod_posto_enfermagem_w	varchar(1);
cod_enfermaria_w		varchar(1);
cod_leito_w				varchar(1);
cod_digito_leito_w		varchar(1);
des_usuario_w			varchar(1);
ie_existe_w			varchar(1) := 'N';
nr_seq_empresa_w		empresa_integracao.nr_sequencia%type;
ds_param_integ_hl7_w		varchar(4000) := '';
ie_permite_intern_desfecho_w	varchar(1);
ie_existe_desfecho_w		smallint;
ie_considera_tipo_acomod_w	varchar(1);
ie_retaguarda_atual_w		varchar(1);
ie_status_w			varchar(1);
ie_permite_data_menor_w			varchar(1);
ie_altera_data_acomodacao_w	varchar(1);
ie_aceita_outpatient_w varchar(02);
ie_encounter_outpatient_w varchar(02);
unidade_atendimento_row_w   unidade_atendimento%rowtype;
unidade_atendimento2_row_w   unidade_atendimento%rowtype;
ds_leito_w					varchar(10);

ie_setor_athena_w				varchar(1) := 'N';

/* Fim Rafael em 8/9/2007 OS68015 */



C02 CURSOR FOR
	SELECT	a.nr_seq_evento
	from	regra_envio_sms a
	where	a.cd_estabelecimento	= cd_estabelecimento_w
	and	a.ie_evento_disp	= 'ECC'
	and	coalesce(NEW.IE_PASSAGEM_SETOR,'N') = 'S'
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)
	and	exists (SELECT	1
		from	setor_atendimento x
		where	x.cd_setor_atendimento		= NEW.cd_setor_atendimento
		and	x.cd_classif_setor		= 2)
	and	dt_alta_w is null
	and	coalesce(a.ie_situacao,'A') = 'A';

C03 CURSOR FOR
	SELECT	a.nr_seq_evento
	from	regra_envio_sms a
	where	a.cd_estabelecimento	= cd_estabelecimento_w
	and	a.ie_evento_disp	= 'T'
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)
	and (obter_se_convenio_rec_alerta(cd_convenio_w,nr_sequencia) = 'S')
	and	coalesce(NEW.IE_PASSAGEM_SETOR,'N') = 'S'
	and	exists (SELECT	1
		from	setor_atendimento x
		where	x.cd_setor_atendimento		= NEW.cd_setor_atendimento
		and	x.cd_classif_setor		in (3,4))
	and	dt_alta_w is null
	and	coalesce(a.ie_situacao,'A') = 'A';

C04 CURSOR FOR
        SELECT  a.nr_seq_evento
        from    regra_envio_sms a
        where   a.cd_estabelecimento    = cd_estabelecimento_w
        and     a.ie_evento_disp        = 'AAH'
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)
        and     ie_tipo_atendimento_w   = 8
        and     exists (SELECT 1
                        from    setor_atendimento x
                        where   x.cd_setor_atendimento          = NEW.cd_setor_atendimento
                        and     x.cd_classif_setor              = 3)
	and	dt_alta_w is null
	and	coalesce(a.ie_situacao,'A') = 'A';

C05 CURSOR FOR
	SELECT	coalesce(ie_excecao,'N')
	from	regra_prontuario
	where	cd_estabelecimento					= cd_estabelecimento_w
	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)		= ie_tipo_atendimento_w
	and	coalesce(ie_clinica,ie_clinica_w)				= ie_clinica_w
	and	coalesce(cd_setor_atendimento,NEW.cd_setor_atendimento)	= NEW.cd_setor_atendimento
	and	ie_tipo_regra						= 2
	order by coalesce(cd_setor_atendimento,0), coalesce(ie_clinica,0),coalesce(ie_tipo_atendimento,0);
	
locked_records CURSOR FOR
	SELECT *
	from 	unidade_atendimento unat
	where 	unat.cd_unidade_basica 	= NEW.cd_unidade_basica
	and 	unat.cd_setor_atendimento 	= NEW.cd_setor_atendimento
	and 	(((substr(obter_se_sem_acomodacao(unat.cd_tipo_acomodacao),1,1) = 'N') and (ie_considera_tipo_acomod_w = 'S')) or
			((ie_considera_tipo_acomod_w = 'N') and (obter_classif_setor(unat.cd_setor_atendimento) in (3,4,11,12))))
	for update;
	
locked_records_2 CURSOR FOR
	SELECT *
	from 	unidade_atendimento
	where 	nr_seq_interno in (NEW.nr_seq_unid_ant, nr_seq_unidade_new_w)
	for update;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'N') then
    goto final;
end if;

if (NEW.cd_departamento = 0) then
	NEW.cd_departamento := null;
end if;

  select coalesce(max(a.ie_aceita_outpatient), 'N')
	into STRICT ie_aceita_outpatient_w
	from departamento_medico a
	where a.cd_departamento = NEW.cd_departamento;

	select
	 case
	   WHEN ie_tipo_atendimento <> 1 THEN 'S'
	   WHEN ie_tipo_atendimento =  1 THEN 'N'
	    ELSE 'N'
	 end INTO STRICT ie_encounter_outpatient_w
	from atendimento_paciente
	where nr_atendimento = NEW.nr_atendimento;

	if (coalesce(NEW.cd_departamento ,0) <> 0) then
		if (ie_aceita_outpatient_w = 'N' AND ie_encounter_outpatient_w = 'S') then
       CALL wheb_mensagem_pck.exibir_mensagem_abort(997502);
    end if;
	end if;

NEW.cd_procedencia_atend := obter_procedencia_atend(NEW.nr_atendimento, 'C');

ie_permite_data_menor_w := Obter_Param_Usuario(916, 662, Obter_perfil_Ativo, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_data_menor_w);

select	coalesce(max(obter_valor_param_usuario(44,167, Obter_perfil_ativo, NEW.nm_usuario, 0)),'S')
into STRICT	ie_adic_pac_leito_agrup_w
;

ie_consiste_alta_adep_w	:= 'S';
if (obter_funcao_ativa = 1113) then
	select	coalesce(max(obter_valor_param_usuario(1113,490, Obter_perfil_ativo, NEW.nm_usuario, 0)),'S')
	into STRICT	ie_consiste_alta_adep_w
	;
elsif (obter_funcao_ativa = 924) then
	select	coalesce(max(obter_valor_param_usuario(924,994, Obter_perfil_ativo, NEW.nm_usuario, 0)),'S')
	into STRICT	ie_consiste_alta_adep_w
	;
end if;

if (NEW.dt_saida_unidade is not null) and (NEW.dt_entrada_unidade is not null) and (NEW.dt_entrada_unidade > NEW.dt_saida_unidade) then
	--A data de saida da unidade nao pode ser menor que a data de entrada.

	--Data saida: '||to_char(:new.dt_saida_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data entrada: '||to_char(:new.dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss') || '');

	CALL wheb_mensagem_pck.exibir_mensagem_abort(179690, 'DT_SAIDA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_saida_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
							'DT_ENTRADA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_entrada_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
end if;

select	dt_entrada,
	cd_pessoa_fisica,
	cd_estabelecimento,
	dt_alta,
	ie_tipo_convenio
into STRICT	dt_entrada_w,
	cd_pessoa_fisica_w,
	cd_estab_atend_w,
	dt_alta_w,
	ie_tipo_convenio_w
from	atendimento_paciente
where	nr_atendimento = NEW.nr_atendimento;

qt_idade_w	:= coalesce(obter_idade_pf(cd_pessoa_fisica_w,LOCALTIMESTAMP,'A'),0);
select	coalesce(max(IE_GERAR_PASSAGEM_ALTA), 'S'),
		coalesce(max(ie_permite_passagem_sus),'S'),
		coalesce(max(ie_considera_tipo_acomod),'N')
into STRICT	ie_gerar_passagem_alta_w,
		ie_permite_passagem_sus_w,
		ie_considera_tipo_acomod_w
from	parametro_atendimento
where	cd_estabelecimento		= cd_estab_atend_w;

if (ie_gerar_passagem_alta_w = 'N') and (dt_alta_w is not null) and (ie_consiste_alta_adep_w = 'S') and (NEW.dt_entrada_unidade > dt_alta_w) then
	--'A data de entrada da unidade nao pode ser maior que a data da alta. Verifique os parametros de atendimento. ');

	CALL wheb_mensagem_pck.exibir_mensagem_abort(179694);
end if;

if (dt_entrada_w < LOCALTIMESTAMP and coalesce(pkg_i18n.get_user_locale,'pt_BR') not in ('de_DE', 'de_AT')) then
	if (NEW.dt_saida_unidade is not null) and
		(NEW.dt_saida_unidade > (LOCALTIMESTAMP + interval '30 days'/86400)) then
		--'A data de saida da unidade nao pode ser maior que a data atual.

		--Data saida: '||to_char(:new.dt_saida_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data atual: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || '');

		CALL wheb_mensagem_pck.exibir_mensagem_abort(179695, 'DT_SAIDA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_saida_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
								'DT_ATUAL='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(LOCALTIMESTAMP, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
	end if;

	if (NEW.dt_entrada_unidade is not null) and
		(NEW.dt_entrada_unidade > (LOCALTIMESTAMP + interval '30 days'/86400)) then
		--'A data de entrada na unidade nao pode ser maior que a data atual.

	--	Data entrada: '||to_char(:new.dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data atual: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')|| '');

		CALL wheb_mensagem_pck.exibir_mensagem_abort(379552, 'DT_ENTRADA_UNIDADE='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_entrada_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
								'DT_ATUAL='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(LOCALTIMESTAMP, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
	end if;
	if (ie_tipo_convenio_w <> 3) or (ie_permite_passagem_sus_w = 'N') then -- Edgar 10/01/2005 OS 14154, Nao fazer esta consistencias qdo for SUS por causa da internacao BPA
		if (dt_entrada_w > NEW.dt_entrada_unidade) and (ie_permite_data_menor_w = 'N') then
			--'A data de entrada na unidade nao pode ser menor que a data de inicio do atendimento.

			--Data entrada: '||to_char(:new.dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data inicio atendimento: '||to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss')|| '');

			CALL wheb_mensagem_pck.exibir_mensagem_abort(179699, 'DT_SAIDA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_entrada_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
								'DT_ATUAL='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone) );
		elsif (dt_entrada_w > NEW.dt_saida_unidade) and (ie_permite_data_menor_w = 'N') then
			--'A data de saida da unidade nao pode ser menor que a data de inicio do atendimento.

			--Data saida: '||to_char(:new.dt_saida_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data inicio atendimento: '||to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss')|| '');

			CALL wheb_mensagem_pck.exibir_mensagem_abort(179703, 'DT_SAIDA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_saida_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
								'DT_ATUAL='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone) );
		end if;
	end if;
end if;

if (NEW.dt_entrada_unidade	< dt_entrada_w) and (dt_entrada_w < LOCALTIMESTAMP) and (ie_permite_data_menor_w = 'N') then
	--'A data de entrada na unidade nao pode ser menor que a data de inicio do atendimento.

	--Data entrada: '||to_char(:new.dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data inicio atendimento: '||to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss')|| '');

	CALL wheb_mensagem_pck.exibir_mensagem_abort(179704, 'DT_SAIDA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_entrada_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
							'DT_ATUAL='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));

end if;

select	coalesce(max(obter_valor_param_usuario(916,662, Obter_perfil_ativo, NEW.nm_usuario, 0)),'S')
into STRICT	ie_permite_menor_dt_entrada_w
;

if (ie_permite_menor_dt_entrada_w = 'N') then

	if (NEW.dt_entrada_unidade	< dt_entrada_w) then
		--'A data de entrada na unidade nao pode ser menor que a data de inicio do atendimento.

				--Data entrada: '||to_char(:new.dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss')||' Data inicio atendimento: '||to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi:ss')|| '');

		CALL wheb_mensagem_pck.exibir_mensagem_abort(179706, 'DT_SAIDA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(NEW.dt_entrada_unidade, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||';'||
							'DT_ATUAL='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
	end if;
end if;

select 	max(cd_classif_setor)
into STRICT	cd_classif_setor_w
from	setor_atendimento
where	cd_setor_atendimento = NEW.cd_setor_atendimento;

if (ie_permite_intern_desfecho_w = 'N') and (obter_tipo_atendimento(NEW.nr_atendimento) = 3) and (cd_classif_setor_w in (3,4)) then

	BEGIN
		select	1
		into STRICT	ie_existe_desfecho_w
		from	atendimento_alta z
		where	z.nr_atendimento = NEW.nr_atendimento
		and	z.ie_desfecho = 'I'  LIMIT 1;
	exception
		when	no_data_found then
			ie_existe_desfecho_w := 0;
	end;

	if (ie_existe_desfecho_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(276597);
	end if;
end if;

if (NEW.dt_saida_unidade is null) then

	if (cd_classif_setor_w in ('1','5')) then

		select	max(nr_seq_interno)
		into STRICT	nr_seq_interno_unidade_w
		from 	unidade_atendimento a
		WHERE	A.cd_unidade_basica 	= NEW.cd_unidade_basica
		AND	A.cd_unidade_compl  	= NEW.cd_unidade_compl
		AND	A.cd_setor_atendimento 	= NEW.cd_setor_atendimento;

		select 	coalesce(max(QT_PAC_UNIDADE),0)
		into STRICT	QT_PAC_UNIDADE_w
		from	unidade_atendimento
		where	NR_SEQ_INTERNO = nr_seq_interno_unidade_w;

		if (QT_PAC_UNIDADE_w > 0) then

			select 	count(*)
			into STRICT	qt_em_unidade_w
			from	controle_atend_unidade
			where	NR_SEQ_INTERNO = nr_seq_interno_unidade_w
			and	dt_saida is null;

			if (qt_em_unidade_w >= QT_PAC_UNIDADE_w) then

				--'Nao e possivel gerar a passagem, pois ja existem pacientes ocupando este leito ');

				CALL wheb_mensagem_pck.exibir_mensagem_abort(179707);

			end if;

		end if;

	end if;

end if;

if (NEW.dt_atualizacao_nrec is null) then
	NEW.dt_atualizacao_nrec := LOCALTIMESTAMP;
end if;

if (NEW.dt_saida_unidade is null) then
	NEW.dt_saida_interno  := to_date('30/12/2999','dd/mm/yyyy');
else
	NEW.dt_saida_interno  := NEW.dt_saida_unidade;
end if;

if	((coalesce(NEW.ie_passagem_setor,'N') = 'N') or (coalesce(NEW.ie_passagem_setor,'L') = 'L')) and (NEW.dt_saida_unidade is null) and (coalesce(ie_adic_pac_leito_agrup_w,'S') = 'N') then

	select	coalesce(max(nr_agrupamento),0)
	into STRICT	nr_agrupamento_w
	from	unidade_atendimento
	where	cd_setor_atendimento = NEW.cd_setor_atendimento
	and	cd_unidade_basica    = NEW.cd_unidade_basica
	and	cd_unidade_compl     = NEW.cd_unidade_compl;

	if (nr_agrupamento_w > 0) then

		select	verifica_se_agrup_isol(NEW.cd_setor_atendimento,nr_agrupamento_w)
		into STRICT	ie_isol_agrup_w
		;

		if (ie_isol_agrup_w = 'S') then

			--'Nao e possivel adicionar paciente na unidade, pois no mesmo agrupamento ha leito/paciente isolado. Parametro[167] ');

			CALL wheb_mensagem_pck.exibir_mensagem_abort(179708);

		end if;
	end if;
end if;

if	((coalesce(NEW.ie_passagem_setor,'N') = 'N') or (coalesce(NEW.ie_passagem_setor,'L') = 'L')) and (NEW.dt_saida_unidade is null) then
	BEGIN
	
	select  max(ie_bloq_unid_ant),
			max(nr_seq_interno),
			max(ie_retaguarda_atual)
	into STRICT	ie_bloq_unid_ant_w,
			nr_seq_unidade_new_w,
			ie_retaguarda_atual_w
	from 	unidade_atendimento
	where 	cd_unidade_basica 		= NEW.cd_unidade_basica
	and 	cd_unidade_compl  		= NEW.cd_unidade_compl
	and 	cd_setor_atendimento 	= NEW.cd_setor_atendimento;
	
	open locked_records;
    loop
        fetch locked_records into unidade_atendimento_row_w;
        EXIT WHEN NOT FOUND; /* apply on locked_records */
    end loop;
	
	close locked_records;
	
	open locked_records_2;
    loop
        fetch locked_records_2 into unidade_atendimento2_row_w;
        EXIT WHEN NOT FOUND; /* apply on locked_records_2 */
    end loop;
	
	close locked_records_2;

	-- O leito devera ser ocupado (ou nao) de acordo com a acomodacao de cada leito

	UPDATE UNIDADE_ATENDIMENTO A
	SET A.NR_ATENDIMENTO      	= NEW.nr_atendimento,
		A.DT_ENTRADA_UNIDADE  	= NEW.dt_entrada_unidade,
		A.IE_STATUS_UNIDADE   	= 'P',
		A.CD_PACIENTE_RESERVA 	 = NULL,
		A.NM_PAC_RESERVA		 = NULL,
		A.CD_CONVENIO_RESERVA	 = NULL,
		A.NM_USUARIO		= NEW.nm_usuario,
			A.DT_ATUALIZACAO		= LOCALTIMESTAMP
	WHERE	A.cd_unidade_basica 	= NEW.cd_unidade_basica
	AND 	A.cd_unidade_compl  	= NEW.cd_unidade_compl
	AND		A.cd_setor_atendimento 	= NEW.cd_setor_atendimento
	AND		(((substr(obter_se_sem_acomodacao(a.cd_tipo_acomodacao),1,1) = 'N') and (ie_considera_tipo_acomod_w = 'S')) or
			((ie_considera_tipo_acomod_w = 'N') and (obter_classif_setor(a.cd_setor_atendimento) in (3,4,11,12))));

	CALL Atualizar_Unidade_atendimento(NEW.cd_setor_atendimento,
					NEW.cd_unidade_basica,
					NEW.cd_unidade_compl);

	if (coalesce(ie_bloq_unid_ant_w,'N') = 'S') then

		update 	unidade_atendimento
		set 	nr_seq_unid_bloq  = nr_seq_unidade_new_w
		where 	nr_seq_interno 	  = NEW.nr_seq_unid_ant;
	end if;

	if (ie_retaguarda_atual_w = 'S') then
		update 	unidade_atendimento
		set 	ie_retaguarda_atual  = 'N'
		where 	nr_seq_interno 	  = nr_seq_unidade_new_w;
	end if;

	end;
end if;


if	((coalesce(NEW.ie_passagem_setor,'N') = 'N') or (coalesce(NEW.ie_passagem_setor,'L') = 'L')) and (NEW.dt_saida_unidade is null) then
	BEGIN
	select	max(NR_SEQ_LOCAL_PA)
	into STRICT	NR_SEQ_LOCAL_PA_w
	from 	unidade_atendimento a
	WHERE A.cd_unidade_basica 	= NEW.cd_unidade_basica
	AND A.cd_unidade_compl  	= NEW.cd_unidade_compl
	AND A.cd_setor_atendimento 	= NEW.cd_setor_atendimento;

	if (NR_SEQ_LOCAL_PA_w	is not null) then
		update	atendimento_paciente
		set	NR_SEQ_LOCAL_PA	= NR_SEQ_LOCAL_PA_w
		where	nr_atendimento	= NEW.nr_atendimento;
	end if;
	exception
		when others then
		null;
	end;

end if;


CALL gerar_lib_bloqueio_telefone(obter_estab_atend(NEW.nr_atendimento),
				NEW.nr_atendimento,
				NEW.nm_usuario,
				NEW.cd_setor_atendimento,
				NEW.cd_unidade_basica,
				NEW.cd_unidade_compl,
				10);

ie_status_w := Obter_param_Usuario(1002, 87, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w, ie_status_w);
ie_altera_data_acomodacao_w := obter_param_usuario(1002, 138, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_altera_data_acomodacao_w);

if (ie_status_w = 'S') then
	update	gestao_vaga
	set	ie_status		= 'F',
		dt_acomodacao		= CASE WHEN ie_altera_data_acomodacao_w='S' THEN LOCALTIMESTAMP  ELSE dt_acomodacao END ,
		nr_atendimento		= NEW.nr_atendimento,
		cd_setor_atual		= NEW.cd_setor_atendimento,
		cd_unid_basica_atual = (SELECT substr(obter_unidade_atendimento(NEW.nr_atendimento,'IAA','UB'),1,40) ),
		cd_unid_compl_atual = (select substr(obter_unidade_atendimento(NEW.nr_atendimento,'IAA','UC'),1,40) ),
		cd_tipo_acomod_atual	= NEW.cd_tipo_acomodacao
	where	cd_setor_desejado	= NEW.cd_setor_atendimento
	and	cd_unidade_basica	= NEW.cd_unidade_basica
	and	cd_unidade_compl	= NEW.cd_unidade_compl
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	((ie_status		= 'R')
	or (ie_status		= 'A'));
else
	update	gestao_vaga
	set	ie_status		= 'F',
		dt_acomodacao		= CASE WHEN ie_altera_data_acomodacao_w='S' THEN LOCALTIMESTAMP  ELSE dt_acomodacao END ,
		nr_atendimento		= NEW.nr_atendimento,
		cd_tipo_acomod_atual	= NEW.cd_tipo_acomodacao
	where	cd_setor_desejado	= NEW.cd_setor_atendimento
	and	cd_unidade_basica	= NEW.cd_unidade_basica
	and	cd_unidade_compl	= NEW.cd_unidade_compl
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	((ie_status		= 'R')
	or (ie_status		= 'A'));
end if;

select	Obter_Valor_Param_Usuario(1007,12, obter_perfil_ativo, NEW.nm_usuario,0)
into STRICT	ie_transfere_prontuario_w
;

if (ie_transfere_prontuario_w = 'S') then

	select	count(*)
	into STRICT	qt_agenda_w
	from	agenda
	where	ie_situacao		= 'A'
	and	cd_tipo_agenda		= 5
	and	cd_setor_exclusivo 	= NEW.cd_setor_atendimento;

	if (qt_agenda_w = 1) then
		select	cd_agenda
		into STRICT	cd_agenda_w
		from	agenda
		where	ie_situacao		= 'A'
		and	cd_tipo_agenda		= 5
		and	cd_setor_exclusivo 	= NEW.cd_setor_atendimento;
	end if;

	CALL solicitar_prontuario_setor(NEW.nr_atendimento,NEW.cd_setor_atendimento,cd_agenda_w,LOCALTIMESTAMP,NEW.nm_usuario);
end if;

/* Rafael em 8/9/2007 OS68015 */


-- obter dados pf

/* Matheus OS 182242 substituido pela function obter_prontuario_pf
select	nvl(max(nr_prontuario),0)
into	nr_prontuario_w
from	pessoa_fisica
where	cd_pessoa_fisica = obter_pessoa_atendimento(:new.nr_atendimento,'C');*/


nr_prontuario_w	:= coalesce(obter_prontuario_pf(cd_estabelecimento_w, obter_pessoa_atendimento(NEW.nr_atendimento,'C')),0);

-- obter dados atend

select	max(cd_estabelecimento),
	coalesce(max(ie_tipo_atendimento),0),
	coalesce(max(ie_clinica),0)
into STRICT	cd_estabelecimento_w,
	ie_tipo_atendimento_w,
	ie_clinica_w
from	atendimento_paciente
where	nr_atendimento = NEW.nr_atendimento;

-- obter parametros

select	obter_valor_param_usuario(0,32,0,NEW.nm_usuario,cd_estabelecimento_w)
into STRICT	ie_prontuario_w
;

select	obter_valor_param_usuario(5,24,obter_perfil_ativo,NEW.nm_usuario,cd_estabelecimento_w)
into STRICT	ie_forma_gerar_w
;

ie_mostrar_erro_aghos_w := Obter_param_Usuario(3111, 248, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w, ie_mostrar_erro_aghos_w);

if (nr_prontuario_w = 0) and (ie_prontuario_w = 'R') then


	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_gerar_pront_w
	from	regra_prontuario
	where	cd_estabelecimento					= cd_estabelecimento_w
	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)		= ie_tipo_atendimento_w
	and	coalesce(ie_clinica,ie_clinica_w)				= ie_clinica_w
	and	coalesce(cd_setor_atendimento,NEW.cd_setor_atendimento)	= NEW.cd_setor_atendimento
	and	ie_tipo_regra							= 2;

	if (ie_gerar_pront_w = 'S') then
		ie_regra_excecao_w	:= 'N';
		open C05;
		loop
		fetch C05 into
			ie_regra_excecao_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			BEGIN
			ie_regra_excecao_w := ie_regra_excecao_w;
			end;
		end loop;
		close C05;

		if (ie_regra_excecao_w	= 'N') then
			if (ie_forma_gerar_w <> 'N') then
				nr_prontuario_w := gerar_prontuario_anual(ie_forma_gerar_w, NEW.nm_usuario, nr_prontuario_w);

				update	pessoa_fisica
				set	nr_prontuario = nr_prontuario_w
				where	cd_pessoa_fisica = obter_pessoa_atendimento(NEW.nr_atendimento,'C');
			else
				/*Matheus OS 182242*/


				nr_prontuario_w := gerar_prontuario_pac(cd_estabelecimento_w, obter_pessoa_atendimento(NEW.nr_atendimento,'C'), 'N', NEW.nm_usuario, nr_prontuario_w);
			end if;

		end if;
	end if;
end if;



/* Fim Rafael em 8/9/2007 OS68015 */




CALL cons_regra_func_setor_atepacu(NEW.cd_setor_atendimento,NEW.nr_atendimento); /* Rafael em 12/5/8 OS92684 */

cd_convenio_w	:= obter_convenio_atendimento(NEW.nr_atendimento);

open C02;
loop
fetch C02 into
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	BEGIN
	CALL gerar_evento_pac_trigger_setor(nr_seq_evento_w,NEW.nr_atendimento,cd_pessoa_fisica_w,null,NEW.nm_usuario, NEW.cd_unidade_basica, NEW.cd_unidade_compl, NEW.cd_setor_atendimento);
	end;
end loop;
close C02;

/*open C03;
loop
fetch C03 into
	nr_seq_evento_w;
exit when C03%notfound;
	begin
	gerar_evento_paciente_trigger(nr_seq_evento_w,:new.nr_atendimento,cd_pessoa_fisica_w,null,:new.nm_usuario);
	end;
end loop;
close C03; */


open C04;
loop
fetch C04 into
        nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
        BEGIN
        CALL gerar_evento_pac_trigger_setor(nr_seq_evento_w,NEW.nr_atendimento,cd_pessoa_fisica_w,null,NEW.nm_usuario, NEW.cd_unidade_basica, NEW.cd_unidade_compl, NEW.cd_setor_atendimento);

        end;
end loop;
close C04;

BEGIN
CALL enviar_comunic_tipo_acomod(NEW.nr_atendimento,NEW.cd_tipo_acomodacao,NEW.cd_setor_atendimento,cd_estabelecimento_w,NEW.nm_usuario);
end;

if (coalesce(NEW.ie_passagem_setor,'N') = 'S') then
	CALL gerar_regra_frasco_pato(NEW.nr_atendimento,null,ie_tipo_atendimento_w,null,null,ie_clinica_w,NEW.cd_setor_atendimento,'P',NEW.nm_usuario);

	if (obter_se_primeira_pass_setor(NEW.nr_atendimento) = 'S') then
		CALL gerar_regra_frasco_pato(NEW.nr_atendimento,null,ie_tipo_atendimento_w,null,null,ie_clinica_w,NEW.cd_setor_atendimento,'PR',NEW.nm_usuario);
	end if;

end if;

CALL gerar_regra_prontuario_gestao(ie_tipo_atendimento_w, cd_estab_atend_w, NEW.nr_atendimento, cd_pessoa_fisica_w, NEW.nm_usuario, null, null, null, ie_clinica_w, NEW.cd_setor_atendimento, null, null);

ie_consiste_regra_conv_w := Obter_Param_Usuario(916, 788, obter_perfil_ativo, NEW.nm_usuario, cd_estabelecimento_w, ie_consiste_regra_conv_w);
if (ie_consiste_regra_conv_w in ('S', 'T')) then

	select	max(b.nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente b
	where	nr_atendimento < NEW.nr_atendimento;

	select	a.ie_tipo_convenio
	into STRICT	ie_tipo_convenio_ant_w
	from	atendimento_paciente a
	where	a.nr_atendimento = nr_atendimento_w;

	select	a.nr_seq_queixa
	into STRICT	nr_seq_queixa_ant_w
	from	atendimento_paciente a
	where	a.nr_atendimento = nr_atendimento_w;

	qt_idade_w	:= substr(obter_idade_pf(cd_pessoa_fisica_w, LOCALTIMESTAMP, 'A'), 1, 3);

	select	max(cd_categoria),
		max(cd_plano_convenio),
		max(cd_empresa),
		max(nr_seq_cobertura),
		max(cd_tipo_acomodacao)
	into STRICT	cd_categoria_w,
		cd_plano_w,
		cd_empresa_cat_w,
		nr_seq_cobertura_w,
		cd_tipo_acomodacao_w
	from	atend_categoria_convenio
	where	nr_seq_interno = obter_atecaco_atendimento(NEW.nr_atendimento);

	select	max(nr_seq_classificacao),
		max(ie_clinica),
		max(cd_procedencia),
		max(nr_seq_tipo_acidente),
		max(nr_seq_queixa)
	into STRICT	nr_seq_classificacao_w,
		ie_clinica_w,
		cd_procedencia_w,
		nr_seq_tipo_acidente_w,
		nr_seq_queixa_w
	from	atendimento_paciente
	where	nr_atendimento = NEW.nr_atendimento;

	SELECT * FROM Obter_Se_Lib_Setor_Conv(
			cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, ie_tipo_atendimento_w, NEW.cd_setor_atendimento, cd_plano_w, nr_seq_classificacao_w, ds_mensagem_w, ie_bloqueia_atendimento_w, ie_clinica_w, cd_empresa_cat_w, cd_procedencia_w, nr_seq_cobertura_w, nr_seq_tipo_acidente_w, cd_tipo_acomodacao_w, Obter_medico_resp_atend(NEW.nr_atendimento, 'C'), qt_idade_w, ie_tipo_convenio_ant_w, nr_seq_queixa_w, nr_seq_queixa_ant_w, LOCALTIMESTAMP, cd_pessoa_fisica_w) INTO STRICT ds_mensagem_w, ie_bloqueia_atendimento_w;

	if (ie_bloqueia_atendimento_w = 'B') then
		if (ds_mensagem_w is null) then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(150769);
		else
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(186140, 'MENSAGEM='||ds_mensagem_w);
		end if;
	end if;
end if;

select	coalesce(max(ie_integracao_epimed),0),
	coalesce(max(ie_integracao_dynamics),'N')
into STRICT	ie_integracao_epimed_w,
	ie_integracao_dynamics_w
from	parametro_atendimento
where	cd_estabelecimento =	cd_estabelecimento_w;

if (ie_integracao_epimed_w = 1) then
	CALL hsl_gerar_epimed_internacao(NEW.cd_setor_atendimento,NEW.dt_entrada_unidade,NEW.nr_seq_interno,NEW.nr_atendimento,NEW.cd_unidade_basica,
				    NEW.cd_unidade_compl,NEW.nm_usuario,NEW.dt_saida_unidade,cd_classif_setor_w,'T');
end if;

if (ie_integracao_dynamics_w = 'S') then
	CALL Gerar_crm_atendimentos(NEW.nr_atendimento,NEW.cd_setor_atendimento,NEW.nm_usuario);
end if;

--Realizar alteracoes de movimentacao do paciente para o Matrix

if (obter_se_integracao_ativa(887,53) = 'S') then
   CALL integrar_matrix_ws_v7(887,nr_atendimento_p => NEW.nr_atendimento);
end if;

-- Atualizar o leito do paciente no Aghos ao interna-lo

ie_integracao_aghos_w := obter_dados_param_atend(cd_estabelecimento_w, 'AG');

If (ie_integracao_aghos_w <> 'N') and false then

	select	max(nr_internacao)
	into STRICT	nr_internacao_w
	from	solicitacao_tasy_aghos
	where	nr_atendimento = NEW.nr_atendimento;

	If (nr_internacao_w is not null) then

		select	max(a.nr_seq_interno)
		into STRICT	nr_seq_atepacu_w
		from 	unidade_atendimento a
		where 	a.cd_unidade_basica	= NEW.cd_unidade_basica
		and 	a.cd_unidade_compl  	= NEW.cd_unidade_compl
		and 	a.cd_setor_atendimento 	= NEW.cd_setor_atendimento
		and	a.nm_setor_integracao is not null;


		If (nr_seq_atepacu_w > 0) and (coalesce(NEW.ie_passagem_setor, 'N') <> 'S') then

			If (ie_integracao_aghos_w = 'S') then
				BEGIN
					CALL Aghos_transferencia_interna(NEW.nr_atendimento, nr_seq_atepacu_w, NEW.nm_usuario);
				exception
					when	others then

						If (ie_mostrar_erro_aghos_w = 'S') then

							ds_sqlerror_w := sqlerrm;
							ds_erro_aghos_w := substr(Ajusta_mensagem_erro_aghos(ds_sqlerror_w), 1, 2000);

							CALL wheb_mensagem_pck.exibir_mensagem_abort(228493, 'DS_MENSAGEM=' || coalesce(ds_erro_aghos_w, ds_sqlerror_w));
						End if;

						insert into aghos_contigencia_mov(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							ds_erro,
							nr_atendimento,
							nr_internacao,
							nr_seq_atepacu,
							cd_setor_origem,
							dt_resolvida,
							nm_usuario_resol)
						values (nextval('aghos_contigencia_mov_seq'),
							LOCALTIMESTAMP,
							NEW.nm_usuario,
							LOCALTIMESTAMP,
							NEW.nm_usuario,
							ds_erro_aghos_w,
							NEW.nr_atendimento,
							nr_internacao_w,
							NEW.nr_seq_interno,
							OLD.cd_setor_atendimento,
							null,
							null);
				end;
			elsif (coalesce(obter_funcao_ativa, 916) not in (3111)) then
				SELECT * FROM Aghos_transferencia_interna_ws(NEW.nr_atendimento, nr_seq_atepacu_w, NEW.nm_usuario, 'N', idf_internacao_w, cod_posto_enfermagem_w, cod_enfermaria_w, cod_leito_w, cod_digito_leito_w, des_usuario_w) INTO STRICT idf_internacao_w, cod_posto_enfermagem_w, cod_enfermaria_w, cod_leito_w, cod_digito_leito_w, des_usuario_w;
			End if;
		End if;

	End if;
End if;

select 	count(*)
into STRICT	qt_regra_w
from	regra_leitos_inativacao
where	ie_situacao = 'A';

if (coalesce(qt_regra_w,0) > 0) then

	select	max(nr_seq_unid_princ)
	into STRICT	nr_seq_regra_princ_w
	from	regra_leitos_inativacao
	where	ie_situacao = 'A'
	and	nr_seq_unid_sec = (	SELECT	max(nr_seq_interno)
					from	unidade_atendimento
					where 	cd_unidade_basica	= NEW.cd_unidade_basica
					and 	cd_unidade_compl  	= NEW.cd_unidade_compl
					and 	cd_setor_atendimento 	= NEW.cd_setor_atendimento);

	if (coalesce(nr_seq_regra_princ_w,0) = 0) then
		select	max(nr_seq_unid_sec)
		into STRICT	nr_seq_regra_princ_w
		from	regra_leitos_inativacao
		where	ie_situacao = 'A'
		and	nr_seq_unid_princ = (	SELECT	max(nr_seq_interno)
						from	unidade_atendimento
						where 	cd_unidade_basica	= NEW.cd_unidade_basica
						and 	cd_unidade_compl  	= NEW.cd_unidade_compl
						and 	cd_setor_atendimento 	= NEW.cd_setor_atendimento);
	end if;

	if (coalesce(nr_seq_regra_princ_w, 0) > 0) then

		update	unidade_atendimento
		set	ie_situacao = 'I'
		where	nr_seq_interno = nr_seq_regra_princ_w
		AND	ie_status_unidade = 'L';

	end if;
end if;

-- Rotina para movimentacao de paciente na integracao dispensarios

CALL swisslog_movimentacao_pac(NEW.nr_atendimento, NEW.cd_setor_atendimento, 0, 3, NEW.nm_usuario);
ds_leito_w := substr(NEW.cd_unidade_basica || ' - ' || NEW.cd_unidade_compl,1,10);
CALL gerar_int_dankia_pck.dankia_internar_paciente(NEW.nr_atendimento, NEW.cd_setor_atendimento, ds_leito_w, cd_estabelecimento_w, NEW.nm_usuario);

SELECT CASE WHEN COUNT(*)=0 THEN  'N'  ELSE 'S' END
INTO STRICT ie_setor_athena_w
FROM far_setores_integracao
WHERE nr_seq_empresa_int = 221
AND cd_setor_atendimento = NEW.cd_setor_atendimento  LIMIT 1;

if (ie_setor_athena_w = 'S') then
	integracao_athena_disp_pck.movimentacao_paciente(NEW.nr_atendimento, NEW.cd_setor_atendimento, 0, 3, NEW.nm_usuario);
end if;

<<final>>
null;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_paciente_unidade_insert() FROM PUBLIC;

CREATE TRIGGER atend_paciente_unidade_insert
	BEFORE INSERT ON atend_paciente_unidade FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_paciente_unidade_insert();

