-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_r57_dipj ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
cd_cgc_w			varchar(14);
ds_linha_w			varchar(8000);
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_razao_social_w			varchar(255);
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_nota_w			bigint;
nr_seq_registro_w			bigint	:= nr_sequencia_p;
sep_w				varchar(1)	:= '';
vl_ir_w				double precision;
vl_csll_w				double precision;
vl_total_nota_w			double precision;
dt_inicio_w			timestamp	:= trunc(dt_inicio_p,'dd');
dt_fim_w				timestamp	:= fim_dia(dt_fim_p);
cd_cnpj_empresa_w		varchar(14);
nr_seq_entrada_w			smallint	:= 0;
cd_retencao_ir_w		tributo.cd_retencao%TYPE;
cd_retencao_csll_w		tributo.cd_retencao%TYPE;
ie_orgao_publico_w		tipo_pessoa_juridica.ie_orgao_publico%type;
ie_orgao_w			varchar(1);
				
c01 CURSOR FOR 
SELECT	n.cd_cgc, 
	substr(obter_nome_pf_pj(null,n.cd_cgc),1,255) ds_razao_social, 
	coalesce(sum(n.vl_mercadoria),0) vl_total_nota 
from	nota_fiscal n, 
	operacao_nota o 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and	o.ie_servico = 'S' 
and	o.ie_operacao_fiscal = 'S' 
and	n.ie_situacao = 1 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	n.dt_emissao between dt_inicio_w and dt_fim_w 
/* 
and	exists(	select	1 
		from	nota_fiscal_trib b, 
			tributo d 
		where	d.cd_tributo	= b.cd_tributo 
		and	b.nr_sequencia	= n.nr_sequencia 
		and	d.ie_tipo_tributo in('CSLL','IR') 
		and	b.vl_tributo > 0) 
*/
 
group by n.cd_cgc 
order by 2;
				

BEGIN 
 
