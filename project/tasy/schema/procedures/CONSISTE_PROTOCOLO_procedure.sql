-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_protocolo (NR_SEQ_PROTOCOLO_P bigint, DS_ERRO_P INOUT text) AS $body$
DECLARE


DS_ERRO_W         		varchar(254) 	:= '';
QT_PARTO_NORMAL_W		bigint		:= 0;
QT_TOTAL_PARTO_W		bigint		:= 0;
QT_CESARIANA_W			bigint		:= 0;
CD_CONVENIO_W			integer		:= 0;
IE_TIPO_CONVENIO_W		smallint		:= 0;
IE_TIPO_PROTOCOLO_W		smallint		:= 0;
CD_ESTABELECIMENTO_W		smallint		:= 0;
PR_CESARIANA_PERMITIDA_W	double precision		:= 0;
PR_CESARIANA_W			double precision		:= 0;
DT_MESANO_REFERENCIA_W		timestamp;
DT_MESANO_APRESENTACAO_W	timestamp;
DT_LIMITE_MIN_ALTA_W		timestamp;
DT_LIMITE_MAX_ALTA_W		timestamp;
QT_LIMITE_MIN_ALTA_W		bigint		:= 0;
QT_LIMITE_MAX_ALTA_W		bigint		:= 0;
nr_atendimento_w		bigint;
nr_atendimento_ant_w		bigint;
nm_pessoa_fisica_w		varchar(60);
nm_pessoa_Anterior_w		varchar(60);
qt_duplos_w			integer	:= 0;
qt_cancelada_w			integer;
qt_leito_uti_w			smallint	:= 0;
qt_max_diaria_uti_w		integer	:= 0;
dt_mesano_ref_w			varchar(7);
qt_real_diaria_uti_w		integer	:= 0;
qt_dias_mes_w			integer	:= 30;
ds_erro_diaria_w		varchar(205);
qt_proced_sadt_w		integer;
dt_alta_w			timestamp;
dt_final_w			timestamp;
qt_datas_dif_w			integer	:= 0;
qt_orgao_emissor_aih_w		smallint	:= 0;
nm_pessoa_itaipu_w		varchar(60);
nr_interno_conta_w		bigint;
cd_pessoa_fisica_w		varchar(10);
qt_registro_w			bigint	:=0;
ds_atendimentos_w		varchar(120);
qt_conv_regra_w			integer;

c01 CURSOR FOR
	SELECT a.nr_atendimento, SUBSTR(OBTER_NOME_PF(c.cd_pessoa_fisica), 0, 60)
	from 	pessoa_fisica c,
		atendimento_paciente b,
		conta_paciente a
	where a.nr_atendimento	 = b.nr_atendimento
	  and b.cd_pessoa_fisica = c.cd_pessoa_fisica
	  and a.nr_seq_protocolo = nr_seq_protocolo_p
	order by 2;

c02 CURSOR FOR
	SELECT distinct(to_char(c.dt_alta,'mm/yyyy'))
	from 	atendimento_paciente c,
     		conta_paciente b
	where b.nr_atendimento = c.nr_atendimento
	and 	b.nr_seq_protocolo = nr_seq_protocolo_p;

c03 CURSOR FOR
	SELECT	c.dt_final,
		b.dt_alta
	from	sus_aih			c,
		atendimento_paciente	b,
		conta_paciente		a
	where	a.nr_atendimento	= b.nr_atendimento
	and	a.nr_interno_conta	= c.nr_interno_conta
	and	a.nr_seq_protocolo	= nr_seq_protocolo_p;

C04 CURSOR FOR
	SELECT	a.nr_atendimento,
		obter_pessoa_atendimento(a.nr_Atendimento,'C'),
		b.nm_pessoa_fisica
	from	conta_paciente a,
		w_usuario_convenio b
	where	a.nr_seq_protocolo	= NR_SEQ_PROTOCOLO_P
	and	OBTER_CODIGO_USUARIO_ATECACO(a.nr_atendimento, a.cd_convenio_parametro)	= b.cd_usuario_convenio;


BEGIN
ds_erro_w			 := '';

begin
Select a.cd_convenio,
	 a.ie_tipo_protocolo,
	 b.ie_tipo_convenio,
	 coalesce(a.dt_mesano_referencia,clock_timestamp())
into STRICT	 cd_convenio_w,
	 ie_tipo_protocolo_w,
	 ie_tipo_convenio_w,
	 dt_mesano_referencia_w
from	 protocolo_convenio a,
	 convenio b
where	 a.nr_seq_protocolo 	= nr_seq_protocolo_p
and	 a.cd_convenio		= b.cd_convenio;
exception
	when others then
		ie_tipo_protocolo_w := 0;
end;


