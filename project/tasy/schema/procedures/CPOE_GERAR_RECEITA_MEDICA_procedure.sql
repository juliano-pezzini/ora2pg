-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_receita_medica ( cd_profissional_p text, dt_receita_p timestamp, ie_tipo_receita_p text, nr_seq_formatacao_p bigint, ds_medicamento_p text, nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_erro_p INOUT text, nr_sequencia_p bigint) AS $body$
DECLARE


ds_masc_receita_w	varchar(2000);
ds_receita_final_w	varchar(32000)	:= '';
ds_receita_parcial_w	varchar(32000);
ds_medicamento_w	varchar(2000);

ds_material_w		varchar(2000);
qt_dose_w		double precision;
cd_unidade_medida_w	varchar(50);
ds_unidade_medida_w	varchar(50);
ie_via_aplicacao_w	varchar(50);
cd_intervalo_w		varchar(20);
ds_intervalo_w		varchar(80);
ds_fim_uso_w		varchar(100);
ds_observacao_w		varchar(2000);

nr_atendimento_w	bigint;
ds_enter_padrao_w	varchar(20)	:= chr(13)||chr(10);
ds_enter_w		varchar(20)	:= ' \par\par ';

ds_cabecalho_w		varchar(2000);
ds_rodape_w		varchar(1);
ds_fonte_w		varchar(100);
ds_tam_fonte_w		varchar(10);
nr_tam_fonte_w		integer;
cd_estabelecimento_w	smallint;
nr_dias_uso_w		integer;
ds_via_aplicacao_w	varchar(80);
qt_tamanho_w		bigint;
ds_horarios_w		varchar(2000);
ds_masc_receita_html_w	varchar(4000);

ds_receita_w		med_receita.ds_receita%type;
ds_quebra_linha_w	varchar(1) := chr(10);

c01 CURSOR FOR
	SELECT	substr(coalesce(b.ds_reduzida, b.ds_material),1,2000),
			a.qt_dose,
			a.cd_unidade_medida,
			a.ie_via_aplicacao,
			a.cd_intervalo,
			substr(obter_desc_intervalo_prescr(a.cd_intervalo),1,80),
			substr(a.ds_observacao,1,2000),
			substr(obter_unidade_medida(a.cd_unidade_medida),1,40),
			substr(Obter_Via_Aplicacao(a.ie_via_aplicacao,'D'),1,70),
			substr(a.ds_horarios,1,2000)
	from	cpoe_material a,
			material b
	where	a.cd_pessoa_fisica	 = cd_pessoa_fisica_p
	and		a.cd_material	= b.cd_material
	and		((obter_se_contido_char(a.nr_sequencia,ds_medicamento_p) = 'S') or (a.nr_sequencia = nr_sequencia_p))
	and		coalesce(a.dt_suspensao::text, '') = ''
	order by 1;	


BEGIN

