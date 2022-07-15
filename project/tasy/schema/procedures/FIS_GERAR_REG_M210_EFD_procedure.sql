-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_m210_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, vl_base_calculo_tributo_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


aliquota_pis_w			double precision;
cd_modelo_w			varchar(2);
cd_tributo_pis_w		smallint;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
ie_ind_incidencia_trib_w	integer;		
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
nr_linha_w			bigint 	:= qt_linha_p;
sep_w				varchar(1) 	:= ds_separador_p;
tp_registro_w			varchar(4);
vl_base_calculo_total_w		double precision;
vl_base_calculo_tributo_w	double precision;
vl_base_calculo_cumulativo_w	double precision;
vl_base_calculo_nao_cum_w	double precision;
vl_contribuicao_cumulativo_w	double precision;
vl_contribuicao_nao_cum_w	double precision;
vl_notas_pis_retido_w		double precision;
vl_notas_sem_pis_retido_w	double precision;
vl_receita_total_w		double precision;
vl_retido_cumulativo_w		double precision;
vl_retido_nao_cum_w		double precision;
ie_local_gerar_sped_w		varchar(1);
ie_consistir_cpf_cnpj_w		varchar(1);
ie_folha_salario_w		varchar(1);
qt_registros_w			bigint;
ie_nota_entrada_w		varchar(1);
ie_buscar_data_w		varchar(1);
ie_nota_cancelada_w		varchar(1);
cd_empresa_w			smallint;
nr_seq_data_w			bigint;
vl_operacao_w			double precision;
vl_material_incentivo_w		double precision;
ie_somar_trib_sai_w		varchar(1);
cd_contrib_cumulativo_w		varchar(5);
cd_contrib_nao_cumulativo_w	varchar(4);
nr_seq_max_m210_w		bigint;
vl_campo_16_str_w varchar(50);
vl_campo_08_str_w varchar(50);

vl_campo_02_w			varchar(5);  -- COD_CONT
vl_campo_03_w			double precision; -- VL_REC_BRT
vl_campo_04_w			double precision; -- VL_BC_CONT
vl_campo_07_w			double precision; -- VL_BC_CONT_AJUS
vl_campo_08_w			double precision; -- ALIQ_PIS
vl_campo_09_w			double precision; -- QUANT_BC_PIS
vl_campo_10_w			double precision; -- ALIQ_PIS_QUANT
vl_campo_11_w			double precision; -- VL_CONT_APUR
vl_campo_12_w			double precision; -- VL_AJUS_ACRES
vl_campo_13_w			double precision; -- VL_AJUS_REDUC
vl_campo_14_w			double precision; -- VL_CONT_DIFER
vl_campo_15_w			double precision; -- VL_CONT_DIFER_ANT
vl_campo_16_w			double precision; -- VL_CONT_PER
ie_ativar_layout_2019_w varchar(1);
ds_campos_layout_2019_w varchar(200);


BEGIN


select	nr_seq_regra_efd
into STRICT	nr_seq_regra_efd_w
from	fis_efd_controle
where	nr_sequencia	= nr_seq_controle_p;

select	coalesce(max(ie_somar_trib_sai),'N')
into STRICT	ie_somar_trib_sai_w
from	fis_regra_efd_a100
where	nr_seq_regra_efd	= nr_seq_regra_efd_w;

select	cd_tributo_pis
into STRICT	cd_tributo_pis_w
from	fis_regra_efd
where	nr_sequencia	= nr_seq_regra_efd_w;

select	ie_consistir_cpf_cnpj
into STRICT	ie_consistir_cpf_cnpj_w
from	fis_efd_controle
where	nr_sequencia	= nr_seq_controle_p;

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

select	count(*)
into STRICT	qt_registros_w
from	ctb_mes_ref
where	trunc(dt_referencia,'mm')	= trunc(dt_inicio_p,'mm')
and	cd_empresa			= cd_empresa_w;

if (qt_registros_w = 1) then
	select	nr_sequencia
	into STRICT	nr_seq_data_w
	from 	ctb_mes_ref
	where 	trunc(dt_referencia,'mm')	= trunc(dt_inicio_p,'mm')
	and	cd_empresa			= cd_empresa_w;
end if;	

