-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_transf_setor (nr_seq_evento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_laudo_p bigint, nm_usuario_p text, nr_repasse_terceiro_p bigint default null, ie_iso_precaucao_p text default null, ie_sincrono_p text default null, ds_mensagem_original_p text default null, cd_medico_resp_p text default null, cd_pessoa_parecer_p text default null, nr_seq_gv_p bigint DEFAULT NULL, nr_parecer_p bigint default null, nr_titulo_p bigint default null, nr_seq_baixa_p bigint default null, ie_commit_p text default 'S', nr_seq_interno_p bigint default null, dt_referencia_p timestamp default clock_timestamp()) AS $body$
DECLARE


ie_forma_ev_w			varchar(15);
ie_pessoa_destino_w		varchar(15);
cd_pf_destino_w			varchar(10);
ds_mensagem_w			varchar(4000);
ds_titulo_w			varchar(4000);
cd_pessoa_destino_w		varchar(10);
nr_sequencia_w			bigint;
ds_maquina_w			varchar(80);
nm_paciente_w			varchar(60);
nm_paciente_abrev_w		varchar(60);
ds_unidade_w			varchar(60);
ds_setor_atendimento_w		varchar(60);
ie_usuario_aceite_w		varchar(1);
qt_corresp_w			integer;
cd_setor_atendimento_w		integer;
cd_perfil_w			integer;
cd_pessoa_regra_w		varchar(10);
nr_ramal_w			varchar(10);
nr_telefone_w			varchar(40);
cd_convenio_w			bigint;
cd_pessoa_terc_w		bigint;
nr_seq_terceiro_w		bigint;
nm_usuario_destino_w		varchar(15);
cd_setor_atend_pac_w		integer;
ds_cid_w			varchar(240);
cd_cid_w			varchar(10);
ds_dieta_w			varchar(4000);
dt_lib_precaucao_w		timestamp;
ds_precaucao_w			varchar(255);
ds_motivo_precaucao_w   	varchar(255);
nr_seq_precaucao		bigint;
nr_seq_motivo			bigint;
cd_status_w			varchar(2);
ds_convenio_w			varchar(255);
ds_setor_anterior_w		varchar(255);
ie_setor_ant_pa_w		varchar(5);
ds_observacao_w			varchar(4000);
ds_plano_conv_w			convenio_Plano.ds_plano%type;
ds_categoria_conv_w		categoria_convenio.ds_categoria%type;
ds_tipo_atend_w			varchar(60);
ds_classif_pessoa_w		varchar(4000);
nm_paciente_gv_w		varchar(60);
nr_seq_interno_atual_w		bigint;
nr_seq_interno_anterior_w 	bigint;
cd_setor_anterior_w		bigint;
cd_unidade_basica_ant_w		varchar(10);
cd_unidade_compl_ant_w		varchar(10);
ds_setor_anterior_transf_w     	varchar(200);
ds_unid_basica_compl_ant_w	varchar(200);
nr_sequencia_cih_w		bigint;
ds_microorganismos_w		varchar(255);
ds_temp_w			varchar(255);
ds_topografia_w			varchar(255);
dt_registro_w			timestamp;
nm_medico_solic_w		varchar(60);
dt_inicio_w			timestamp;
ds_observacao_ww		varchar(2000);	
cd_medico_parecer_w		varchar(10);
cd_especialidade_dest_w		integer;
cd_especialidade_dest_prof_w	integer;
nr_seq_equipe_w			bigint;
ie_equipe_w			varchar(10);
ds_usuario_w			varchar(255);
vl_baixa_w			double precision;
dt_baixa_w			timestamp;
dt_alta_anterior_w		timestamp;
cd_setor_w			integer;
ds_unidade_setor_w		varchar(60);
dt_nascimento_w		varchar(70);
nr_adiant_pago_w		varchar(255);
vl_adiant_tit_pagar_w		varchar(255);
nm_fornec_adiant_pago_w		varchar(255);
nr_ordem_compra_adiant_w	varchar(255);
ie_excecao_alerta_pessoa_w	varchar(1);
cd_setor_atend_n_pass_w		bigint;
ds_setor_ant_n_pass_transf_w	varchar(200);
nr_sequencia_interna_w		bigint;

C01 CURSOR FOR
	SELECT	ie_forma_ev,
		ie_pessoa_destino,
		cd_pf_destino,
		coalesce(ie_usuario_aceite,'N'),
		cd_setor_atendimento,
		cd_perfil
	from	ev_evento_regra_dest
	where	nr_seq_evento	= nr_seq_evento_p
	and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))	= coalesce(cd_convenio_w,0)
	and	coalesce(cd_setor_atend_pac, coalesce(cd_setor_atend_pac_w,0)) = coalesce(cd_setor_atend_pac_w,0)
	AND	coalesce(ie_excecao,'N') = 'N'
	order by ie_forma_ev;