/* CONSISTENCIA PROTOCOLOS INTERNADOS SUS */

if (ie_tipo_convenio_w = 3) 	and (ie_tipo_protocolo_w = 1)	then
	BEGIN

	/* consiste diarias de uti */

	ds_erro_diaria_w := CONSISTE_DIARIA_UTI_SUS(nr_seq_protocolo_p, ds_erro_diaria_w);
	ds_erro_w	:= ds_erro_w || ds_erro_diaria_w;

	/* PERCENTUAL DE CESARIANA SOBRE PARTOS */

	begin
	Select a.cd_estabelecimento
	into STRICT	 cd_estabelecimento_w
	from	 atendimento_paciente a
	where	 a.nr_atendimento =
		 (SELECT max(b.nr_atendimento)
			from	atendimento_paciente b,
				conta_paciente c
			where b.nr_atendimento = c.nr_atendimento
			and	c.nr_seq_protocolo = nr_seq_protocolo_p);
	exception
		when others then
			cd_estabelecimento_w := 1;
	end;

	begin
	Select pr_cesariana_permitida,
		 coalesce(qt_leito_uti,0)
	into STRICT	 pr_cesariana_permitida_w,
		 qt_leito_uti_w
	from	 sus_parametros
	where	 cd_estabelecimento = cd_estabelecimento_w;
	exception
		when others then
			pr_cesariana_permitida_w := 100;
	end;

	/* consistência da quantidade máxima de diária de UTI em um mês de alta */


	/* somente quando qt_leito_uti da sus_parametros  não for nulo e maior de zeros */

	if (qt_leito_uti_w	> 0) then
		BEGIN
		/* Felipe - OS67154 - 03/09/2007 */

		select	PKG_DATE_UTILS.extract_field('DAY', pkg_date_utils.end_of(dt_mesano_ref_w, 'MONTH', 0))
		into STRICT	qt_dias_mes_w
		;

		qt_max_diaria_uti_w := qt_leito_uti_w * qt_dias_mes_w;

		OPEN C02;
		LOOP
		FETCH C02 into
			dt_mesano_ref_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			qt_real_diaria_uti_w := 0;
			select sum(coalesce(c.qt_dia_uti_mes_alta,0))
			into STRICT	 qt_real_diaria_uti_w
			from	 sus_aih c,
				 atendimento_paciente_v b
			where	 b.nr_atendimento			= c.nr_atendimento
			and	 b.ie_tipo_atendimento		= 1
			and	 b.ie_tipo_convenio		= 3
			and	 to_char(b.dt_alta,'mm/yyyy')	= dt_mesano_ref_w
			and	 b.dt_entrada 			> clock_timestamp() - interval '365 days';

			if (qt_real_diaria_uti_w	> qt_max_diaria_uti_w) then
				begin
				ds_erro_w			:= ds_erro_w || '2104(' ||WHEB_MENSAGEM_PCK.get_texto(280571)||dt_mesano_ref_w||') ';
				end;
			end if;
			end;
		END LOOP;
		close c02;
		END;
	end if;


	if (pr_cesariana_permitida_w <> 100) 	and (pr_cesariana_permitida_w > 0) 	then
		BEGIN
		begin
		Select sum(a.qt_procedimento)
		into STRICT 	 qt_parto_normal_w
		from 	 procedimento_paciente a,
			 conta_paciente b
		where  a.nr_interno_conta  	= b.nr_interno_conta
		and	 b.nr_seq_protocolo	= nr_seq_protocolo_p
		and	 a.cd_procedimento in (35001011,35021012,35025018)
		and	 coalesce(a.cd_motivo_exc_conta::text, '') = '';
		exception
			when others then
				qt_parto_normal_w := 0;
		end;

		begin
		Select sum(a.qt_procedimento)
		into STRICT 	 qt_cesariana_w
		from 	 procedimento_paciente a,
			 conta_paciente b
		where  a.nr_interno_conta  	= b.nr_interno_conta
		and	 b.nr_seq_protocolo	= nr_seq_protocolo_p
		/* Felipe - OS 31567 - Incluso o código 35084014 na restrição abaixo*/

		and	 a.cd_procedimento in (35009012,35022019,35026014,35084014)
		and	 coalesce(a.cd_motivo_exc_conta::text, '') = '';
		exception
			when others then
				qt_cesariana_w := 0;
		end;

		qt_total_parto_w	:= (qt_parto_normal_w + qt_cesariana_w);
		if (qt_total_parto_w = 0) then
			qt_total_parto_w := 1;
		end if;
		pr_cesariana_w	:= ((qt_cesariana_w * 100) /	qt_total_parto_w);

		if (pr_cesariana_w > pr_cesariana_permitida_w) then
			ds_erro_w	:= ds_erro_w || '900(' || pr_cesariana_w || '%';
			ds_erro_w	:= ds_erro_w || '/C=' || qt_cesariana_w;
			ds_erro_w	:= ds_erro_w || '/N=' || qt_parto_normal_w ||') ';
		end if;
		END;
	end if;

	/* CONSISTENCIA se há pelo menos um SADT no protocolo AIH*/

	select 	count(*)
	into STRICT	qt_proced_sadt_w
	from	procedimento_paciente b,
		sus_valor_proc_paciente a,
		conta_paciente c
	where	nr_seq_protocolo 	= nr_seq_protocolo_p
	and	c.nr_interno_conta	= b.nr_interno_conta
	and	b.nr_sequencia		= a.nr_sequencia
	and	a.qt_ato_medico		> 0
	and	b.ie_origem_proced	= 2
	and	b.cd_procedimento between 00000001 and 23999999
	and	coalesce(c.ie_cancelamento::text, '') = ''
	and	coalesce(b.cd_motivo_exc_conta::text, '') = '';
	if (qt_proced_sadt_w	= 0) then
		ds_erro_w	:= ds_erro_w || '916 ';
	end if;

	/*Data final da AIH diferente da data da alta do paciente*/

	OPEN C03;
		LOOP
		FETCH C03 into
			dt_alta_w,
			dt_final_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			if (dt_final_w IS NOT NULL AND dt_final_w::text <> '') and (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') and (PKG_DATE_UTILS.start_of(dt_final_w, 'dd', 0) <> PKG_DATE_UTILS.start_of(dt_alta_w, 'dd', 0)) then
				qt_datas_dif_w	:= qt_datas_dif_w + 1;
			end if;
			end;
		END LOOP;
		close c03;
	if (qt_datas_dif_w	> 0) then
		ds_erro_w	:= ds_erro_w || '905 ';
	end if;

	/*Orgão emissor AIH no SUS_PARAMETROS não pode ter mais do que 7 dígitos*/

	
	begin
	select	coalesce(length(cd_orgao_emissor_aih),0)
	into STRICT	qt_orgao_emissor_aih_w
	from	sus_parametros
	where	cd_estabelecimento	= cd_estabelecimento_W;
	exception when no_data_found then
		begin
		select	coalesce(length(cd_orgao_emissor_aih),0)
		into STRICT	qt_orgao_emissor_aih_w
		from	sus_parametros_aih
		where	cd_estabelecimento	= cd_estabelecimento_w;
		exception when no_data_found then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(280573);
		end;
	end;
	if (qt_orgao_emissor_aih_w	> 7) or (qt_orgao_emissor_aih_w = 0) then
		ds_erro_w	:= ds_erro_w || '906 ';
	end if;
	end;
end if;


/* CONSISTENCIA ALTA EM RELACAO A DATA DE APRESENTACAO */

dt_mesano_apresentacao_w := PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_w, 1, 0),'month',0);
dt_limite_min_alta_w := PKG_DATE_UTILS.get_Time(dt_mesano_apresentacao_w - 185, 0, 0, 0);
dt_limite_max_alta_w := PKG_DATE_UTILS.get_Time(dt_mesano_apresentacao_w - 1, 23, 59, 59);

