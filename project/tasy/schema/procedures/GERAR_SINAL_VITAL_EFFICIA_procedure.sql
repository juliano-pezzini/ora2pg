-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (		nm_sinal_vital	varchar(100),
				vl_sinal_vital	varchar(100),
				nm_codigo			varchar(100),
				ds_unidade_medida	varchar(100),
				ds_lista		varchar(255));


CREATE OR REPLACE PROCEDURE gerar_sinal_vital_efficia ( cd_pessoa_fisica_p text, dt_sinal_vital_p text, ds_lista_parametros_p text, ds_lista_parametros2_p text, nm_usuario_p text, cd_setor_atendimento_p text default null, cd_unidade_basica_p text default null, cd_unidade_compl_p text default null) AS $body$
DECLARE

type Vetor is table of campos index 	by integer;
Vetor_w			Vetor;



nr_atendimento_w	bigint;
dt_sinal_vital_w	timestamp;
nr_seq_sinal_vital_w	bigint	:= 0;
ds_sep_w		varchar(100)	:= ';';
nr_pos_separador_w	bigint;
qt_parametros_w		bigint;
qt_contador_w		bigint;
ds_parametros_w		varchar(32000);
i			integer;
ds_lista_aux_w		varchar(255);
ds_sep_bv_w		varchar(30)	:= obter_separador_bv;
nr_seq_monit_resp_w	bigint	:= 0;
nr_seq_monit_hemo_w	bigint	:= 0;
cd_modalidade_w		varchar(15);
ie_respiracao_w		varchar(7);
ds_erro_w		varchar(4000);
qt_minutos_w		bigint;
qt_min_philips_w		bigint;
qt_reg_w			bigint;
cd_estabelecimento_w	bigint;
nr_cirurgia_w			bigint;
nr_seq_pepo_w			bigint;
nr_atendimento_cirur_w	bigint;
cd_pessoa_fisica_w		varchar(10):= cd_pessoa_fisica_p;
nr_seq_interno_w	bigint;
ds_param_integ_hl7_w	varchar(4000);
cd_setor_atendimento_w	integer;
ie_rpa_w				varchar(1);
ie_tem_sv_periodo_w     char(1);
ie_exige_aprovacao_w    varchar(2);
ie_retorno_valida_sv_w  varchar(10)   := '';
ds_retorno_valida_sv_w  varchar(2000) := '';
ExigeAprovacaoNao       varchar(2)    := 'N';
ExigeAprovacaoSim       varchar(2)    := 'S';
ExigeAprovacaoForaFaixa varchar(2)    := 'C';
executarByClassifLeito  varchar(10);


	procedure inserir_sv is
	;
