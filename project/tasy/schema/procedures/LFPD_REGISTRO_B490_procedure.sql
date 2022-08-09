-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lfpd_registro_b490 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
contador_w		bigint	:= 0;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_linha_w		bigint	:= qt_linha_p;
nr_seq_registro_w	bigint	:= nr_sequencia_p;
sep_w			varchar(1)	:= ds_separador_p;

cd_cgc_w		varchar(14);

c01 CURSOR FOR 
	SELECT	distinct 'B490'										cd_registro, 
		'00'											cd_obrigacao_recolhoer, 
		replace(campo_mascara(sum(obter_dados_tit_pagar(t.nr_titulo,'V')),2),'.',',')		vl_obrigacao, 
		substr(to_char(d.dt_vencimento, 'ddmmyyyy'),1,8)					dt_vencimento, 
		d.CD_DARF										cd_receita,		 
		'5300108'						 				cd_municipio, 
		''											nm_processo, 
		'0'											id_processo, 
		''											ds_processo, 
		''											cd_observacao 
	from	darf_titulo_pagar 	p, 
		titulo_pagar		t, 
		DARF 			d	 
	where 	d.cd_estabelecimento = cd_estabelecimento_p 
	and 	t.nr_titulo = p.nr_titulo 
	and 	d.NR_SEQUENCIA = p.NR_SEQ_DARF   
	and 	d.CD_DARF = '1708' 
	and 	t.cd_cgc = '00394684000153' 
	and	d.DT_APURACAO between dt_inicio_p and dt_fim_p 
	and	t.vl_titulo > 0 
	group by d.dt_vencimento, 
		d.CD_DARF	 
	
union
 
	SELECT	distinct 'B490'										cd_registro, 
		'01'											cd_obrigacao_recolhoer, 
		replace(campo_mascara(sum(obter_dados_tit_pagar(t.nr_titulo,'V')),2),'.',',')		vl_obrigacao, 
		substr(to_char(d.dt_vencimento, 'ddmmyyyy'),1,8)					dt_vencimento, 
		d.CD_DARF										cd_receita,		 
		'5300108'						 				cd_municipio, 
		''											nm_processo, 
		'0'											id_processo, 
		''											ds_processo, 
		''											cd_observacao 
	from	darf_titulo_pagar 	p, 
		titulo_pagar		t, 
		DARF 			d	 
	where 	d.cd_estabelecimento = cd_estabelecimento_p 
	and 	t.nr_titulo = p.nr_titulo 
	and 	d.NR_SEQUENCIA = p.NR_SEQ_DARF   
	and 	d.CD_DARF = '1732' 
	and 	t.cd_cgc = '00394684000153' 
	and	d.DT_APURACAO between dt_inicio_p and dt_fim_p 
	and	t.vl_titulo > 0 
	group by d.dt_vencimento, 
		d.CD_DARF;
		
	 
vet01	c01%RowType;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	contador_w := contador_w + 1;
	 
	ds_linha_w := substr(	sep_w	||	vet01.cd_registro		|| sep_w || 
						vet01.cd_obrigacao_recolhoer	|| sep_w || 
						vet01.vl_obrigacao		|| sep_w || 
						vet01.dt_vencimento		|| sep_w || 
						vet01.cd_receita		|| sep_w || 
						vet01.cd_municipio		|| sep_w || 
						vet01.nm_processo		|| sep_w || 
						vet01.id_processo		|| sep_w || 
						vet01.ds_processo		|| sep_w || 
						vet01.cd_observacao		|| sep_w, 1, 8000);
	 
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
 
	insert into fis_lfpd_arquivo(	nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						nr_linha, 
						ds_arquivo, 
						ds_arquivo_compl, 
						cd_registro, 
						nr_seq_controle_lfpd) 
				values (	nextval('fis_lfpd_arquivo_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_linha_w, 
						ds_arquivo_w, 
						ds_arquivo_compl_w, 
						vet01.cd_registro, 
						nr_seq_controle_p);
	 
	if (mod(contador_w,100) = 0) then 
		commit;
	end if;
	 
	end;
end loop;
close C01;
 
commit;
 
qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lfpd_registro_b490 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