if (trunc(dt_inicio_p,'YEAR') >= trunc(to_date('01-01-2019','dd-mm-yyyy'),'YEAR')) then
	ie_ativar_layout_2019_w := 'S';
else
	ie_ativar_layout_2019_w := 'N';
end if;	

select	coalesce(max(ie_nota_entrada),'N'),
	coalesce(max(ie_buscar_data),'N'),
	coalesce(max(ie_nota_cancelada),'N')
into STRICT	ie_nota_entrada_w,
	ie_buscar_data_w,
	ie_nota_cancelada_w
from	fis_regra_efd_a100
where	nr_seq_regra_efd	= nr_seq_regra_efd_w;

select	max(pr_imposto)
into STRICT	aliquota_pis_w
from	regra_calculo_imposto	r,
	tributo			d
where	exists (SELECT	1
       	     	from   	fis_regra_efd	e, 
       	     	       	tributo		d 
		where 	d.cd_tributo	= e.cd_tributo_pis
		and   	r.cd_tributo	= e.cd_tributo_pis 
		and	e.nr_sequencia	= nr_seq_regra_efd_w
		and   	ie_tipo_tributo = 'PIS');

-- Verifca se ser gerado o PIS sobre a folha de salrio
select	count(*)
into STRICT	qt_registros_w
from	fis_regra_efd_reg
where	cd_registro		= 'M350'
and	ie_gerar		= 'S'
and	nr_seq_regra_efd	= nr_seq_regra_efd_w;

if (qt_registros_w > 0) then
	ie_folha_salario_w	:= 'V';
else
	ie_folha_salario_w	:= 'F';
end if;

ie_local_gerar_sped_w := obter_param_usuario(5500, 25, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_local_gerar_sped_w);		

