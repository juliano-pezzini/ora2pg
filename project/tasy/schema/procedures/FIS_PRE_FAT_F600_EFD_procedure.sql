-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_pre_fat_f600_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
aliquota_pis_w			double precision;
aliquota_cofins_w		double precision;
cd_tributo_pis_w		smallint;
cd_tributo_cofins_w		smallint;
cd_cgc_w			varchar(14);					
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
cd_municipio_ibge_w		varchar(7);
nr_linha_w			bigint 	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;

dt_movimento_w			varchar(10);
vl_base_calculo_w		double precision := 0;
vl_pis_w			double precision := 0;
vl_cofins_w			double precision := 0;
vl_retencao_w			double precision;
qt_registros_w			bigint;
cd_empresa_w			smallint;
nr_seq_data_w			bigint;

c01 CURSOR FOR 
SELECT	round((sum(y.vl_pis))::numeric,2) vl_pis, 
	round((sum(y.vl_cofins))::numeric,2) vl_cofins, 
	y.dt_movimento	dt_retencao 
from (	SELECT	round((vl_debito)::numeric,2)	vl_pis, 
			0		vl_cofins, 
			dt_inicio_p	dt_movimento 
		from 	ctb_balancete_v a 
		where 	a.nr_seq_mes_ref = nr_seq_data_w 
		and	a.cd_conta_contabil = '1544' 
		and	a.cd_estabelecimento = cd_estabelecimento_p 
		and	a.ie_normal_encerramento = 'N' 
		
union
 
		select	0		vl_pis, 
			round((vl_debito)::numeric,2)	vl_cofins, 
			dt_inicio_p	dt_movimento 
		from 	ctb_balancete_v a 
		where 	a.nr_seq_mes_ref = nr_seq_data_w 
		and	a.cd_conta_contabil = '1543' 
		and	a.cd_estabelecimento = cd_estabelecimento_p 
		and	a.ie_normal_encerramento = 'N') y 
group by y.dt_movimento;
	
vet01	C01%RowType;


BEGIN 
 
select	cd_empresa 
into STRICT	cd_empresa_w 
from	estabelecimento 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	count(*) 
into STRICT	qt_registros_w 
from	ctb_mes_ref 
where	trunc(dt_referencia,'mm') = trunc(dt_inicio_p,'mm') 
and	cd_empresa = cd_empresa_w;
 
if (qt_registros_w = 1) then 
 
	select	nr_sequencia 
	into STRICT	nr_seq_data_w 
	from 	ctb_mes_ref 
	where 	trunc(dt_referencia,'mm') = trunc(dt_inicio_p,'mm') 
	and	cd_empresa = cd_empresa_w;
end if;
 
select	a.cd_cgc 
into STRICT	cd_cgc_w 
from	estabelecimento a 
where	a.cd_estabelecimento = cd_estabelecimento_p;
 
select	nr_seq_regra_efd 
into STRICT	nr_seq_regra_efd_w 
from	fis_efd_controle 
where	nr_sequencia = nr_seq_controle_p;
 
select 	cd_tributo_pis, 
	cd_tributo_cofins 
into STRICT	cd_tributo_pis_w, 
	cd_tributo_cofins_w 
from	fis_regra_efd 
where	nr_sequencia = nr_seq_regra_efd_w;
 
aliquota_pis_w := obter_pr_imposto(cd_tributo_pis_w);
 
open C01;
loop 
fetch C01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	vl_base_calculo_w 	:= round((vet01.vl_pis / aliquota_pis_w)::numeric,2) * 100;
	vl_retencao_w		:= vet01.vl_pis + vet01.vl_cofins;
	 
	ds_linha_w	:= substr(	sep_w || 'F600' 						|| 	--texto fixo 
					sep_w || '02'							|| 	-- indicador da natureza retencao 
					sep_w || to_char(vet01.dt_retencao,'ddmmyyyy')			|| 	-- data retenção 
					sep_w || replace(campo_mascara(abs(vl_base_calculo_w),2),'.',',')	|| 	-- base de cálculo da retenção 
					sep_w || replace(campo_mascara(abs(vl_retencao_w),2),'.',',')	|| 	-- valor da retenção 
					sep_w || ''							||	-- código da retenção 
					sep_w || ''							||	-- natureza da receita 
					sep_w || cd_cgc_w		 				||	-- cnpj 
					sep_w || vet01.vl_pis		 				|| 	-- valor do pis retido na fonte 
					sep_w || vet01.vl_cofins	 				|| 	-- valor do cofins retido na fonte 
					sep_w || '1'							|| sep_w,1,8000); 	-- natureza do declarante 
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
 
	insert into fis_efd_arquivo(	nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec, 
					nr_seq_controle_efd, 
					nr_linha, 
					cd_registro, 
					ds_arquivo, 
					ds_arquivo_compl) 
				values (	nr_seq_registro_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_controle_p, 
					nr_linha_w, 
					'F600', 
					ds_arquivo_w, 
					ds_arquivo_compl_w);
 
	qt_linha_p	:= nr_linha_w;
	nr_sequencia_p	:= nr_seq_registro_w;		
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_pre_fat_f600_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