C02 CURSOR FOR
	SELECT	obter_dados_usuario_opcao(a.nm_usuario,'C')
	from	usuario_setor_v a,
		usuario b
	where	a.nm_usuario = b.nm_usuario
	and	b.ie_situacao = 'A'
	and	a.cd_setor_atendimento = cd_setor_atendimento_w
	and	ie_forma_ev_w in (2,3)
	and	(obter_dados_usuario_opcao(a.nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(a.nm_usuario,'C'))::text <> '');

C03 CURSOR FOR
	SELECT	obter_dados_usuario_opcao(a.nm_usuario,'C'),
			a.nm_usuario
	from	usuario_perfil a,
		usuario b
	where	a.nm_usuario = b.nm_usuario
	and	b.ie_situacao = 'A'
	and	a.cd_perfil = cd_perfil_w
	and	ie_forma_ev_w in (2,3)
	and	(obter_dados_usuario_opcao(a.nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(a.nm_usuario,'C'))::text <> '');

c04 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	terceiro
	where	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
	and	nr_sequencia	= nr_seq_terceiro_w
	
union all

	SELECT	cd_pessoa_fisica
	from	terceiro_pessoa_fisica
	where	nr_seq_terceiro = nr_seq_terceiro_w;

	
c05 CURSOR FOR
	SELECT	x.cd_medico
	from	prescr_medica x
	where	x.nr_atendimento	= nr_atendimento_p
	and	x.dt_prescricao  between clock_timestamp() - interval '36 days'/24 and clock_timestamp()
	
union

	SELECT	x.cd_medico
	from	evolucao_paciente x
	where	x.nr_atendimento	= nr_atendimento_p
	and	x.dt_evolucao  between clock_timestamp() - interval '36 days'/24 and clock_timestamp();
	
C06 CURSOR FOR
	SELECT	substr(obter_desc_microorganismo(cd_microorganismo),1,255)
	from	ATEND_PRECAUCAO_MICRO
	where	NR_SEQ_ATEND_PRECAUCAO = nr_sequencia_cih_w;	
	
C07 CURSOR FOR
	SELECT	substr(obter_desc_topografia(cd_topografia),1,255)
	from	ATEND_PRECAUCAO_MICRO
	where	NR_SEQ_ATEND_PRECAUCAO = nr_sequencia_cih_w;		
	
C08 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	medico_especialidade
	where	obter_se_corpo_clinico(cd_pessoa_fisica) = 'S'
	and	cd_especialidade = cd_especialidade_dest_w
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
	and	coalesce(cd_medico_parecer_w::text, '') = ''
	and	coalesce(cd_especialidade_dest_prof_w,0) = 0
	
union

	SELECT	cd_pessoa_fisica
	from	profissional_especialidade
	where	cd_especialidade_prof = cd_especialidade_dest_prof_w
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
	and	coalesce(cd_medico_parecer_w::text, '') = ''
	and	coalesce(cd_especialidade_dest_w,0) = 0
	
union

	select	cd_medico_parecer_w
	
	where	(cd_medico_parecer_w IS NOT NULL AND cd_medico_parecer_w::text <> '')
	
union

	select  b.cd_pessoa_fisica
	from     pf_equipe_partic b,
		pf_equipe a
	where	a.nr_sequencia = b.nr_seq_equipe
	and	a.cd_pessoa_fisica	= cd_medico_parecer_w
	and	coalesce(a.ie_situacao,'A')  = 'A'
	and	(cd_medico_parecer_w IS NOT NULL AND cd_medico_parecer_w::text <> '')
	and	ie_equipe_w	= 'S'
	
union

	select  b.cd_pessoa_fisica
	from     pf_equipe_partic b,
		pf_equipe a
	where	a.nr_sequencia = b.nr_seq_equipe
	and	a.nr_sequencia	= nr_seq_equipe_w
	and	coalesce(a.ie_situacao,'A')  = 'A'
	and	(nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '')
	
union

	select  a.cd_pessoa_fisica
	from    pf_equipe a
	where	a.nr_sequencia	= nr_seq_equipe_w
	and	coalesce(a.ie_situacao,'A')  = 'A'
	and	(nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '')
	
union

	select	b.cd_pessoa_fisica
	from	espec_regra_parecer a,
		medico_especialidade b
	where	a.cd_especialidade_dest = b.cd_especialidade
	and	a.cd_especialidade = cd_especialidade_dest_w
	and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '')
	order by	1;
	

BEGIN