if	((ie_local_gerar_sped_w = 'N') or (ie_local_gerar_sped_w = 'A')) and (ie_folha_salario_w = 'F') then
	select	sum(a.vl_base_calculo)
	into STRICT	vl_receita_total_w
	from	fis_efd_nota_arq	a
	where	a.nm_usuario		= nm_usuario_p
	and	a.nr_seq_controle	= nr_seq_controle_p;
	
	-- Calcular a receita total (Total das notas com PIS retido + total das notas sem PIS retido)

	--vl_receita_total_w	:= nvl(vl_notas_pis_retido_w,0) + nvl(vl_notas_sem_pis_retido_w,0);


	-- Calcular o valor da base de clculo do PIS
	vl_base_calculo_tributo_w	:= vl_receita_total_w;	
	
	cd_contrib_nao_cumulativo_w	:= null;
	
	select 	count(a.nr_sequencia)
	into STRICT 	qt_registros_w
	from 	fis_regra_efd_m210	a
	where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
	
	if (qt_registros_w > 0) then
		select 	max(a.nr_sequencia)
		into STRICT    nr_seq_max_m210_w
		from	fis_regra_efd_m210	a
		where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
		
		select 	a.cd_contrib_nao_cumulativo
		into STRICT 	cd_contrib_nao_cumulativo_w
		from 	fis_regra_efd_m210	a
		where 	nr_sequencia	= nr_seq_max_m210_w;
	end if;
	
	cd_contrib_nao_cumulativo_w	:= coalesce(cd_contrib_nao_cumulativo_w,'51');
	
	vl_campo_02_w	:= case when cd_contrib_nao_cumulativo_w > 0 then cd_contrib_nao_cumulativo_w else 0 end;
	vl_campo_03_w	:= case when vl_receita_total_w > 0 then vl_receita_total_w else 0 end;
	vl_campo_04_w	:= case when vl_base_calculo_tributo_w > 0 then vl_base_calculo_tributo_w else 0 end;
	vl_campo_08_w	:= case when aliquota_pis_w > 0 then aliquota_pis_w else 0 end;
	vl_campo_11_w	:= coalesce(vl_campo_04_w * vl_campo_08_w/100,0);
	vl_campo_11_w	:= case when vl_campo_11_w > 0 then vl_campo_11_w else 0 end;
	vl_campo_16_w	:= coalesce((vl_campo_04_w * vl_campo_08_w)/100,0);
	vl_campo_16_w	:= case when vl_campo_16_w > 0 then vl_campo_16_w else 0 end;
	
	ds_campos_layout_2019_w := '';
	if (ie_ativar_layout_2019_w = 'S') then
		vl_campo_07_w := vl_campo_04_w; -- Formula campo 4 + campo 5 - campo 6
		ds_campos_layout_2019_w := sep_w ||	'0,00'						|| -- Campo 05 - VL_AJUS_ACRES_BC_PIS 
								   sep_w || '0,00' 						|| -- Campo 06 - VL_AJUS_REDUC_BC_PIS 
								   sep_w || replace(campo_mascara(coalesce(vl_campo_07_w,0),2),'.',','); -- Campo 07 - VL_BC_CONT_AJUS 				   
	end if;
	
	/*select	nvl(sum(vl_glosa),0)
	into	vl_campo_13_w
	from(	select	r.nr_nota_fiscal,
			to_char(l.dt_recebimento,'ddmmyyyy') dt_recebimento,
			round(sum(vl_glosa) * (aliquota_pis_w/100),2) vl_glosa
		from	titulo_receber r,
			titulo_receber_liq l
		where	r.nr_titulo = l.nr_titulo
		and	dt_recebimento between dt_inicio_p and dt_fim_p
		group by
			r.nr_nota_fiscal,
			l.dt_recebimento);*/

	
	-- Montagem das linhas do arquivo
  vl_campo_08_str_w := campo_mascara(coalesce(vl_campo_08_w,0),2);
  vl_campo_16_str_w := campo_mascara(coalesce(vl_campo_16_w,0),2);
	ds_linha_w	:=	sep_w || 'M210' 						|| -- Campo 01 - Registro
				sep_w || coalesce(lpad(vl_campo_02_w,2,'0'),'51')			|| -- Campo 02 - Cdigo contribuio
				sep_w || replace(campo_mascara(coalesce(vl_campo_03_w,0),2),'.',',')	|| -- Campo 03 - Receita total
				sep_w || replace(campo_mascara(coalesce(vl_campo_04_w,0),2),'.',',')	|| -- Campo 04 - Base de clculo
				ds_campos_layout_2019_w ||
				sep_w || replace(vl_campo_08_str_w,'.',',')	|| -- Campo 08 - Alquota do PIS (em percentual)
				sep_w ||  -- Campo 09 - Quantidade da base de clculo. Dever ser deixado em branco quando o cdigo da contribuio for 01
				sep_w ||  -- Campo 10 - Alquota do PIS (em reais) Este campo fica em branco quando no for apurado por unidade de produto
				sep_w || replace(campo_mascara(coalesce(vl_campo_11_w,0),2),'.',',')	|| -- Campo 11 - Valor total da contribuio apurada
				sep_w || 0							|| -- Campo 12 - Valor dos ajustes de acrscimo
				sep_w || 0	|| -- Campo 13 - Valor dos ajustes de reduo
				sep_w || 0							|| -- Campo 14 - Valor da contribuio a diferir
				sep_w || 0							|| -- Campo 15 - Valor da contribuio diferida
				sep_w || replace(vl_campo_16_str_w,'.',',')	|| -- Campo 16 - Valor total da contribuio do perodo (campo08 + campo09 - campo10 - campo11 + campo12)
				sep_w;
	

	
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
		
	insert into fis_efd_arquivo(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_controle_efd,
		nr_linha,
		ds_arquivo,
		ds_arquivo_compl,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_registro)
	values (nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		ds_arquivo_w,
		ds_arquivo_compl_w,
		clock_timestamp(),
		nm_usuario_p,
		'M210');
