-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_arquivo_dim ( nr_seq_controle_p bigint, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE



cd_w				bigint := 1;
ds_linha_w			varchar(2000);
sep_w				varchar(1)	:= ds_separador_p;
ds_arquivo_w			varchar(2000);
ds_arquivo_compl_w		varchar(2000);
nr_linha_w			bigint 	:= qt_linha_p;
tx_tributo_w			nota_fiscal_item_trib.tx_tributo%Type;
qt_commit_w			bigint;

vl_campo_8_w 			nota_fiscal.vl_mercadoria%Type;
vl_campo_9_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_10_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_11_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_12_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_13_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_14_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_15_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_16_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_17_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_18_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_19_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_20_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_21_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_22_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_23_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_24_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_25_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_26_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_27_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_28_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_29_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_30_w			nota_fiscal.vl_mercadoria%Type;
vl_tributo_w			double precision;
vl_aliquota_w			double precision;

ie_tipo_tributo_w		tributo.ie_tipo_tributo%Type;
				
ie_dividendos_w 		fis_dim_controle.ie_dividendos%Type;
ie_residual_distr_w      	fis_dim_controle.ie_residual_distr%Type;
ie_outros_pagamentos_w   	fis_dim_controle.ie_outros_pagamentos%Type;
ie_tipo_dividendos_w     	fis_dim_controle.ie_tipo_dividendos%Type;
				
C01 CURSOR FOR

SELECT  y.cd_rfc,
	y.cd_curp,
	y.dt_inicio,
	y.dt_fim,
	y.nm_pessoa nm_pessoa,
	sum(y.vl_campo_12) vl_campo_10,
	sum(y.vl_campo_11) vl_campo_11,
	sum(y.vl_campo_12) vl_campo_12,
	y.ds_endereco_socio,
	sum(y.pr_participacao) pr_participacao,
	sum(y.vl_campo_15) vl_campo_15,
	sum(y.vl_campo_16) vl_campo_16,
	y.ds_chave_pagto,
	sum(y.vl_campo_18) vl_campo_18,
	sum(y.vl_campo_19) vl_campo_19,
	sum(y.vl_campo_20) vl_campo_20,
	y.vl_campo_21,
	sum(y.vl_campo_22) vl_campo_22,
	sum(y.vl_campo_23) vl_campo_23,
	sum(y.vl_campo_24) vl_campo_24,
	sum(y.vl_campo_25) vl_campo_25,
	sum(y.vl_campo_26) vl_campo_26,
	sum(y.vl_campo_27) vl_campo_27,
	sum(y.vl_campo_28) vl_campo_28,
	sum(y.vl_campo_29) vl_campo_29,
	sum(y.vl_campo_30) vl_campo_30,
	sum(y.vl_mercadoria) vl_mercadoria,
	y.nr_sequencia	nr_sequencia
from (	
SELECT 	j.cd_rfc,
	'' cd_curp,
	dt_inicio_p dt_inicio,
	dt_fim_p dt_fim,
	j.ds_razao_social nm_pessoa,
	0 vl_campo_10,
	0 vl_campo_11,
	0 vl_campo_12,
	'' ds_endereco_socio,
	0.0 pr_participacao,
	0 vl_campo_15,
	0 vl_campo_16,
	'A1' ds_chave_pagto,
	0 vl_campo_18,
	0 vl_campo_19,
	0 vl_campo_20,
	'' vl_campo_21,
	0 vl_campo_22,
	0 vl_campo_23,
	0 vl_campo_24,
	0 vl_campo_25,
	0 vl_campo_26,
	0 vl_campo_27,
	0 vl_campo_28,
	0 vl_campo_29,
	0 vl_campo_30,
	c.vl_mercadoria,
	c.nr_sequencia
FROM estabelecimento h, nota_fiscal c, operacao_nota b, pessoa_juridica j
LEFT OUTER JOIN pais e ON (j.nr_seq_pais = e.nr_sequencia)
WHERE b.cd_operacao_nf = c.cd_operacao_nf  and b.ie_servico = 'S' and c.ie_situacao = 1 and b.ie_operacao_fiscal = 'S' and j.cd_cgc = c.cd_cgc and c.dt_emissao between dt_inicio_p and fim_dia(dt_fim_p) and c.cd_estabelecimento 	= cd_estabelecimento_p and h.cd_empresa 		= cd_empresa_p and c.cd_estabelecimento 	= h.cd_estabelecimento and exists (select 1 
		FROM tributo e, nota_fiscal_item a
LEFT OUTER JOIN nota_fiscal_item_trib d ON (a.nr_sequencia = d.nr_sequencia)
WHERE a.nr_sequencia = c.nr_sequencia  and d.cd_tributo = e.cd_tributo and e.ie_tipo_tributo  in ('IVA','ISR') )
 
union all

select 	'' cd_rfc,
	j.cd_curp,
	dt_inicio_p dt_inicio,
	dt_fim_p dt_fim,
	SUBSTR(OBTER_NOME_PF(j.CD_PESSOA_FISICA), 0, 60) nm_pessoa,
	0 vl_campo_10,
	0 vl_campo_11,
	0 vl_campo_12,
	'' ds_endereco_socio,
	0.0 pr_participacao,
	0 vl_campo_15,
	0 vl_campo_16,
	'A1' ds_chave_pagto,
	0 vl_campo_18,
	0 vl_campo_19,
	0 vl_campo_20,
	'' vl_campo_21,
	0 vl_campo_22,
	0 vl_campo_23,
	0 vl_campo_24,
	0 vl_campo_25,
	0 vl_campo_26,
	0 vl_campo_27,
	0 vl_campo_28,
	0 vl_campo_29,
	0 vl_campo_30,
	c.vl_mercadoria,
	c.nr_sequencia	
FROM estabelecimento h, nota_fiscal c, operacao_nota b, pessoa_fisica j
LEFT OUTER JOIN nacionalidade e ON (j.cd_nacionalidade = e.cd_nacionalidade)
WHERE b.cd_operacao_nf = c.cd_operacao_nf  and b.ie_servico = 'S' and c.ie_situacao = 1 and b.ie_operacao_fiscal = 'S' and j.cd_pessoa_fisica = c.cd_pessoa_fisica and c.dt_emissao between dt_inicio_p and fim_dia(dt_fim_p) and c.cd_estabelecimento 	= cd_estabelecimento_p and h.cd_empresa 		= cd_empresa_p and c.cd_estabelecimento 	= h.cd_estabelecimento and exists (select 1 
		FROM tributo e, nota_fiscal_item a
LEFT OUTER JOIN nota_fiscal_item_trib d ON (a.nr_sequencia = d.nr_sequencia)
WHERE a.nr_sequencia = c.nr_sequencia  and d.cd_tributo = e.cd_tributo and e.ie_tipo_tributo  in ('IVA','ISR') ) ) y			
group	by	y.cd_rfc, 
		y.cd_curp,
		y.dt_inicio,
		y.dt_fim,
		y.nm_pessoa,
		y.ds_endereco_socio,
		y.ds_chave_pagto,
		y.nr_sequencia,
		y.vl_campo_21;
			

type		fetch_array is table of C01%ROWTYPE index by integer;
i		integer := 1;
vet01_w		fetch_array;	


BEGIN

delete
from 	fis_dim_arquivo
where	nr_seq_controle_dim	=  nr_seq_controle_p;

commit;

select	CASE WHEN coalesce(ie_dividendos,'N')='S' THEN '1'  ELSE '2' END  ie_dividendos,
	CASE WHEN coalesce(ie_residual_distr,'N')='S' THEN '1'  ELSE '2' END  ie_residual_distr,
	CASE WHEN coalesce(ie_outros_pagamentos,'N')='S' THEN '1'  ELSE '2' END  ie_outros_pagamentos,   
	coalesce(ie_tipo_dividendos,'0') ie_tipo_dividendos
into STRICT	ie_dividendos_w,
	ie_residual_distr_w,
	ie_outros_pagamentos_w,
	ie_tipo_dividendos_w
from	fis_dim_controle
where	nr_sequencia = nr_Seq_controle_p;


open C01;
loop
fetch C01 bulk collect into
	vet01_w limit 1000;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

for i in 1..vet01_w.count loop
	begin
	
	vl_campo_10_w	:= (null)::numeric;
	vl_campo_11_w	:= (null)::numeric;
	vl_campo_12_w	:= (null)::numeric;
	vl_campo_15_w	:= (null)::numeric;
	vl_campo_16_w	:= (null)::numeric;
	vl_campo_18_w	:= (null)::numeric;
	vl_campo_19_w	:= (null)::numeric;
	vl_campo_20_w	:= (null)::numeric;
	vl_campo_22_w	:= (null)::numeric;
	vl_campo_23_w	:= (null)::numeric;
	vl_campo_24_w	:= (null)::numeric;
	vl_campo_25_w	:= (null)::numeric;
	vl_campo_26_w	:= (null)::numeric;
	vl_campo_27_w	:= (null)::numeric;
	vl_campo_28_w	:= (null)::numeric;
	vl_campo_29_w	:= (null)::numeric;
	vl_campo_30_w	:= (null)::numeric;
	
	select 	max(tx_tributo),
		sum(vl_tributo),
		e.ie_tipo_tributo
	into STRICT	tx_tributo_w,
		vl_tributo_w,
		ie_tipo_tributo_w
	from	nota_fiscal_item_trib d,
	 	tributo e
	where	d.cd_tributo = e.cd_tributo
	and	e.ie_tipo_tributo  in ('IVA','ISR')
	and	d.nr_sequencia = vet01_w[i].nr_sequencia
	group 	by	e.ie_tipo_tributo;
	
	if (ie_tipo_tributo_w = 'ISR') then
		vl_campo_22_w 	:= vet01_w[i].vl_mercadoria;
		vl_campo_28_w	:= vl_tributo_w;
	elsif (ie_tipo_tributo_w = 'IVA') then
		vl_campo_23_w 	:= vet01_w[i].vl_mercadoria;
		vl_campo_29_w	:= vl_tributo_w;	
	end if;	

	ds_linha_w := substr(	vet01_w[i].cd_rfc 													||
				sep_w || vet01_w[i].cd_curp 												||
				sep_w || to_char(vet01_w[i].dt_inicio,'mm')										||
				sep_w || to_char(vet01_w[i].dt_fim,'mm')										||
				sep_w || vet01_w[i].nm_pessoa												||
				sep_w || ie_dividendos_w												||
				sep_w || ie_residual_distr_w												||
				sep_w || ie_outros_pagamentos_w												||
				sep_w || ie_tipo_dividendos_w												||
				sep_w || trim(both replace(replace(to_char(vl_campo_10_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_11_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_12_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || vet01_w[i].ds_endereco_socio											||
				sep_w || trim(both to_char(vet01_w[i].pr_participacao,'900.99'))								||
				sep_w || trim(both replace(replace(to_char(vl_campo_15_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_16_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || vet01_w[i].ds_chave_pagto											||
				sep_w || trim(both replace(replace(to_char(vl_campo_18_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_19_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_20_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || vet01_w[i].vl_campo_21												||
				sep_w || trim(both replace(replace(to_char(vl_campo_22_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_23_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_24_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_25_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_26_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_27_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_28_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_29_w,'9999999999.99'),'.',''),',',''))						||
				sep_w || trim(both replace(replace(to_char(vl_campo_30_w,'9999999999.99'),'.',''),',',''))						|| sep_w ,1,2000);
	
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_linha_w		:= nr_linha_w + 1;	
	
	
	insert into fis_dim_arquivo(	nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_controle_dim,
		nr_linha,
		ds_arquivo,
		ds_arquivo_compl)
	values (nextval('fis_dim_arquivo_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		nr_linha_w,
		ds_arquivo_w,
		ds_arquivo_compl_w);	
	
	if (qt_commit_w >= 5000) then
		qt_commit_w	:= 0;
		commit;
	end if;	
	end;
end loop;


update	fis_dim_controle	
set	dt_geracao 	= clock_timestamp()
where 	nr_sequencia 	= nr_seq_controle_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_arquivo_dim ( nr_seq_controle_p bigint, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;