if (ie_sincrono_p = 'S') then
	begin
    cd_status_w := 'GS';
	end;
else
	begin
    cd_status_w := 'G';
	end;
end if;

select	substr(obter_inf_sessao(0),1,80)
into STRICT	ds_maquina_w
;

select	ds_titulo,
	ds_mensagem
into STRICT	ds_titulo_w,
	ds_mensagem_w
from	ev_evento
where	nr_sequencia	= nr_seq_evento_p;


IF (nr_atendimento_p > 0) THEN
	SELECT	coalesce(MAX(obter_convenio_atendimento(nr_atendimento_p)), 0)
	INTO STRICT	cd_convenio_w
	;
ELSif (nr_Seq_gv_p IS NOT NULL AND nr_Seq_gv_p::text <> '') then
	SELECT coalesce(max(cd_convenio),0)
	INTO STRICT cd_convenio_w
	FROM gestao_vaga
	WHERE nr_sequencia = nr_seq_gv_p;	
	
	select	substr(nm_paciente,1,60)
	into STRICT	nm_paciente_gv_w
	from	gestao_vaga
	where	nr_sequencia = nr_seq_gv_p;
else
	cd_convenio_w	:= NULL;
END IF;

if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') and (cd_convenio_w > 0) then
	begin
	ds_convenio_w	:= substr(obter_desc_convenio(cd_convenio_w),1,255);
	end;
end if;


select	CASE WHEN substr(obter_nome_pf(cd_pessoa_fisica_p),1,60)='' THEN nm_paciente_gv_w  ELSE substr(obter_nome_pf(cd_pessoa_fisica_p),1,60) END ,
	substr(abrevia_nome_pf(cd_pessoa_fisica_p,'M'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','U'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','RA'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','TL'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','S'),1,60),
	substr(obter_unidade_atendimento(nr_atendimento_p,'A','CS'),1,60),
	substr(obter_dados_pf(cd_pessoa_fisica_p, 'DN'),1,100),
	max(substr(obter_nome_tipo_atend(obter_tipo_atendimento(nr_atendimento_p)),1,60))	
into STRICT	nm_paciente_w,
	nm_paciente_abrev_w,
	ds_unidade_w,
	nr_ramal_w,
	nr_telefone_w,
	ds_setor_atendimento_w,
	cd_setor_atend_pac_w,
	dt_nascimento_w,
	ds_tipo_atend_w
;

if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then
	
	select	obter_unidade_regra(nr_seq_interno_p)
	into STRICT	ds_unidade_w
	;
	
	select 	obter_setor_unidade(nr_seq_interno_p)
	into STRICT	cd_setor_w
	;
	
	if (coalesce(cd_setor_w,0) > 0) then
		
		select	substr(ds_setor_atendimento,1,60)
		into STRICT	ds_unidade_setor_w
		from	setor_atendimento
		where 	cd_setor_atendimento = cd_setor_w;
		
	
	end if;
end if;

select	coalesce(max(substr(obter_dados_categ_conv(nr_atendimento_p, 'DP'), 1, 100)),''),
		coalesce(max(substr(obter_dados_categ_conv(nr_atendimento_p, 'DC'), 1, 100)),''),
		coalesce(max(substr(Obter_Nome_Convenio(obter_convenio_atendimento(nr_atendimento_p)), 1, 60)),'')
into STRICT	ds_plano_conv_w,
		ds_categoria_conv_w,
		ds_convenio_w
from	atend_categoria_convenio
where	nr_seq_interno	= obter_atecaco_atendimento(nr_atendimento_p);

select	substr(obter_cid_atendimento(nr_atendimento_p, 'P'),1,10),
	substr(obter_desc_cid_doenca(obter_cid_atendimento(nr_atendimento_p, 'P')),1,240)
into STRICT	cd_cid_w,
	ds_cid_w
;

if (ds_mensagem_original_p IS NOT NULL AND ds_mensagem_original_p::text <> '') then
  ds_mensagem_w := ds_mensagem_original_p || chr(13) || chr(10) || ds_mensagem_w;
end if;

ds_observacao_w := obter_lista_dados_classif(cd_pessoa_fisica_p, 'O');
ds_classif_pessoa_w := obter_lista_dados_classif(cd_pessoa_fisica_p, 'D');


select	max(b.ds_setor_atendimento),
	CASE WHEN substr(max(cd_classif_setor),1,60)=1 THEN '(PA)'  ELSE '' END
into STRICT	ds_setor_anterior_w,
	ie_setor_ant_pa_w
from	atend_paciente_unidade a,
	setor_atendimento b