elsif (ie_local_gerar_sped_w = 'C') and (ie_folha_salario_w = 'F') then
	select  sum(vl_base_tributo)
	into STRICT	vl_base_calculo_tributo_w
	from	w_efd_dados_arq;

	select	max(a.vl_movimento)	vl_operacao
	into STRICT	vl_operacao_w
	from 	ctb_balancete_v a
	where 	a.nr_seq_mes_ref		= nr_seq_data_w
	and	a.cd_conta_contabil		= '2441'
	and	a.cd_estabelecimento		= cd_estabelecimento_p
	and	a.ie_normal_encerramento	= 'N';
	
	vl_operacao_w	:= coalesce(vl_operacao_w,0);

	vl_base_calculo_tributo_w	:= vl_base_calculo_tributo_w;
	vl_receita_total_w		:= vl_base_calculo_tributo_w;
	
	cd_contrib_nao_cumulativo_w	:= null;
	
	select 	count(a.nr_sequencia)
	into STRICT 	qt_registros_w
	from 	fis_regra_Efd_m210	a
	where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
	
	if (qt_registros_w > 0) then
		select 	max(a.nr_sequencia)
		into STRICT    nr_seq_max_m210_w
		from	fis_regra_Efd_m210	a
		where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
		
		select 	a.cd_contrib_nao_cumulativo
		into STRICT 	cd_contrib_nao_cumulativo_w
		from 	fis_regra_Efd_m210	a
		where 	a.nr_sequencia	= nr_seq_max_m210_w;
	end if;

	cd_contrib_cumulativo_w	:= null;

	select 	count(a.nr_sequencia)
	into STRICT 	qt_registros_w
	from 	fis_regra_Efd_m210	a
	where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
	
	if (qt_registros_w > 0) then
		select 	max(a.nr_sequencia)
		into STRICT    nr_seq_max_m210_w
		from	fis_regra_Efd_m210	a
		where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
		
		select 	a.cd_contrib_cumulativo
		into STRICT 	cd_contrib_cumulativo_w
		from 	fis_regra_Efd_m210	a
		where 	a.nr_sequencia		= nr_seq_max_m210_w;
	end if;
	
	cd_contrib_cumulativo_w	:= coalesce(cd_contrib_cumulativo_w,'01');
	
	vl_campo_02_w	:= case when cd_contrib_cumulativo_w > 0 then cd_contrib_cumulativo_w else 0 end;
	vl_campo_04_w	:= case when vl_operacao_w > 0 then vl_operacao_w else 0 end;
	vl_campo_08_w	:= vl_campo_04_w;
	vl_campo_11_w	:= coalesce(vl_campo_04_w * 1.65/100,0);
	vl_campo_11_w	:= case when vl_campo_11_w > 0 then vl_campo_11_w else 0 end;
	vl_campo_16_w	:= coalesce((vl_campo_04_w * 1.65)/100,0);
	vl_campo_16_w	:= case when vl_campo_16_w > 0 then vl_campo_16_w else 0 end;
	
	ds_campos_layout_2019_w := '';
	if (ie_ativar_layout_2019_w = 'S') then
		vl_campo_07_w := vl_campo_04_w; -- Formula campo 4 + campo 5 - campo 6
		ds_campos_layout_2019_w := sep_w ||	'0,00'						|| -- Campo 05 - VL_AJUS_ACRES_BC_PIS 
								   sep_w || '0,00' 						|| -- Campo 06 - VL_AJUS_REDUC_BC_PIS 
								   sep_w || replace(campo_mascara(coalesce(vl_campo_07_w,0),2),'.',','); -- Campo 07 - VL_BC_CONT_AJUS 				   
	end if;
	
	-- Montagem das linhas do arquivo Cumulativo
  vl_campo_08_str_w := campo_mascara(coalesce(vl_campo_08_w,0),2);
  vl_campo_16_str_w := campo_mascara(coalesce(vl_campo_16_w,0),2);
	ds_linha_w	:=	sep_w || 'M210' 						|| --Campo 01 - Registro
				sep_w || coalesce(lpad(vl_campo_02_w,2,'0'),'01')				|| -- Campo 02 - Cdigo contribuio
				sep_w || replace(campo_mascara(coalesce(vl_campo_04_w,0),2),'.',',')	|| -- Campo 03 - Receita total
				sep_w || replace(vl_campo_08_str_w,'.',',')	|| -- Campo 04 - Base de clculo
				ds_campos_layout_2019_w ||
				sep_w || replace(campo_mascara(coalesce((1.65),0),2),'.',',')	|| -- Campo 08 - Alquota do PIS (em percentual)
				sep_w ||  -- Campo 09 - Quantidade da base de clculo. Dever ser deixado em branco quando o cdigo da contribuio for 01
				sep_w ||  -- Campo 10 - Alquota do PIS (em reais) Este campo fica em branco quando no for apurado por unidade de produto
				sep_w || replace(campo_mascara(coalesce(vl_campo_11_w,0),2),'.',',')	|| -- Campo 11 - Valor total da contribuio apurada
				sep_w || 0							|| -- Campo 12 - Valor dos ajustes de acrscimo
				sep_w || 0							|| -- Campo 13 - Valor dos ajustes de reduo
				sep_w || 0							|| -- Campo 14 - Valor da contribuio a diferir
				sep_w || 0							|| -- Campo 15 - Valor da contribuio diferida
				sep_w || replace(vl_campo_16_str_w,'.',',')	|| -- Campo 16 - Valor total da contribuio do perodo (campo08 + campo09 - campo10 - campo11 + campo12)
				sep_w;
				
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
	
	insert into fis_efd_arquivo(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_controle_efd,
		nr_linha,
		ds_arquivo,
		ds_arquivo_compl,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_registro)
	values (nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		ds_arquivo_w,
		ds_arquivo_compl_w,
		clock_timestamp(),
		nm_usuario_p,
		'M210');

	cd_contrib_nao_cumulativo_w	:= coalesce(cd_contrib_nao_cumulativo_w,'51');
	
	vl_campo_02_w	:= case when cd_contrib_nao_cumulativo_w > 0 then cd_contrib_nao_cumulativo_w else 0 end;
	vl_campo_03_w	:= case when vl_receita_total_w > 0 then vl_receita_total_w else 0 end;
	vl_campo_04_w	:= vl_campo_03_w;
	vl_campo_08_w	:= case when aliquota_pis_w > 0 then aliquota_pis_w else 0 end;
	vl_campo_11_w	:= coalesce(vl_base_calculo_tributo_w * vl_campo_08_w/100,0);
	vl_campo_11_w	:= case when vl_campo_09_w > 0 then vl_campo_09_w else 0 end;
	vl_campo_16_w	:= coalesce((vl_base_calculo_tributo_w * vl_campo_08_w)/100,0);
	vl_campo_16_w	:= case when vl_campo_16_w > 0 then vl_campo_16_w else 0 end;
	
	ds_campos_layout_2019_w := '';
	if (ie_ativar_layout_2019_w = 'S') then
		vl_campo_07_w := vl_campo_04_w; -- Formula campo 4 + campo 5 - campo 6
		ds_campos_layout_2019_w := sep_w ||	'0,00'						|| -- Campo 05 - VL_AJUS_ACRES_BC_PIS 
								   sep_w || '0,00' 						|| -- Campo 06 - VL_AJUS_REDUC_BC_PIS 
								   sep_w || replace(campo_mascara(coalesce(vl_campo_07_w,0),2),'.',','); -- Campo 07 - VL_BC_CONT_AJUS 				   
	end if;

  vl_campo_08_str_w := campo_mascara(coalesce(vl_campo_08_w,0),2);
  vl_campo_16_str_w := campo_mascara(coalesce(vl_campo_16_w,0),2);
	-- Montagem das linhas do arquivo No Cumulativo
	ds_linha_w	:=	sep_w || 'M210' 						|| --Campo 01 - Registro
				sep_w || coalesce(lpad(vl_campo_02_w,2,'0'),'51')				|| -- Campo 02 - Cdigo contribuio
				sep_w || replace(campo_mascara(coalesce(vl_campo_03_w,0),2),'.',',')	|| -- Campo 03 - Receita total
				sep_w || replace(campo_mascara(coalesce(vl_campo_04_w,0),2),'.',',')	|| -- Campo 04 - Base de clculo
				ds_campos_layout_2019_w ||
				sep_w || replace(vl_campo_08_str_w,'.',',')	|| -- Campo 08 - Alquota do PIS (em percentual)
				sep_w ||  -- Campo 09 - Quantidade da base de clculo. Dever ser deixado em branco quando o cdigo da contribuio for 01
				sep_w ||  -- Campo 10 - Alquota do PIS (em reais) Este campo fica em branco quando no for apurado por unidade de produto
				sep_w || replace(campo_mascara(coalesce(vl_campo_11_w,0),2),'.',',')	|| -- Campo 11 - Valor total da contribuio apurada
				sep_w || 0							|| -- Campo 12 - Valor dos ajustes de acrscimo
				sep_w || 0							|| -- Campo 13 - Valor dos ajustes de reduo
				sep_w || 0							|| -- Campo 14 - Valor da contribuio a diferir
				sep_w || 0							|| -- Campo 15 - Valor da contribuio diferida
				sep_w || replace(vl_campo_16_str_w,'.',',')	|| -- Campo 16 - Valor total da contribuio do perodo (campo08 + campo09 - campo10 - campo11 + campo12)
				sep_w;
				
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
	
	insert into fis_efd_arquivo(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_controle_efd,
		nr_linha,
		ds_arquivo,
		ds_arquivo_compl,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_registro)
	values (nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		ds_arquivo_w,
		ds_arquivo_compl_w,
		clock_timestamp(),
		nm_usuario_p,
		'M210');

	commit;