select	max(cd_cgc) 
into STRICT	cd_cnpj_empresa_w 
from	estabelecimento 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
open C01;
loop 
fetch C01 into	 
	cd_cgc_w, 
	ds_razao_social_w, 
	vl_total_nota_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	coalesce(max(b.ie_orgao_publico),'N') 
	into STRICT	ie_orgao_publico_w 
	from	tipo_pessoa_juridica	b, 
		pessoa_juridica		a 
	where	a.cd_tipo_pessoa	= b.cd_tipo_pessoa 
	and	a.cd_cgc		= cd_cgc_w;
	 
	ie_orgao_w	:= '2';
	 
	if (ie_orgao_publico_w = 'S') then 
		ie_orgao_w	:= '1';
	end if;
		 
	select	max(CASE WHEN d.ie_tipo_tributo='IR' THEN d.cd_retencao  ELSE '' END ) cd_retencao_ir, 
		coalesce(sum(CASE WHEN d.ie_tipo_tributo='IR' THEN  b.vl_tributo  ELSE 0 END ),0) vl_ir, 
		max(CASE WHEN d.ie_tipo_tributo='CSLL' THEN d.cd_retencao  ELSE '' END ) cd_retencao_csll, 
		coalesce(sum(CASE WHEN d.ie_tipo_tributo='CSLL' THEN  b.vl_tributo  ELSE 0 END ),0) vl_csll 
	into STRICT	cd_retencao_ir_w, 
		vl_ir_w, 
		cd_retencao_csll_w, 
		vl_csll_w 
	from	nota_fiscal n, 
		nota_fiscal_trib b, 
		tributo d, 
		operacao_nota o 
	where	n.nr_sequencia = b.nr_sequencia 
	and	b.cd_tributo = d.cd_tributo 
	and	n.cd_operacao_nf = o.cd_operacao_nf 
	and	d.ie_tipo_tributo in ('CSLL','IR') 
	and	b.vl_tributo > 0 
	and	o.ie_servico = 'S' 
	and	o.ie_operacao_fiscal = 'S' 
	and	n.cd_cgc	= cd_cgc_w 
	and	n.ie_situacao = 1 
	and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
	and	n.dt_emissao between dt_inicio_w and dt_fim_w;
	 
	if (vl_csll_w > 0) and (coalesce(cd_retencao_csll_w,'X') <> coalesce(cd_retencao_ir_w,'X')) then 
		begin 
		nr_seq_entrada_w	:= nr_seq_entrada_w + 1;
		ds_linha_w		:= substr(	'R57' 			|| 
							' '			|| 
							lpad(nr_seq_entrada_w,4,0)|| 
							rpad(cd_cnpj_empresa_w, 14, ' ')	||	 
							'0'			|| 
							'0'			|| 
							rpad(cd_cgc_w, 14, ' ')	|| 
							rpad(substr(ds_razao_social_w,1,150),150,' ')	|| 
							ie_orgao_w			|| 
							cd_retencao_csll_w	|| 
							lpad(replace(replace(campo_mascara_virgula(vl_total_nota_w),'.',''),',',''),14,'0')		||	 
							rpad('0',14,'0') 	||	 
							lpad(replace(replace(campo_mascara_virgula(vl_csll_w),'.',''),',',''),14,'0')	||	 
							rpad('0',14,'0') 	||	 
							rpad(' ',10,' '),1,8000);
		 
		ds_arquivo_w		:= SUBSTR(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= SUBSTR(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w 		:= nr_linha_w + 1;
		 
		insert into fis_dipj_registro(	 
			nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_controle_dipj, 
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
			'R57', 
			ds_arquivo_w, 
			ds_arquivo_compl_w);
		 
		end;
	end if;
	if (vl_ir_w > 0) and (coalesce(cd_retencao_csll_w,'X') <> coalesce(cd_retencao_ir_w,'X')) then 
		begin 
		nr_seq_entrada_w	:= nr_seq_entrada_w + 1;
		ds_linha_w		:= substr(	'R57' 			|| 
							' ' || 
							lpad(nr_seq_entrada_w,4,0)|| 
							rpad(cd_cnpj_empresa_w, 14, ' ')	||	 
							'0'			|| 
							'0'			|| 
							rpad(cd_cgc_w, 14, ' ')		|| 
							rpad(substr(ds_razao_social_w,1,150),150,' ')	|| 
							ie_orgao_w			|| 
							cd_retencao_ir_w	|| 
							lpad(replace(replace(campo_mascara_virgula(vl_total_nota_w),'.',''),',',''),14,'0')		||	 
							lpad(replace(replace(campo_mascara_virgula(vl_ir_w),'.',''),',',''),14,'0')	||	 
							rpad('0',14,'0') 	||	 
							rpad('0',14,'0') 	||	 
							rpad(' ',10,' '),1,8000);
		 
		ds_arquivo_w		:= SUBSTR(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= SUBSTR(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w 		:= nr_linha_w + 1;
		 
		insert into fis_dipj_registro(	 
			nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_controle_dipj, 
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
			'R57', 
			ds_arquivo_w, 
			ds_arquivo_compl_w);
		end;
	end if;
	 
	if (coalesce(cd_retencao_csll_w,'X') = coalesce(cd_retencao_ir_w,'X')) and (ie_orgao_w = '1' )then 
		begin 
		nr_seq_entrada_w	:= nr_seq_entrada_w + 1;
		ds_linha_w		:= substr(	'R57' 			|| 
							' ' || 
							lpad(nr_seq_entrada_w,4,0)|| 
							rpad(cd_cnpj_empresa_w, 14, ' ')	||	 
							'0'			|| 
							'0'			|| 
							rpad(cd_cgc_w, 14, ' ')		|| 
							rpad(substr(ds_razao_social_w,1,150),150,' ')	|| 
							ie_orgao_w			|| 
							cd_retencao_ir_w	|| 
							lpad(replace(replace(campo_mascara_virgula(vl_total_nota_w),'.',''),',',''),14,'0')		||	 
							lpad(replace(replace(campo_mascara_virgula(vl_ir_w),'.',''),',',''),14,'0')	||	 
							lpad(replace(replace(campo_mascara_virgula(vl_csll_w),'.',''),',',''),14,'0')	||	 
							rpad('0',14,'0') 	||	 
							rpad(' ',10,' '),1,8000);
		 
		ds_arquivo_w		:= SUBSTR(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= SUBSTR(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w 		:= nr_linha_w + 1;
		 
		insert into fis_dipj_registro(	 
			nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_controle_dipj, 
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
			'R57', 
			ds_arquivo_w, 
			ds_arquivo_compl_w);
		end;
	end if;
	end;
end loop;
close C01;
 
qt_linha_p := nr_linha_w;
nr_sequencia_p := nr_seq_registro_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_r57_dipj ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