where	a.cd_setor_atendimento = b.cd_setor_atendimento
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_seq_interno = 	(SELECT	max(c.nr_seq_interno)
				from	atend_paciente_unidade c	
				where	c.nr_atendimento = nr_atendimento_p
				and	c.nr_seq_interno < (	select	max(d.nr_seq_interno)
								from	atend_paciente_unidade d
								where	d.nr_atendimento = nr_atendimento_p));
								
--carla								
select	obter_atepacu_paciente(nr_atendimento_p, 'UAA')
into STRICT	nr_seq_interno_anterior_w
;

if (nr_seq_interno_anterior_w > 0) then

	select  coalesce(cd_setor_atendimento,0),
		cd_unidade_basica,
		cd_unidade_compl
	into STRICT	cd_setor_anterior_w,
		cd_unidade_basica_ant_w,
		cd_unidade_compl_ant_w
	from    atend_paciente_unidade
	where   nr_atendimento = nr_atendimento_p
	and     nr_seq_interno = nr_seq_interno_anterior_w;
	
	ds_unid_basica_compl_ant_w := substr(cd_unidade_basica_ant_w || '  ' || cd_unidade_compl_ant_w,1,200);
	
	if (cd_setor_anterior_w > 0) then
		select	substr(obter_nome_setor(cd_setor_anterior_w),1,200)
		into STRICT	ds_setor_anterior_transf_w
		;
	end if;
	
	SELECT 	coalesce(max(nr_seq_interno),0)
	into STRICT	nr_sequencia_interna_w
	FROM 	ATEND_PACIENTE_UNIDADE
	WHERE 	nr_Atendimento = nr_atendimento_p
	and		nr_seq_interno <> nr_seq_interno_atual_w
	AND 	ie_passagem_setor <> 'S';
	
	if (nr_sequencia_interna_w > 0) then
	
		select	max(cd_setor_atendimento)
		into STRICT 	cd_setor_atend_n_pass_w
		from 	ATEND_PACIENTE_UNIDADE
		where 	nr_seq_interno = nr_sequencia_interna_w
		and 	nr_atendimento = nr_atendimento_p;
	
		select	substr(obter_nome_setor(cd_setor_atend_n_pass_w),1,200)
		into STRICT	ds_setor_ant_n_pass_transf_w
		;
	end if;
end if;

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	select	max(dt_baixa),
		max(vl_baixa)
	into STRICT	dt_baixa_w,
		vl_baixa_w
	from	titulo_pagar_baixa
	where	nr_titulo	= nr_titulo_p
	and	nr_sequencia	= nr_seq_baixa_p;
	
	SELECT * FROM retorna_adiant_titulo_pagar(nr_titulo_p, nr_adiant_pago_w, vl_adiant_tit_pagar_w, nm_fornec_adiant_pago_w, nr_ordem_compra_adiant_w) INTO STRICT nr_adiant_pago_w, vl_adiant_tit_pagar_w, nm_fornec_adiant_pago_w, nr_ordem_compra_adiant_w;
end if;

if (position('@nomeusuario' in ds_mensagem_w) > 0 ) then

	select	substr(ds_usuario,1,40)
	into STRICT	ds_usuario_w
	from	usuario
	where	nm_usuario = nm_usuario_p;
	
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nomeusuario',ds_usuario_w),1,4000);
	
end if;

select	substr(max(obter_nome_dieta(cd_dieta)),1,4000)
into STRICT 	ds_dieta_w
from	prescr_dieta
where	nr_prescricao = (	SELECT	max(nr_prescricao)
       				from	prescr_medica
       				where	nr_atendimento = nr_atendimento_p
       				and   (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));