elsif (ie_folha_salario_w = 'V') then	
	-- Caso seja enviado apenas o PIS sobre folha de salrio, o M200 deve ser enviado zerado
	cd_contrib_nao_cumulativo_w	:= null;
	
	select 	count(a.nr_sequencia)
	into STRICT 	qt_registros_w
	from 	fis_regra_Efd_m210	a
	where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
	
	if (qt_registros_w > 0) then
		select 	max(a.nr_sequencia)
		into STRICT    nr_seq_max_m210_w
		from	fis_regra_Efd_m210	a
		where 	a.nr_seq_regra_efd	= nr_seq_regra_efd_w;
		
		select 	a.cd_contrib_nao_cumulativo
		into STRICT 	cd_contrib_nao_cumulativo_w
		from 	fis_regra_Efd_m210	a
		where 	a.nr_sequencia	= nr_seq_max_m210_w;
	end if;
	
	
	ds_campos_layout_2019_w := '';
	if (ie_ativar_layout_2019_w = 'S') then
		ds_campos_layout_2019_w := sep_w ||	'0,00'							|| -- Campo 05 - VL_AJUS_ACRES_BC_PIS 
								   sep_w || '0,00'	 						|| -- Campo 06 - VL_AJUS_REDUC_BC_PIS 
								   sep_w || '0,00'; 						   -- Campo 07 - VL_BC_CONT_AJUS 				   
	end if;
	
	-- Montagem das linhas do arquivo
	ds_linha_w	:=	sep_w || 'M210' 						|| -- Campo 01 - Registro
				sep_w || coalesce(lpad(cd_contrib_nao_cumulativo_w,2,'0'),'51')			|| -- Campo 02 - Cdigo contribuio
				sep_w || '0,00'							|| -- Campo 03 - Receita total
				sep_w || '0,00'							|| -- Campo 04 - Base de clculo
				ds_campos_layout_2019_w ||
				sep_w || replace(campo_mascara(coalesce((0.65),0),2),'.',',')	|| -- Campo 08 - Alquota do PIS (em percentual)
				sep_w ||  -- Campo 09 - Quantidade da base de clculo. Dever ser deixado em branco quando o cdigo da contribuio for 01
				sep_w ||  -- Campo 10 - Alquota do PIS (em reais) Este campo fica em branco quando no for apurado por unidade de produto
				sep_w || '0,00'							|| -- Campo 11 - Valor total da contribuio apurada
				sep_w || 0							|| -- Campo 12 - Valor dos ajustes de acrscimo
				sep_w || 0							|| -- Campo 13 - Valor dos ajustes de reduo
				sep_w || 0							|| -- Campo 14 - Valor da contribuio a diferir
				sep_w || 0							|| -- Campo 15 - Valor da contribuio diferida
				sep_w || '0,00'							|| -- Campo 16 - Valor total da contribuio do perodo (campo08 + campo09 - campo10 - campo11 + campo12)
				sep_w;
				
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
	
	insert into fis_efd_arquivo(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_controle_efd,
		nr_linha,
		ds_arquivo,
		ds_arquivo_compl,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_registro)
	values (nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		ds_arquivo_w,
		ds_arquivo_compl_w,
		clock_timestamp(),
		nm_usuario_p,
		'M210');

	commit;
	
	vl_base_calculo_tributo_w	:= 0;
end if;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_m210_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, vl_base_calculo_tributo_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