BEGIN
	
	if (nr_seq_sinal_vital_w	= 0) then

		select	nextval('atendimento_sinal_vital_seq')
		into STRICT	nr_seq_sinal_vital_w
		;
		insert into atendimento_sinal_vital(	nr_sequencia,
							nr_atendimento,
							dt_sinal_vital,
							dt_atualizacao,
							nm_usuario,
							CD_PESSOA_FISICA,
							dt_liberacao,
							ie_importado,
							ie_situacao,
							nr_cirurgia,
							nr_seq_pepo,
							ie_integracao,
							cd_setor_atendimento,
							ie_rpa)
				values (	nr_seq_sinal_vital_w,
							nr_atendimento_w,
							dt_sinal_vital_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							null,
							'S',
							'A',
							nr_cirurgia_w,
							nr_seq_pepo_w,
							'S',
							cd_setor_atendimento_w,
							ie_rpa_w);

	end if;
	end;

	procedure inserir_resp is
	begin
	if (nr_seq_monit_resp_w	= 0) then

		select	nextval('atendimento_monit_resp_seq')
		into STRICT	nr_seq_monit_resp_w
		;

		insert into ATENDIMENTO_MONIT_RESP(	nr_sequencia,
							nr_atendimento,
							DT_MONITORIZACAO,
							dt_atualizacao,
							nm_usuario,
							CD_PESSOA_FISICA,
							dt_liberacao,
							ie_importado,
							ie_situacao,
							nr_cirurgia,
							nr_seq_pepo,
							ie_integracao,
							cd_setor_atendimento)
				values (	nr_seq_monit_resp_w,
							nr_atendimento_w,
							dt_sinal_vital_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							null,
							'S',
							'A',
							nr_cirurgia_w,
							nr_seq_pepo_w,
							'S',
							cd_setor_atendimento_w);
	end if;
	end;


	procedure inserir_hemo is
	begin
	if (nr_seq_monit_hemo_w	= 0) then

		select	nextval('atend_monit_hemod_seq')
		into STRICT	nr_seq_monit_hemo_w
		;

		insert into ATEND_MONIT_HEMOD(	nr_sequencia,
							nr_atendimento,
							DT_MONITORACAO,
							dt_atualizacao,
							nm_usuario,
							CD_PESSOA_FISICA,
							dt_liberacao,
							ie_importado,
							ie_situacao,
							nr_cirurgia,
							nr_seq_pepo,
							ie_integracao,
							cd_setor_atendimento)
				values (	nr_seq_monit_hemo_w,
							nr_atendimento_w,
							dt_sinal_vital_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							null,
							'S',
							'A',
							nr_cirurgia_w,
							nr_seq_pepo_w,
							'S',
							cd_setor_atendimento_w);
	end if;
	end;


	procedure atualizar_valor_sv(	nm_tabela_p	varchar2,
					nm_atributo_p	varchar2,
					vl_parametro_p	varchar2) is
	ds_comando_w	varchar2(2000);
	ds_parametros_w	varchar2(2000);
	vl_parametro_w	varchar2(2000);
	begin
	ds_comando_w	:= 	'	update	'||nm_tabela_p	||
				'	set	'||nm_atributo_p||' = :vl_parametro'||
				'	where	nr_sequencia	= :nr_sequencia ';
	begin
	vl_parametro_w	:= vl_parametro_p;
	if	((substr(nm_atributo_p,1,2)	= 'QT') or (substr(nm_atributo_p,1,2)	= 'PR') or (substr(nm_atributo_p,1,2)	= 'VL') or (substr(nm_atributo_p,1,2)	= 'TX')) then
		vl_parametro_w	:= replace(vl_parametro_w,'.',',');
	end if;
	if (nm_tabela_p	= 'ATENDIMENTO_SINAL_VITAL') and (vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') and (lower(vl_parametro_p)	<> 'null')then
		inserir_sv;
		
		ds_parametros_w:=	'vl_parametro='||vl_parametro_w||ds_sep_bv_w||
					'nr_sequencia='||nr_seq_sinal_vital_w||ds_sep_bv_w;

		CALL Exec_sql_Dinamico_bv(nm_usuario_p,ds_comando_w,ds_parametros_w);
	elsif (nm_tabela_p	= 'ATENDIMENTO_MONIT_RESP') and (vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') and (lower(vl_parametro_p)	<> 'null')then
		inserir_resp;
		ds_parametros_w:=	'vl_parametro='||vl_parametro_w||ds_sep_bv_w||
					'nr_sequencia='||nr_seq_monit_resp_w||ds_sep_bv_w;

		CALL Exec_sql_Dinamico_bv(nm_usuario_p,ds_comando_w,ds_parametros_w);
	elsif (nm_tabela_p	= 'ATEND_MONIT_HEMOD') and (vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') and (lower(vl_parametro_p)	<> 'null')then
		inserir_hemo;
		ds_parametros_w:=	'vl_parametro='||vl_parametro_w||ds_sep_bv_w||
					'nr_sequencia='||nr_seq_monit_hemo_w||ds_sep_bv_w;

		CALL Exec_sql_Dinamico_bv(nm_usuario_p,ds_comando_w,ds_parametros_w);
	end if;

	exception
		when others then
		ds_erro_w		:= sqlerrm(SQLSTATE);

	end;

	end;
	
	procedure gerar_passagem_setor(nr_atendimento_param number, nr_seq_interno_param number, cd_setor_atend_param number) is
	
	begin

	
	ds_param_integ_hl7_w := 'nr_atendimento=' || nr_atendimento_param || ds_sep_bv_w ||
					'nr_seq_interno=' || nr_seq_interno_param || ds_sep_bv_w||
					'cd_pessoa_fisica=' || cd_pessoa_fisica_w || ds_sep_bv_w;
	CALL gravar_agend_integracao(67, ds_param_integ_hl7_w, cd_setor_atend_param);
	
	commit;
	end;
	
begin

begin
dt_sinal_vital_w := to_date(dt_sinal_vital_p, 'yyyymmddhh24miss');
exception
	when others then
	dt_sinal_vital_w	:= clock_timestamp();
end;

if (nm_usuario_p = 'EFFICIA ATEND') then
	nr_atendimento_w := (cd_pessoa_fisica_p)::numeric;
else
	select 	max(nr_atendimento)
	into STRICT 	nr_atendimento_w
	from 	atendimento_paciente
	where 	cd_pessoa_fisica  = cd_pessoa_fisica_p
	and		dt_alta_interno  = TO_DATE('30/12/2999','dd/mm/yyyy')
	and		ie_tipo_atendimento in (1,3);
	
	if (coalesce(nr_atendimento_w::text, '') = '') then
		select 	max(nr_atendimento)
		into STRICT 	nr_atendimento_w
		from 	atendimento_paciente
		where 	cd_pessoa_fisica  = cd_pessoa_fisica_p
		and		dt_alta_interno  = TO_DATE('30/12/2999','dd/mm/yyyy');
	end if;
end if;

select obter_regra_classif_pac_leito(nr_atendimento_w, dt_sinal_vital_w) into STRICT executarByClassifLeito;

if (executarByClassifLeito = 'S') then

select	max(nr_cirurgia),
		max(nr_seq_pepo)
into STRICT	nr_cirurgia_w,
		nr_seq_pepo_w
from	cirurgia
where	nr_atendimento = nr_atendimento_w
and		dt_sinal_vital_w between dt_inicio_real and coalesce(dt_termino, dt_sinal_vital_w);



if (coalesce(nr_cirurgia_w::text, '') = '') and (coalesce(nr_seq_pepo_w::text, '') = '') then
	select	max(nr_cirurgia),
			max(nr_seq_pepo)
	into STRICT	nr_cirurgia_w,
			nr_seq_pepo_w
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_w
	and		dt_sinal_vital_w between dt_entrada_unidade and coalesce(dt_saida_unidade, dt_sinal_vital_w);
end if;

ds_parametros_w    := ds_lista_parametros_p||ds_lista_parametros2_p;
ds_parametros_w	   := replace(ds_parametros_w,'null','');
i	:= 0;

while(length(ds_parametros_w) > 0) loop
	begin
	i	:= i+1;
	if (position(';' in ds_parametros_w)	>0)  then
		Vetor_w[i].ds_lista	:= substr(ds_parametros_w,1,position(';' in ds_parametros_w)-1 );
		ds_parametros_w	:= substr(ds_parametros_w,position(';' in ds_parametros_w)+1,40000);

	else
		Vetor_w[i].ds_lista	:=substr(ds_parametros_w,1,length(ds_parametros_w) - 1);
		ds_parametros_w	:= null;
	end if;

	end;
end loop;

RAISE NOTICE '%', Vetor_w.count;




for j in 1..Vetor_w.count loop
	begin

	ds_lista_aux_w	:= Vetor_w[j].ds_lista;

	Vetor_w[j].nm_sinal_vital	:= substr(ds_lista_aux_w,1,position('#@#@' in ds_lista_aux_w)-1 );
	RAISE NOTICE 'nm_sinal_vital = %', Vetor_w[j].nm_sinal_vital;
	
	ds_lista_aux_w	:= substr(ds_lista_aux_w,position('#@#@' in ds_lista_aux_w)+4,40000);
	Vetor_w[j].ds_unidade_medida	:= substr(ds_lista_aux_w,1,position('#@#@' in ds_lista_aux_w)- 1 );
	ds_lista_aux_w	:= substr(ds_lista_aux_w,position('#@#@' in ds_lista_aux_w)+4,40000);
	
	Vetor_w[j].nm_codigo	:= substr(ds_lista_aux_w,1,position('#@#@' in ds_lista_aux_w)- 1 );
	
	RAISE NOTICE 'nm_codigo = %', Vetor_w[j].nm_codigo;
	ds_lista_aux_w	:= substr(ds_lista_aux_w,position('#@#@' in ds_lista_aux_w)+4,40000);

	
	
	Vetor_w[j].vl_sinal_vital	:= substr(ds_lista_aux_w,1,4000 );
	
	
	
	end;
end loop;

select	coalesce(max(cd_estabelecimento),1)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w;

cd_setor_atendimento_w := obter_setor_atendimento(nr_atendimento_w);

select  coalesce(MAX(qt_min_philips),0),
	coalesce(max(ie_rpa),'N')
into STRICT	qt_min_philips_w,
	ie_rpa_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_w;

if (qt_min_philips_w > 0) then
	qt_minutos_w := qt_min_philips_w;	
else

	select	coalesce(max(QT_MIN_PHILIPS),120)
	into STRICT	qt_minutos_w
	from	parametro_medico
	where	cd_estabelecimento = cd_estabelecimento_w;
	
end if;


select	coalesce(max('S'), 'N')
into STRICT	ie_tem_sv_periodo_w
from	atendimento_sinal_vital a
where	a.nr_atendimento	= nr_atendimento_w
and	    coalesce(a.dt_inativacao::text, '') = ''
and	    a.dt_sinal_vital between dt_sinal_vital_w - (1/24/60)* qt_minutos_w and dt_sinal_vital_w
and	    a.nm_usuario = nm_usuario_p;


if ((nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and ie_tem_sv_periodo_w = 'N') then

	for i in 1..Vetor_w.count loop
		begin

		if (Vetor_w[i].nm_codigo	= '0002-0101') then	-- I
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','D1');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0102') then	-- II
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','D2');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0103') then	-- V1
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V1');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0104') then	-- V2
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V2');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0105') then	-- V3
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V3');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0106') then	-- V4
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V4');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0107') then	-- V5
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V5');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0108') then	-- V6
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V6');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-013d') then	-- III
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','D3');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-013e') then	-- aVR
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','aVR');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-013f') then	-- aVL
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','aVL');	
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0140') then	-- aVF
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','aVF');	
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0301') then	-- ST-I
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','D1');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0302') then	-- ST-II
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','D2');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0303') then	-- ST-V1
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V1');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0304') then	-- ST-V2
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V2');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0305') then	-- ST-V3
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V3');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0306') then	-- ST-V4
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V4');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0307') then	-- ST-V5
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V5');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0308') then	-- ST-V6
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','V6');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-033d') then	-- ST-III
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','D3');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-033e') then	-- ST-aVR
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','aVR');
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-033f') then	-- ST-aVL
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','aVL');	
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-0340') then	-- ST-aVF		
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_DERIVACAO_SEG_ST','aVF');	
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SEGMENTO_ST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4182') then	-- btbHR
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARD_MONIT',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARDIACA',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4822') then	-- Pulse
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARDIACA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARD_MONIT',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4900') then	-- SVRI
			atualizar_valor_sv('ATEND_MONIT_HEMOD','TX_RV_SISTEMICA',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-490c') then	-- C.I.
			atualizar_valor_sv('ATEND_MONIT_HEMOD','TX_INDICE_CARD',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4a05') then	-- NBPs
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_SISTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','C');	
		elsif (Vetor_w[i].nm_codigo	= '0002-4a06') then	-- NBPd
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_DIASTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','C');
		elsif (Vetor_w[i].nm_codigo	= '0002-4a07') then	-- NBPm
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PAM',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','C');			
		elsif (Vetor_w[i].nm_codigo	= '0002-4a11') then	-- ARTs
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_SISTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','I');
		elsif (Vetor_w[i].nm_codigo	= '0002-4a12') then	-- ARTd
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_DIASTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','I');
		elsif (Vetor_w[i].nm_codigo	= '0002-4a13') then	-- ARTm
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PAM',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','I');			
		elsif (Vetor_w[i].nm_codigo	= '0002-4a15') then	-- ABPs
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_SISTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','I');	
		elsif (Vetor_w[i].nm_codigo	= '0002-4a16') then	-- ABPd
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PA_DIASTOLICA',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','I');	
		elsif (Vetor_w[i].nm_codigo	= '0002-4a17') then	--ABPm
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PAM',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_APARELHO_PA','I');			
		elsif (Vetor_w[i].nm_codigo	= '0002-4a1d') then	-- PAPs
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_SIST_AP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-4a1e') then	-- PAPd
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_DIAST_AP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-4a1f') then	-- PAPm
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_PA_MEDIA_AP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4a33') then	-- LAPm
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PAE',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4a47') then	-- CVPm
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PVC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b04') then	-- C.O.
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_DEBITO_CARD',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b28') then	-- SVR
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_RV_SISTEMICA',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b3c') then	-- SvO2
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_SATUR_VEN_MISTA_OXIGENIO',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b64') then	-- Tesoph
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',2);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b6c') then	-- Tnaso
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',6);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b74') then	-- Tskin
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',4);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b78') then	-- Ttymp
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',5);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b7c') then	-- Tven
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',10);
		elsif (Vetor_w[i].nm_codigo	= '0002-f0c7') then	-- Tven
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',1);
		elsif (Vetor_w[i].nm_codigo	= '0002-4b84') then	-- SV
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_VOLUME_SIST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-4bb8') then	-- SpO2
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_SATURACAO_O2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-5000') then	-- Resp
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_FREQ_RESP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_RESP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-500a') then	-- RR
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_FREQ_RESP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_RESP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-5012') then	-- awRR
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_FREQ_VENT',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-50b0') then	-- etCO2
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_CO2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-50dd') then	-- PIF
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_FLUXO_INSP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-50e8') then	-- Pplat
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_PPLATO',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-5100') then	-- iPEEP
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_AUTO_PEEP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-5109') then	-- PIP
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_PIP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-510b') then	-- MnAwP
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_PVA',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-513c') then	-- TV
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_VCI',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-51a8') then	-- PEEP
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_PEEP',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-522c') then	-- etN2O
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_OXIDO_NITROSO_EXP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-5280') then	-- inN2O
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_OXIDO_NITROSO_INSP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-5284') then	-- inO2
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_OXIDO_NITROSO_INSP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-5378') then	-- etO2
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_OXIDO_NITROSO_EXP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-538c') then	-- etAGT
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_HALOG_EXP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-5390') then	-- inAGT
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_HALOG_INS',Vetor_w[i].vl_sinal_vital);		
		elsif (Vetor_w[i].nm_codigo	= '0002-5804') then	-- CPP
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PPC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-7498') then	-- FIO2
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_FIO2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-e004') then	-- Trect
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',3);
		elsif (Vetor_w[i].nm_codigo	= '0002-e014') then	-- Tblood
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',10);
		elsif (Vetor_w[i].nm_codigo	= '0002-f04e') then	-- BIS
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_MAEC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f0b7') then	-- IC1m
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_PRESSAO_INTRA_CRANIO',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f0e3') then	-- PPV
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_DELTA_PP',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-f0e5') then	-- Pulse
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_FREQ_CARDIACA',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f100') then	-- ScvO2
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_SAT_VENOSA_O2',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f110') then	-- pToral
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TEMP',Vetor_w[i].vl_sinal_vital);
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','IE_SITIO',9);
		elsif (Vetor_w[i].nm_codigo	= '0002-f897') then	-- TOFrat
			atualizar_valor_sv('ATENDIMENTO_SINAL_VITAL','QT_TOF_BLOQ_NEURO_MUSC',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f899') then	-- Rdyn
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_RSR',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f8a1') then	-- ExpTi
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_TE',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f8a3') then	-- InsTi
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_TI',Vetor_w[i].vl_sinal_vital);	
		elsif (Vetor_w[i].nm_codigo	= '0002-5148') then	-- MINVOL
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_VMIN',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-508c') then	-- Cdyn
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_CDYN',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-5090') then	-- Cstat
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_CST',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0002-f05d') then	-- MAC
			atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','QT_CAM',Vetor_w[i].vl_sinal_vital);			
		elsif (Vetor_w[i].nm_codigo	= '0002-4b40') then	-- AaDO2
			atualizar_valor_sv('ATEND_MONIT_HEMOD','QT_CONT_ART_VEN_OXIG',Vetor_w[i].vl_sinal_vital);
		elsif (Vetor_w[i].nm_codigo	= '0402-f8f5') then	-- sMode
			begin
			if (Vetor_w[i].vl_sinal_vital	= 'D002-0001') then
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'VCV';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0002') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'PCV';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0003') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'PSV + CPAP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0004') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'SIMVV';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0005') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'SIMVP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0006') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'MMV + PSV';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0007') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'PSV + VTA';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0008') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'APRV';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0009') then	
				atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','IE_RESPIRACAO','VMNI');
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-000A') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'TCPL';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-000B') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'TCPL + SIMVP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-000C') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'CPAP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-000D') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'VCV RESP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-000E') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'PCV RESP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-000F') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'TCPL RESP';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0010') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'EMERG';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0011') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'PRVC';
			elsif (Vetor_w[i].vl_sinal_vital	= 'D002-0012') then	
				select	max(cd_modalidade)
				into STRICT	cd_modalidade_w
				from	MODALIDADE_VENTILATORIA
				where	CD_MOD_INTEGRACAO = 'ESPERA';
			end if;
			if (cd_modalidade_w IS NOT NULL AND cd_modalidade_w::text <> '') then	
				atualizar_valor_sv('ATENDIMENTO_MONIT_RESP','CD_MOD_VENT',cd_modalidade_w);
			end if;
			end;

		end if;
	
		end;
	end loop;