select	max(dt_alta)
into STRICT	dt_alta_anterior_w
from	atendimento_paciente
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	nr_atendimento < nr_atendimento_p;

ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nascimento',dt_nascimento_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@pac_abreviado',nm_paciente_abrev_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@quarto',ds_unidade_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@setor',ds_setor_atendimento_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@set_unidade',ds_unidade_setor_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@atendimento',nr_atendimento_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ramal',nr_ramal_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@telefone',nr_telefone_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@convenio',cd_convenio_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@data_atual',PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@data_hora_atual',PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cd_cid',cd_cid_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_cid',ds_cid_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@usuario',nm_usuario_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_convenio',ds_convenio_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ie_setor_ant_pa',ie_setor_ant_pa_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_setor_anterior',ds_setor_anterior_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@obs_classif_pessoa',ds_observacao_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@classif_pf',ds_classif_pessoa_w),1,400);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@tipo_atendimento', ds_tipo_atend_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@categoria', ds_categoria_conv_w),1,4000);	
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@plano', ds_plano_conv_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_setor_ant', ds_setor_anterior_transf_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_setor_n_ant_pass', ds_setor_ant_n_pass_transf_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cd_unid_basica_compl_ant', ds_unid_basica_compl_ant_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@vl_baixa_tit_pagar', vl_baixa_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_baixa_tit_pagar', dt_baixa_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dieta', ds_dieta_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dias_desde_alta', ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) - ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_alta_anterior_w)),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nr_adiant_pago',nr_adiant_pago_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@vl_adiant_tit_pagar',vl_adiant_tit_pagar_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nm_fornec_adiant_pago',nm_fornec_adiant_pago_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nr_ordem_compra_adiant',nr_ordem_compra_adiant_w),1,4000);

ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@paciente',nm_paciente_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@pac_abreviado',nm_paciente_abrev_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@quarto',ds_unidade_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@setor',ds_setor_atendimento_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@set_unidade',ds_unidade_setor_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@atendimento',nr_atendimento_p),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@ramal',nr_ramal_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@telefone',nr_telefone_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@convenio',cd_convenio_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@data_atual',PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@data_hora_atual',PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@cd_cid',cd_cid_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@ds_cid',ds_cid_w),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@usuario',nm_usuario_p),1,4000);
ds_titulo_w	:= SUBSTR(replace_macro(ds_titulo_w,'@ds_convenio',ds_convenio_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@ie_setor_ant_pa',ie_setor_ant_pa_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@ds_setor_anterior',ds_setor_anterior_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@classif_pf',ds_classif_pessoa_w),1,400);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@tipo_atendimento', ds_tipo_atend_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@categoria', ds_categoria_conv_w),1,4000);	
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@plano', ds_plano_conv_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@ds_setor_ant', ds_setor_anterior_transf_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@ds_setor_n_ant_pass', ds_setor_ant_n_pass_transf_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@cd_unid_basica_compl_ant', ds_unid_basica_compl_ant_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@vl_baixa_tit_pagar', vl_baixa_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@dt_baixa_tit_pagar', dt_baixa_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@nr_adiant_pago',nr_adiant_pago_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@vl_adiant_tit_pagar',vl_adiant_tit_pagar_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@nm_fornec_adiant_pago',nm_fornec_adiant_pago_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@nr_ordem_compra_adiant',nr_ordem_compra_adiant_w),1,4000);




if (ie_iso_precaucao_p = 'S') then
	select	max(x.nr_sequencia)
	into STRICT	nr_sequencia_cih_w
	from	atendimento_precaucao x
	where	x.nr_atendimento = nr_atendimento_p;

	select  max(dt_liberacao) dt_liberacao,
		max(NR_SEQ_MOTIVO_ISOL),
		max(nr_seq_precaucao),
		max(substr(obter_descricao_padrao('CIH_PRECAUCAO','DS_PRECAUCAO',NR_SEQ_precaucao),1,255)) ds_precaucao,
		max(substr(obter_descricao_padrao('MOTIVO_ISOLAMENTO','DS_MOTIVO',NR_SEQ_MOTIVO_ISOL),1,255)) ds_motivo_isol,
		max(substr(obter_cih_topografia(a.cd_topografia),1,255)),
		max(substr(obter_cih_microorganismo(cd_microorganismo),1,255)),
		max(a.dt_registro),
		max(substr(obter_nome_pf(a.cd_medico_solic),1,60)),
		max(a.dt_inicio),
		max(a.ds_observacao)
	into STRICT	dt_lib_precaucao_w,
		nr_seq_motivo,
		nr_seq_precaucao,
		ds_precaucao_w,
		ds_motivo_precaucao_w,
		ds_topografia_w,
		ds_microorganismos_w,
		dt_registro_w,
		nm_medico_solic_w,
		dt_inicio_w,
		ds_observacao_ww
	FROM cih_precaucao b, atendimento_precaucao a