if (nr_seq_formatacao_p = 0) then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277302);
elsif (coalesce(ds_medicamento_p::text, '') = '') and (coalesce(nr_sequencia_p::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277303);		
elsif (coalesce(ie_tipo_receita_p::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277304);
elsif (coalesce(cd_profissional_p::text, '') = '') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277305);
elsif (obter_se_medico(cd_profissional_p, 'M') = 'N') then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(277306);
else

	if (nr_atendimento_p > 0) then
		nr_atendimento_w := nr_atendimento_p;
	else
		select	max(nr_atendimento)
		into STRICT	nr_atendimento_w
		from   	atendimento_paciente
		where  	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and		ie_fim_conta		<> 'F'
		and		coalesce(dt_alta::text, '') = '';
	end if;

	/* seleciona a formatacao da receita medica */

	select	ds_receita,
            ds_receita_novo
	into STRICT	ds_masc_receita_w,
            ds_masc_receita_html_w
	from	medic_mascara_receita
	where	nr_sequencia	= nr_seq_formatacao_p;
	
	if (ds_masc_receita_html_w IS NOT NULL AND ds_masc_receita_html_w::text <> '') then
		ds_masc_receita_w := ds_masc_receita_html_w;
		ds_enter_w := ' <br> ';
	end if;
	
	/* tratamento dos medicamentos */
	
	ds_medicamento_w	:= substr(' ' || ds_medicamento_p || ' ',1,2000);
	ds_medicamento_w	:= replace(ds_medicamento_w, ',',' ');
	ds_medicamento_w	:= replace(ds_medicamento_w, '  ',' ');	
	
	/* leitura dos medicamentos e geracao da receita */

	open c01;
	loop
	fetch c01 into
		ds_material_w,
		qt_dose_w,
		cd_unidade_medida_w,
		ie_via_aplicacao_w,
		cd_intervalo_w,
		ds_intervalo_w,
		ds_observacao_w,
		ds_unidade_medida_w,
		ds_via_aplicacao_w,
		ds_horarios_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		ds_receita_parcial_w	:= ds_masc_receita_w;
		
		if (position('{' in ds_material_w) > 0) or (position('}' in ds_material_w) > 0) then
			ds_material_w := replace(ds_material_w,'{','#$');
			ds_material_w := replace(ds_material_w,'}','$#');
		end if;		
		
		
		select	retorna_medic_formatado(ds_receita_parcial_w,'@Medicamento',ds_material_w)
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@Dose',qt_dose_w)
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@DsUnidMedDose',ds_unidade_medida_w)
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@UnidMedDose',cd_unidade_medida_w)
		into STRICT	ds_receita_parcial_w
		;		
		select	retorna_medic_formatado(ds_receita_parcial_w,'@DsViaAplicacao',ds_via_aplicacao_w)
		into STRICT	ds_receita_parcial_w
		;		
		select	retorna_medic_formatado(ds_receita_parcial_w,'@ViaAplicacao',ie_via_aplicacao_w)
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@IntervaloAdm',cd_intervalo_w)
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@FimUtilizacao','')
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@DscIntervaloAdm',ds_intervalo_w)
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@DiasUtil','')
		into STRICT	ds_receita_parcial_w
		;
		select	retorna_medic_formatado(ds_receita_parcial_w,'@Observacao',ds_observacao_w)
		into STRICT	ds_receita_parcial_w
		;

		select	retorna_medic_formatado(ds_receita_parcial_w,'@DsHorarios',ds_horarios_w)
		into STRICT	ds_receita_parcial_w
		;

		select	coalesce(length(ds_receita_final_w),0) + coalesce(length(ds_receita_parcial_w),0) + coalesce(length(ds_enter_w),0)
		into STRICT	qt_tamanho_w
		;
		
		if (qt_tamanho_w < 4000) then
			ds_receita_final_w	:= ds_receita_final_w || ds_receita_parcial_w || ds_enter_w;
		end if;	
		
		if (position('#$' in ds_receita_final_w) > 0) or (position('$#' in ds_receita_final_w) > 0) then
			ds_receita_final_w := replace(ds_receita_final_w,'#$','{');
			ds_receita_final_w := replace(ds_receita_final_w,'$#','}');
		end if;
		
		end;
	end loop;
	close c01;	
	
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_w;
	
	ds_fonte_w := Obter_Param_Usuario(281, 5, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_fonte_w);
	ds_tam_fonte_w := Obter_Param_Usuario(281, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_tam_fonte_w);
	
 	nr_tam_fonte_w	:= somente_numero(ds_tam_fonte_w)*2;

	ds_cabecalho_w	:= '{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fswiss\fcharset0 '||ds_fonte_w||';}}'||
			   '{\*\generator Msftedit 5.41.15.1507;}\viewkind4\uc1\pard\f0\fs'||nr_tam_fonte_w||' ';
			
	ds_rodape_w	:= '}';
	
	ds_receita_final_w	:= substr(replace(ds_receita_final_w, ds_enter_padrao_w, ds_quebra_linha_w),1,32000);
	
	if (ds_masc_receita_html_w IS NOT NULL AND ds_masc_receita_html_w::text <> '') then
		ds_receita_final_w	:= substr(replace(ds_receita_final_w, ds_quebra_linha_w, ds_enter_w),1,32000);
		ds_receita_w		:= ds_receita_final_w;
	else
		ds_receita_final_w	:= substr(replace(ds_receita_final_w, ds_quebra_linha_w, ' \par '),1,32000);
		ds_receita_w		:= substr(ds_cabecalho_w||ds_receita_final_w||ds_rodape_w,1,32000);
	end if;
	
	insert into med_receita(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_receita,
		ds_receita,
		cd_pessoa_fisica,
		cd_medico,
		ie_tipo_receita,
		nr_atendimento_hosp,
		ie_situacao
	) values (
		nextval('med_receita_seq'),
		clock_timestamp(),
		nm_usuario_p,
		dt_receita_p,
		ds_receita_w,
		cd_pessoa_fisica_p,
		cd_profissional_p,
		ie_tipo_receita_p,
		nr_atendimento_w,
		'A');
		
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_receita_medica ( cd_profissional_p text, dt_receita_p timestamp, ie_tipo_receita_p text, nr_seq_formatacao_p bigint, ds_medicamento_p text, nm_usuario_p text, nr_atendimento_p bigint, cd_pessoa_fisica_p text, ds_erro_p INOUT text, nr_sequencia_p bigint) FROM PUBLIC;