end if;
commit;

/*

		elsif	(Vetor_w(i).nm_sinal_vital	= 'Cuff') then
		elsif	(Vetor_w(i).nm_sinal_vital	= 'ETR') then		
*/
	if (coalesce(nr_seq_sinal_vital_w,0) > 0) then
		begin
    CALL release_vital_sign_integration(nr_seq_sinal_vital_w, nr_seq_monit_hemo_w, nr_seq_monit_resp_w, nr_atendimento_w, cd_estabelecimento_w);
		exception
		when others then
			update atendimento_sinal_vital set dt_liberacao = clock_timestamp() where nr_sequencia = nr_seq_sinal_vital_w;
			update atendimento_monit_resp  set dt_liberacao = clock_timestamp() where nr_sequencia = nr_seq_monit_resp_w;
			update atend_monit_hemod       set dt_liberacao = clock_timestamp() where nr_sequencia = nr_seq_monit_hemo_w;
			commit;
		end;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_sinal_vital_efficia ( cd_pessoa_fisica_p text, dt_sinal_vital_p text, ds_lista_parametros_p text, ds_lista_parametros2_p text, nm_usuario_p text, cd_setor_atendimento_p text default null, cd_unidade_basica_p text default null, cd_unidade_compl_p text default null) FROM PUBLIC;