LEFT OUTER JOIN motivo_isolamento c ON (a.nr_seq_motivo_isol = c.nr_sequencia)
WHERE nr_atendimento = nr_atendimento_p and a.nr_seq_precaucao = b.nr_sequencia  and a.nr_sequencia	= (	SELECT	max(x.nr_sequencia)
								from	atendimento_precaucao x
								where	x.nr_atendimento = nr_atendimento_p) group by NR_SEQ_MOTIVO_ISOL, nr_seq_precaucao;
	
	open C06;
	loop
	fetch C06 into	
		ds_temp_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		if (ds_microorganismos_w IS NOT NULL AND ds_microorganismos_w::text <> '') then
			ds_microorganismos_w	:= ds_microorganismos_w||', '||ds_temp_w;
		else
			ds_microorganismos_w	:= ds_temp_w;
		end if;
		end;
	end loop;
	close C06;
	
	open C07;
	loop
	fetch C07 into	
		ds_temp_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		if (ds_topografia_w IS NOT NULL AND ds_topografia_w::text <> '') then
			ds_topografia_w	:= ds_topografia_w||', '||ds_temp_w;
		else
			ds_topografia_w	:= ds_temp_w;
		end if;
		end;
	end loop;
	close C07;
	
			
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_lib_precaucao',PKG_DATE_FORMATERS.TO_VARCHAR(dt_lib_precaucao_w, 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p)),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_precaucao',ds_precaucao_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_motivo_isol',ds_motivo_precaucao_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_topografia',ds_topografia_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_microorganismos',ds_microorganismos_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_registro',dt_registro_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nm_medico_solic',nm_medico_solic_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_inicio',dt_inicio_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_observacao',ds_observacao_ww),1,4000);
end if;


	select	nextval('ev_evento_paciente_seq')
	into STRICT	nr_sequencia_w
	;

	insert into ev_evento_paciente(
		nr_sequencia,
		nr_seq_evento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		nr_atendimento,
		ds_titulo,
		ds_mensagem,
		ie_status,
		ds_maquina,
		dt_evento,
		dt_liberacao,
		ie_situacao,
		nr_repasse_terceiro)
	values (	nr_sequencia_w,
		nr_seq_evento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_p,
		CASE WHEN nr_atendimento_p=0 THEN null  ELSE nr_atendimento_p END , /* nr_atendimento_p - afstringari */
		ds_titulo_w,
		ds_mensagem_w,
		cd_status_w,
		ds_maquina_w,
		clock_timestamp(),
		clock_timestamp(),
		'A',
		nr_repasse_terceiro_p);

	open C01;
	loop
	fetch C01 into
		ie_forma_ev_w,
		ie_pessoa_destino_w,
		cd_pf_destino_w,
		ie_usuario_aceite_w,
		cd_setor_atendimento_w,
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_corresp_w	:= 1;
		cd_pessoa_destino_w	:= null;
		
		if (ie_pessoa_destino_w = '1') then /* Medico do atendimento */
			begin
			select	max(cd_medico_atendimento)
			into STRICT	cd_pessoa_destino_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
			end;
		elsif (ie_pessoa_destino_w = '2') then /*Medico responsavel pelo paciente*/
			begin
			if (cd_medico_resp_p IS NOT NULL AND cd_medico_resp_p::text <> '') then
				cd_pessoa_destino_w	:= cd_medico_resp_p;
			else
				select	max(cd_medico_resp)
				into STRICT	cd_pessoa_destino_w
				from	atendimento_paciente
				where	nr_atendimento	= nr_atendimento_p;
			end if;
			end;
		elsif (ie_pessoa_destino_w = '3') then /*Medico laudante*/
			begin
			select	max(cd_medico_resp)
			into STRICT	cd_pessoa_destino_w
			from	laudo_paciente
			where	nr_sequencia	= nr_seq_laudo_p;
			end;
		elsif (ie_pessoa_destino_w = '4') then /*Medico referido*/
			begin
			select	max(cd_medico_referido)
			into STRICT	cd_pessoa_destino_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;
			end;
		elsif (ie_pessoa_destino_w	= '10') then
			cd_pessoa_destino_w	:= cd_pessoa_parecer_p;
		elsif (ie_pessoa_destino_w = '5') or (ie_pessoa_destino_w = '12') then /*Pessoa fixa ou Usuario fixo*/
			cd_pessoa_destino_w	:= cd_pf_destino_w;
		elsif (ie_pessoa_destino_w = '6') then /* Terceiro do repasse */
			select	max(nr_seq_terceiro)
			into STRICT	nr_seq_terceiro_w
			from	repasse_terceiro
			where	nr_repasse_terceiro	= nr_repasse_terceiro_p;

			if (nr_seq_terceiro_w IS NOT NULL AND nr_seq_terceiro_w::text <> '') then
				open c04;
				loop
				fetch c04 into
					cd_pessoa_terc_w;
				EXIT WHEN NOT FOUND; /* apply on c04 */

					qt_corresp_w	:= 1;

					if (ie_usuario_aceite_w = 'S') then
						select	count(*)
						into STRICT	qt_corresp_w
						from	pessoa_fisica_corresp
						where	cd_pessoa_fisica	= cd_pessoa_terc_w
						and	ie_tipo_corresp		= CASE WHEN ie_forma_ev_w='1' THEN 'MCel' WHEN ie_forma_ev_w='3' THEN 'CI' WHEN ie_forma_ev_w='4' THEN 'Email' END
						and	ie_tipo_doc		= 'AE';
					end if;


					if (qt_corresp_w > 0) then
						ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_terc_w, ie_forma_ev_w);
						
						--Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
						if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then
							insert into ev_evento_pac_destino(
								nr_sequencia,
								nr_seq_ev_pac,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								cd_pessoa_fisica,
								ie_forma_ev,
								ie_status,
								dt_ciencia,
								ie_pessoa_destino)
							values (	nextval('ev_evento_pac_destino_seq'),
								nr_sequencia_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								cd_pessoa_terc_w,
								ie_forma_ev_w,
								'G',
								null,
								ie_pessoa_destino_w);
						end if;
						
					end if;
				end loop;
				close c04;
			end if;
		elsif (ie_pessoa_destino_w	= '14') then
			begin
			open C05;
			loop
			fetch C05 into	
				cd_pessoa_destino_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				qt_corresp_w	:= 1;

				if (ie_usuario_aceite_w = 'S') then
					select	count(*)
					into STRICT	qt_corresp_w
					from	pessoa_fisica_corresp
					where	cd_pessoa_fisica	= cd_pessoa_destino_w
					and	ie_tipo_corresp		= CASE WHEN ie_forma_ev_w='1' THEN 'MCel' WHEN ie_forma_ev_w='3' THEN 'CI' WHEN ie_forma_ev_w='4' THEN 'Email' END
					and	ie_tipo_doc		= 'AE';
				end if;


				if (qt_corresp_w > 0) then
					ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_destino_w, ie_forma_ev_w);
          --Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
					if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then					
						insert into ev_evento_pac_destino(
							nr_sequencia,
							nr_seq_ev_pac,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_pessoa_fisica,
							ie_forma_ev,
							ie_status,
							dt_ciencia,
							ie_pessoa_destino)
						values (	nextval('ev_evento_pac_destino_seq'),
							nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_pessoa_destino_w,
							ie_forma_ev_w,
							'G',
							null,
							ie_pessoa_destino_w);
					end if;
				end if;
				end;
			end loop;
			close C05;
			end;
			cd_pessoa_destino_w	:= null;
		elsif (ie_pessoa_destino_w	= '15') then
			begin
			select	coalesce(cd_especialidade_dest,0),
				coalesce(cd_especialidade_dest_prof,0),
				cd_pessoa_parecer,
				nr_seq_equipe_dest
			into STRICT	cd_especialidade_dest_w,
				cd_especialidade_dest_prof_w,
				cd_medico_parecer_w,
				nr_seq_equipe_w
			from	parecer_medico_req
			where	nr_parecer = nr_parecer_p;
			
			exception
				when others then
				null;
			end;
			
			open C08;
			loop
			fetch C08 into	
				cd_pessoa_destino_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
				begin
				qt_corresp_w	:= 1;

				if (ie_usuario_aceite_w = 'S') then
					select	count(*)
					into STRICT	qt_corresp_w
					from	pessoa_fisica_corresp
					where	cd_pessoa_fisica	= cd_pessoa_destino_w
					and	ie_tipo_corresp		= CASE WHEN ie_forma_ev_w='1' THEN 'MCel' WHEN ie_forma_ev_w='3' THEN 'CI' WHEN ie_forma_ev_w='4' THEN 'Email' END
					and	ie_tipo_doc		= 'AE';
				end if;


				if (qt_corresp_w > 0) then
					ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_destino_w, ie_forma_ev_w);
					--Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
					if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then										
						insert into ev_evento_pac_destino(
							nr_sequencia,
							nr_seq_ev_pac,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_pessoa_fisica,
							ie_forma_ev,
							ie_status,
							dt_ciencia,
							ie_pessoa_destino)
						values (	nextval('ev_evento_pac_destino_seq'),
							nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_pessoa_destino_w,
							ie_forma_ev_w,
							'G',
							null,
							ie_pessoa_destino_w);
					end if;
				end if;
				end;
			end loop;
			close C08;
		elsif (ie_pessoa_destino_w = '17') then
			select	max(cd_pessoa_fisica)
			into STRICT	cd_pf_destino_w
			from	titulo_pagar
			where	nr_titulo	= nr_titulo_p;
			
			ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pf_destino_w, ie_forma_ev_w);
			--Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
			if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then				
				insert into ev_evento_pac_destino(nr_sequencia,
					nr_seq_ev_pac,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_pessoa_fisica,
					ie_forma_ev,
					ie_status,
					dt_ciencia,
					ie_pessoa_destino)
				values (nextval('ev_evento_pac_destino_seq'),
					nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_pf_destino_w,
					ie_forma_ev_w,
					'G',
					null,
					ie_pessoa_destino_w);
			end if;
		end if;

		if (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '1') then
			begin
			select	count(*)
			into STRICT	qt_corresp_w
			from	pessoa_fisica_corresp
			where	cd_pessoa_fisica	= cd_pessoa_destino_w
			and	ie_tipo_corresp		= 'MCel'
			and	ie_tipo_doc		= 'AE';
			end;
		elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '3') then
			begin
			select	count(*)
			into STRICT	qt_corresp_w
			from	pessoa_fisica_corresp
			where	cd_pessoa_fisica	= cd_pessoa_destino_w
			and	ie_tipo_corresp		= 'CI'
			and	ie_tipo_doc		= 'AE';
			end;
		elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '4') then
			begin
			select	count(*)
			into STRICT	qt_corresp_w
			from	pessoa_fisica_corresp
			where	cd_pessoa_fisica	= cd_pessoa_destino_w
			and	ie_tipo_corresp		= 'Email'
			and	ie_tipo_doc		= 'AE';
			end;
		end if;

		if (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (qt_corresp_w > 0) then
			begin
			ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_destino_w, ie_forma_ev_w);
			--Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
			if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then							
			
				insert into ev_evento_pac_destino(
					nr_sequencia,
					nr_seq_ev_pac,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_pessoa_fisica,
					ie_forma_ev,
					ie_status,
					dt_ciencia,
					ie_pessoa_destino)
				values (	nextval('ev_evento_pac_destino_seq'),
					nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_pessoa_destino_w,
					ie_forma_ev_w,
					'G',
					null,
					ie_pessoa_destino_w);
			end if;
			end;
		end if;
		
		if (cd_pf_destino_w IS NOT NULL AND cd_pf_destino_w::text <> '') and (coalesce(cd_perfil_w::text, '') = '') and (coalesce(cd_setor_atendimento_w::text, '') = '') and (ie_forma_ev_w = '2') then
			begin
			ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pf_destino_w, ie_forma_ev_w);
      --Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
			if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then										
			
				insert into ev_evento_pac_destino(
					nr_sequencia,
					nr_seq_ev_pac,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_pessoa_fisica,
					ie_forma_ev,
					ie_status,
					dt_ciencia,
					ie_pessoa_destino)
				values (	nextval('ev_evento_pac_destino_seq'),
					nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_pf_destino_w,
					ie_forma_ev_w,
					'G',
					null,
					ie_pessoa_destino_w);
			end if;
			
			end;
		end if;

		open C02;
		loop
		fetch C02 into
			cd_pessoa_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then
				ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_regra_w, ie_forma_ev_w);
        --Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
				if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then										
					insert into ev_evento_pac_destino(
						nr_sequencia,
						nr_seq_ev_pac,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_pessoa_fisica,
						ie_forma_ev,
						ie_status,
						dt_ciencia,
						ie_pessoa_destino)
					values (	nextval('ev_evento_pac_destino_seq'),
						nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						cd_pessoa_regra_w,
						ie_forma_ev_w,
						'G',
						null,
						ie_pessoa_destino_w);
				end if;
				
			end if;
			end;
		end loop;
		close C02;

		open C03;
		loop
		fetch C03 into
			cd_pessoa_regra_w,
			nm_usuario_destino_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then
				ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_regra_w, ie_forma_ev_w);
        --Nao possui excecao entao gravar normalmente o alerta (excecao = pessoa nao quer receber alerta)
				if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then														
					insert into ev_evento_pac_destino(
						nr_sequencia,
						nr_seq_ev_pac,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_pessoa_fisica,
						ie_forma_ev,
						ie_status,
						dt_ciencia,
						nm_usuario_dest,
						ie_pessoa_destino)
					values (	nextval('ev_evento_pac_destino_seq'),
						nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						cd_pessoa_regra_w,
						ie_forma_ev_w,
						'G',
						null,
						nm_usuario_destino_w,
						ie_pessoa_destino_w);
				end if;
				
			end if;
			end;
		end loop;
		close C03;
		end;
	end loop;
	close C01;

if (coalesce(ie_commit_p,'N') = 'S') then
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_transf_setor (nr_seq_evento_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_laudo_p bigint, nm_usuario_p text, nr_repasse_terceiro_p bigint default null, ie_iso_precaucao_p text default null, ie_sincrono_p text default null, ds_mensagem_original_p text default null, cd_medico_resp_p text default null, cd_pessoa_parecer_p text default null, nr_seq_gv_p bigint DEFAULT NULL, nr_parecer_p bigint default null, nr_titulo_p bigint default null, nr_seq_baixa_p bigint default null, ie_commit_p text default 'S', nr_seq_interno_p bigint default null, dt_referencia_p timestamp default clock_timestamp()) FROM PUBLIC;