/* CONSISTENCIA ALTA COM MAIS DE 185 DIAS EM RELACAO A DATA DE APRESENTACAO */

begin
select 	count(*)
into STRICT		qt_limite_min_alta_w
from 		conta_paciente a,
		atendimento_paciente b
where		a.nr_atendimento		= b.nr_atendimento
and 		a.nr_seq_protocolo	= nr_seq_protocolo_p
and		coalesce(b.dt_alta,clock_timestamp())	< dt_limite_min_alta_w;
exception
		when others then
			qt_limite_min_alta_w := 0;
end;

if (qt_limite_min_alta_w > 0) then
	begin
	ds_erro_w			:= ds_erro_w || '902 ';
	update 	conta_paciente x
	set 		x.ds_inconsistencia = substr(x.ds_inconsistencia||'761 ',1,255)
	where 	x.nr_interno_conta in (SELECT 	a.nr_interno_conta
			from 		conta_paciente a,
					atendimento_paciente b
			where		a.nr_atendimento		= b.nr_atendimento
			and 		a.nr_seq_protocolo	= nr_seq_protocolo_p
			and		coalesce(b.dt_alta,clock_timestamp())	< dt_limite_min_alta_w);
	exception
			when others then
			qt_limite_min_alta_w := qt_limite_min_alta_w;
	end;
end if;


/* CONSISTENCIA MES/ANO ALTA IGUAL MES/ANO DA APRESENTACAO */

begin
select 	count(*)
into STRICT		qt_limite_max_alta_w
from 		conta_paciente a,
		atendimento_paciente b
where		a.nr_atendimento		= b.nr_atendimento
and 		a.nr_seq_protocolo	= nr_seq_protocolo_p
and		coalesce(b.dt_alta,clock_timestamp())	> dt_limite_max_alta_w;
exception
		when others then
			qt_limite_max_alta_w := 0;
end;

if (qt_limite_max_alta_w > 0) then
	begin
	ds_erro_w			:= ds_erro_w || '903 ';
	update 	conta_paciente x
	set 		x.ds_inconsistencia = substr(x.ds_inconsistencia||'762 ',1,255)
	where 	x.nr_interno_conta in (SELECT 	a.nr_interno_conta
			from 		conta_paciente a,
					atendimento_paciente b
			where		a.nr_atendimento		= b.nr_atendimento
			and 		a.nr_seq_protocolo	= nr_seq_protocolo_p
			and		coalesce(b.dt_alta,clock_timestamp())	> dt_limite_max_alta_w);
	exception
			when others then
			qt_limite_max_alta_w := qt_limite_max_alta_w;
	end;
end if;

/* CONSISTENCIA de Homonimos (Pacientes com mesmo nome no Protocolo */

nm_pessoa_anterior_w		:= '';
nr_atendimento_ant_w		:= 0;
qt_duplos_w				:= 0;
OPEN C01;
LOOP
FETCH C01 into
	nr_atendimento_w,
	nm_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (nm_pessoa_fisica_w = nm_pessoa_anterior_w) then
		begin
		qt_duplos_w			:= qt_duplos_w + 1;
		update Conta_paciente
		set ds_inconsistencia 	= substr(ds_inconsistencia || '904 ',1,255)
		where nr_seq_protocolo 	= nr_seq_protocolo_p
		  and nr_atendimento in (nr_atendimento_w, nr_atendimento_ant_w)
		  and ((coalesce(ds_inconsistencia::text, '') = '') or (not ds_inconsistencia like '%904%'));
		end;
	end if;
	nm_pessoa_anterior_w	:= nm_pessoa_fisica_w;
	nr_atendimento_ant_w	:= nr_atendimento_w;
	end;
END LOOP;
close c01;
if (qt_duplos_w > 0) then
	ds_erro_w			:= 	ds_erro_w || '904 ';
end if;

/* CONSISTENCIA de Contas canceladas/Estornadas */

select	count(*)
into STRICT	qt_cancelada_w
from conta_paciente
where nr_seq_protocolo	= nr_seq_protocolo_p
and ie_cancelamento in ('C','E');
if (qt_cancelada_w > 0) then
	ds_erro_w			:= 	ds_erro_w || '910 ';
end if;


select	count(*)
into STRICT	qt_conv_regra_w
from	regra_validacao_usuario
where	cd_convenio = cd_convenio_w
and 	upper(ds_procedure_validacao) = 'CONSISTE_USUARIO_ITAIPU';
if (qt_conv_regra_w <> 0) then
	open C04;
	loop
	fetch C04 into
		nr_atendimento_w,
		cd_pessoa_fisica_w,
		nm_pessoa_itaipu_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */

		if (upper(Elimina_Acentuacao(obter_nome_itaipu(cd_pessoa_fisica_w,null))) <>
			obter_nome_itaipu(null,upper(Elimina_Acentuacao(nm_pessoa_itaipu_w)))
			and coalesce(nr_atendimento_w,0) <> 0 
			and length(coalesce(ds_atendimentos_w || nr_atendimento_w,'0')) < 114) then
			qt_registro_w	:= qt_registro_w+1;
			ds_atendimentos_w	:= ds_atendimentos_w||','|| nr_atendimento_w;
		end if;
	end loop;
	close C04;
end if;
if (qt_registro_w	> 0) then
	ds_erro_w	:= ds_erro_w|| '3001('||ds_atendimentos_w||')';
end if;


/* Felipe - OS 58582 - 31/05/2007 - Passando 999 fixo pois não existe ie_tipo_atendimento_p para o protocolo */

ds_erro_w := restringir_inconsistencia(cd_estabelecimento_w, cd_convenio_w, null, 999, 99, null, ds_erro_w);

/* Atualizar Protocolo com a Inconsistencia */

begin
update 	protocolo_convenio
set		dt_consistencia	= clock_timestamp(),
		ds_inconsistencia	= substr(ds_erro_w,1,80)
where		nr_seq_protocolo	= nr_seq_protocolo_p;
end;

commit;

ds_erro_p	:= ds_erro_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_protocolo (NR_SEQ_PROTOCOLO_P bigint, DS_ERRO_P INOUT text) FROM PUBLIC;
