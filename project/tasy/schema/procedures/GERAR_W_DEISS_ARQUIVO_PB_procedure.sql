-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_deiss_arquivo_pb (dt_inicio_p timestamp, dt_fim_p timestamp, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE

 
/*variáveis para montagem da interface*/
 
vl_imp_emit_w				double precision;
ie_entrada_saida_w			varchar(1);
vl_t_imp_devido_rec_w			double precision;
vl_total_imposto_devido_w		double precision;
dt_anor_ref_w				varchar(4);
dt_mes_ref_w				varchar(2);
qt_tot_nf_rec_w				bigint;
ds_versao_w				varchar(3);	--cabeçalho 
ds_registro_w				varchar(3);
cd_cnpj_declarante_w			varchar(16);
nr_ano_referencia_w			smallint;
nr_mes_referencia_w			smallint;
ie_original_w				smallint;
cd_contabilidade_w			bigint;
cd_cnpj_cpf_w				varchar(16);
nr_inscricao_municipal_w		bigint;
cd_serie_nf_w				varchar(12);	--nota 
tp_nota_fiscal_w			varchar(3);
tp_documento_w				varchar(3);
nr_nota_fiscal_w			numeric(20);
data_emissao_w				varchar(12);
cd_cpf_cnpj_prest_w			varchar(16);
vl_bruto_nf_w				double precision;
tp_recolhimento_w			varchar(3);
ds_nome_razao_social_w			varchar(87);
ds_cidade_w				varchar(32);
ds_uf_sigla_w				varchar(4);
cd_servico_w				integer;	--item 
vl_base_calc_w				double precision;
pr_aliquota_empresa_w			real;
pr_aliquota_servico_w			real;
vl_imposto_declarante_w			double precision;
qt_tot_nf_w				bigint;	--totalizador 
qt_tot_nf_emitida_w			bigint;
vl_tot_nf_emitida_w			double precision;
vl_tot_imp_w				double precision;
vl_tot_recolhimento_w			double precision;
qt_tot_nf_recebida_w			bigint;
vl_tot_nf_recebida_w			double precision;
vl_tot_imp_alicota_w			double precision;
ds_texto_w				varchar(255);
nr_sequencia_nota_w			bigint;
nr_sequencia_item_w			bigint;
vl_imp_receb_w				double precision;
contador_w				bigint := 0;
vl_descontos_w				double precision;
vl_desconto_rest_w			double precision;
vl_tributo_w				double precision;
vl_total_nf_w				double precision;
vl_diferenca_w				double precision;
ds_dif_aux_w				varchar(20);

/*cursor responsável por registro de notas Fiscais*/
 
c01 CURSOR FOR 
SELECT	n.nr_sequencia, 
	'3', 
	'n', 
	n.cd_serie_nf, 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'R'  ELSE 'E' END , 
	'N', 
	n.nr_nota_fiscal, 
	to_char(n.dt_emissao,'dd/mm/yyyy'), 
	lpad(CASE WHEN coalesce(n.cd_cgc::text, '') = '' THEN  substr(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11)  ELSE n.cd_cgc END ,14,'0'), 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='S' THEN (n.vl_total_nota+n.vl_descontos)  ELSE n.vl_mercadoria END , 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'O'  ELSE 'P' END , 
	'', 
	'', 
	'' 
from	nota_fiscal n, 
	operacao_nota o 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S' 
and	n.ie_situacao in ('1') 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	o.ie_servico = 'S' 
and	n.cd_estabelecimento = cd_estabelecimento_p 
and	n.dt_emissao between to_date(to_char(dt_inicio_p,'dd/mm/yyyy'),'dd/mm/yyyy') and fim_dia(to_date(to_char(dt_fim_p,'dd/mm/yyyy'),'dd/mm/yyyy')) 
group by n.nr_sequencia, 
	n.cd_serie_nf, 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'R'  ELSE 'E' END , 
	n.nr_nota_fiscal, 
	to_char(n.dt_emissao,'dd/mm/yyyy'), 
	lpad(CASE WHEN coalesce(n.cd_cgc::text, '') = '' THEN  substr(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11)  ELSE n.cd_cgc END ,14,'0'), 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='S' THEN (n.vl_total_nota+n.vl_descontos)  ELSE n.vl_mercadoria END , 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'O'  ELSE 'P' END  

union all
 
SELECT	n.nr_sequencia, 
	'3', 
	'n', 
	n.cd_serie_nf, 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'R'  ELSE 'E' END , 
	'N', 
	n.nr_nota_fiscal, 
	to_char(n.dt_emissao,'dd/mm/yyyy'), 
	lpad(CASE WHEN coalesce(n.cd_pessoa_fisica::text, '') = '' THEN  n.cd_cgc  ELSE substr(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11) END ,14,'0'), 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='S' THEN (n.vl_total_nota+n.vl_descontos)  ELSE n.vl_mercadoria END , 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'O'  ELSE 'P' END , 
	'', 
	'', 
	'' 
from	nota_fiscal n, 
	operacao_nota o 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'E' 
and 	substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CDM'),1,20) = '411850' 
and	n.cd_serie_nf = 'F' 
and	n.ie_situacao in ('1') 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	o.ie_servico = 'S' 
and	n.cd_estabelecimento = cd_estabelecimento_p 
and	n.dt_emissao between to_date(to_char(dt_inicio_p,'dd/mm/yyyy'),'dd/mm/yyyy') and fim_dia(to_date(to_char(dt_fim_p,'dd/mm/yyyy'),'dd/mm/yyyy')) 
group by n.nr_sequencia, 
	n.cd_serie_nf, 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'R'  ELSE 'E' END , 
	n.nr_nota_fiscal, 
	to_char(n.dt_emissao,'dd/mm/yyyy'), 
	lpad(CASE WHEN coalesce(n.cd_pessoa_fisica::text, '') = '' THEN  n.cd_cgc  ELSE substr(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11) END ,14,'0'), 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='S' THEN (n.vl_total_nota+n.vl_descontos)  ELSE n.vl_mercadoria END , 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN 'O'  ELSE 'P' END;

/*cursor responsável por registros do item da nota fiscal - EMITIDO-RECEBIDO*/
 
c02 CURSOR FOR 
SELECT	n.nr_sequencia, 
	'3', 
	'i', 
	8610101, 
	(i.vl_liquido - coalesce(n.vl_descontos,0)), 
	2, 
	2,	 
	i.vl_total_item_nf 
from	nota_fiscal n, 
	operacao_nota o, 
	nota_fiscal_item i 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and	n.nr_sequencia = i.nr_sequencia 
and	((obter_se_nota_entrada_saida(n.nr_sequencia) = 'S') or 
	((obter_se_nota_entrada_saida(n.nr_sequencia) = 'E') and (obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CDM') = '411850') 
	and (n.cd_serie_nf = 'F'))) 
and	n.nr_sequencia = nr_sequencia_nota_w 
and	n.ie_situacao in ('1') 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	o.ie_servico = 'S' 
and	n.cd_estabelecimento = cd_estabelecimento_p 
and	n.dt_emissao between to_date(to_char(dt_inicio_p,'dd/mm/yyyy'),'dd/mm/yyyy') and fim_dia(to_date(to_char(dt_fim_p,'dd/mm/yyyy'),'dd/mm/yyyy')) 
order by i.vl_liquido asc;


BEGIN 
/*início*/
 
vl_tot_nf_recebida_w := 0;
vl_tot_nf_emitida_w := 0;
 
 
delete	FROM w_deiss_arquivo 
where	nm_usuario = nm_usuario_p;
 
select	to_char(dt_inicio_p,'mm'), 
	to_char(dt_inicio_p,'yyyy') 
into STRICT	dt_mes_ref_w, 
	dt_anor_ref_w
;
 
vl_total_imposto_devido_w 	:= 0;
vl_t_imp_devido_rec_w	:= 0;
 
/*Identifica o contribuinte declarante*/
 
select	'3', 
	'h', 
	substr(somente_numero(e.cd_cgc),1,14), 
	dt_anor_ref_w, 
	dt_mes_ref_w, 
	0, 
	00771462000102, 
	obter_dados_pf(s.cd_contabilista,'CPF'), 
	240700 
into STRICT	ds_versao_w, 
	ds_registro_w, 
	cd_cnpj_declarante_w, 
	nr_ano_referencia_w, 
	nr_mes_referencia_w, 
	ie_original_w, 
	cd_contabilidade_w, 
	cd_cnpj_cpf_w, 
	nr_inscricao_municipal_w 
from	estabelecimento e, 
	empresa s 
where	e.cd_estabelecimento = cd_estabelecimento_p 
and	e.cd_empresa	   = s.cd_empresa  LIMIT 1;
 
ds_texto_w := 	('''3'''||','||'''H'''||','||''''||cd_cnpj_declarante_w||''''||','||nr_ano_referencia_w||','|| 
		nr_mes_referencia_w||','||0||','||'00771462000102'||','||''''||cd_cnpj_cpf_w||''''||','||nr_inscricao_municipal_w);
 
insert 	into 	w_deiss_arquivo( 
		nr_sequencia, 
		nm_usuario, 
		nr_linha, 
		cd_registro, 
		ds_arquivo) 
	values (nextval('w_deiss_arquivo_seq'), 
		nm_usuario_p, 
		null, 
		1, 
		ds_texto_w);
 
/*Identifica a nota fiscal*/
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_nota_w, 
	ds_versao_w, 
	ds_registro_w, 
	cd_serie_nf_w, 
	tp_nota_fiscal_w, 
	tp_documento_w, 
	nr_nota_fiscal_w, 
	data_emissao_w, 
	cd_cpf_cnpj_prest_w, 
	vl_bruto_nf_w, 
	tp_recolhimento_w, 
	ds_nome_razao_social_w, 
	ds_cidade_w, 
	ds_uf_sigla_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_texto_w :=	('''3'''||','||'''N'''||','||''''||cd_serie_nf_w||''''||','||''''||tp_nota_fiscal_w||''''||','|| 
			''''||tp_documento_w||''''||','||nr_nota_fiscal_w||','||data_emissao_w||','|| 
			''''||cd_cpf_cnpj_prest_w||''''||','||campo_mascara(vl_bruto_nf_w,2)||','||''''||tp_recolhimento_w||''''||','|| 
			''''||ds_nome_razao_social_w||''''||','||''''||ds_cidade_w||''''||','||''''||ds_uf_sigla_w||'''');
 
	insert 	into 	w_deiss_arquivo( 
			nr_sequencia, 
			nm_usuario, 
			nr_linha, 
			cd_registro, 
			ds_arquivo) 
		values (nextval('w_deiss_arquivo_seq'), 
			nm_usuario_p, 
			nr_sequencia_nota_w, 
			2, 
			ds_texto_w);
 
	/*Identifica os serviços de uma determinada nota fiscal (item nota fiscal)*/
 
	select	0 vl_descontos 
	into STRICT	vl_desconto_rest_w 
	from	nota_fiscal 
	where	nr_sequencia = nr_sequencia_nota_w;
 
	open c02;
	loop 
	fetch c02 into 
		nr_sequencia_item_w, 
		ds_versao_w, 
		ds_registro_w, 
		cd_servico_w, 
		vl_base_calc_w, 
		pr_aliquota_empresa_w, 
		pr_aliquota_servico_w, 
		vl_imposto_declarante_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		 
		select	obter_se_nota_entrada_saida(nr_sequencia_nota_w) 
		into STRICT	ie_entrada_saida_w 
		;		
		 
		if (ie_entrada_saida_w = 'E') then 
			vl_desconto_rest_w:= 0;		
		end if;
		 
		vl_total_nf_w := 0;
		 
		if (vl_desconto_rest_w = 0) then 
			vl_total_nf_w := vl_imposto_declarante_w;
			vl_imposto_declarante_w := ((vl_imposto_declarante_w) * 2/100);
		else 
			if (vl_imposto_declarante_w >= vl_desconto_rest_w) then 
				vl_total_nf_w := vl_imposto_declarante_w - vl_desconto_rest_w;
				vl_imposto_declarante_w := ((vl_imposto_declarante_w - vl_desconto_rest_w) * 2/100);
				vl_desconto_rest_w := 0;
			elsif (vl_imposto_declarante_w < vl_desconto_rest_w) then 
				vl_descontos_w := vl_desconto_rest_w - vl_imposto_declarante_w;
				vl_total_nf_w := vl_imposto_declarante_w - vl_descontos_w;
				vl_imposto_declarante_w := ((vl_imposto_declarante_w - vl_descontos_w) * 2/100);
				vl_desconto_rest_w := vl_desconto_rest_w - vl_descontos_w;
			end if;
			 
		end if;
		 
		ds_dif_aux_w	:= substr(to_char(vl_imposto_declarante_w - trunc(vl_imposto_declarante_w)),2,20);
 
		/* 
		if	(nvl(substr(ds_dif_aux_w,3,1),'0') = '5') and 
			(to_number(nvl(substr(ds_dif_aux_w,4,20),'0')) = 0) then 
			begin 
			 
			vl_imposto_declarante_w := trunc(vl_imposto_declarante_w,2); 
			 
			end; 
		else 
			begin 
			 
			vl_imposto_declarante_w := round(vl_imposto_declarante_w,2); 
			 
			end; 
		end if; 
		*/
 
		 
		vl_imposto_declarante_w := round_abnt(vl_imposto_declarante_w,2);
		 
		if (ie_entrada_saida_w = 'S') then 
			vl_tot_nf_emitida_w := vl_tot_nf_emitida_w + vl_total_nf_w;
			vl_total_imposto_devido_w := vl_total_imposto_devido_w + vl_imposto_declarante_w;
			 
		elsif (ie_entrada_saida_w = 'E') then 
			vl_tot_nf_recebida_w := vl_tot_nf_recebida_w + vl_total_nf_w;
			vl_t_imp_devido_rec_w := vl_t_imp_devido_rec_w + vl_imposto_declarante_w;
			 
		end if;
		 
		ds_texto_w :=	('''3'''||','||'''I'''||','||coalesce(cd_servico_w,0)||','||coalesce(campo_mascara(vl_total_nf_w,2),0.00)||','||coalesce(campo_mascara(pr_aliquota_empresa_w,4),0.0000)||','|| 
				coalesce(campo_mascara(pr_aliquota_servico_w,4),0.0000)||','||coalesce(campo_mascara(vl_imposto_declarante_w,2),0.00));
 
		insert 	into 	w_deiss_arquivo( 
				nr_sequencia, 
				nm_usuario, 
				nr_linha, 
				cd_registro, 
				ds_arquivo) 
			values (nextval('w_deiss_arquivo_seq'), 
				nm_usuario_p, 
				nr_sequencia_item_w, 
				3, 
				ds_texto_w);
		end;
	end loop;
	close c02;
	end;
	 
	contador_w := 0;
	 
end loop;
close c01;
 
/*Contém a totalização dos valores dos registros*/
 
select	count(*) 
into STRICT	qt_tot_nf_w 
from	nota_fiscal n, 
	operacao_nota o 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and	((obter_se_nota_entrada_saida(n.nr_sequencia) = 'S') or 
	((obter_se_nota_entrada_saida(n.nr_sequencia) = 'E') and (obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CDM') = '411850') 
	and (n.cd_serie_nf = 'F'))) 
and	n.ie_situacao in ('1') 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	o.ie_servico = 'S' 
and	n.cd_estabelecimento = cd_estabelecimento_p 
and	n.dt_emissao between to_date(to_char(dt_inicio_p,'dd/mm/yyyy'),'dd/mm/yyyy') and fim_dia(to_date(to_char(dt_fim_p,'dd/mm/yyyy'),'dd/mm/yyyy'));
 
select	count(*) 
into STRICT	qt_tot_nf_emitida_w 
from	nota_fiscal n, 
	operacao_nota o 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and (obter_se_nota_entrada_saida(n.nr_sequencia) = 'S') 
and	n.ie_situacao in ('1') 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	o.ie_servico = 'S' 
and	n.cd_estabelecimento = cd_estabelecimento_p 
and	n.dt_emissao between to_date(to_char(dt_inicio_p,'dd/mm/yyyy'),'dd/mm/yyyy') and fim_dia(to_date(to_char(dt_fim_p,'dd/mm/yyyy'),'dd/mm/yyyy'));
 
select	count(*) 
into STRICT	qt_tot_nf_rec_w 
from	nota_fiscal n, 
	operacao_nota o 
where	n.cd_operacao_nf = o.cd_operacao_nf 
and	((obter_se_nota_entrada_saida(n.nr_sequencia) = 'E') and (obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CDM') = '411850') 
	and (n.cd_serie_nf = 'F')) 
and	n.ie_situacao in ('1') 
and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '') 
and	o.ie_servico = 'S' 
and	n.cd_estabelecimento = cd_estabelecimento_p 
and	n.dt_emissao between to_date(to_char(dt_inicio_p,'dd/mm/yyyy'),'dd/mm/yyyy') and fim_dia(to_date(to_char(dt_fim_p,'dd/mm/yyyy'),'dd/mm/yyyy'));
 
ds_texto_w := 	('''3'''||','||'''T'''||','||coalesce(qt_tot_nf_w,0)||','||coalesce(qt_tot_nf_emitida_w,0)||','||coalesce(Campo_Mascara(vl_tot_nf_emitida_w,2),0)||','|| 
		coalesce(Campo_Mascara(vl_total_imposto_devido_w,2),0)||','||'0.00'||','||coalesce(qt_tot_nf_rec_w,0)||','||coalesce(Campo_Mascara(vl_tot_nf_recebida_w,2),0)||','|| 
		coalesce(Campo_Mascara(vl_t_imp_devido_rec_w,2),0));
 
insert 	into 	w_deiss_arquivo( 
		nr_sequencia, 
		nm_usuario, 
		nr_linha, 
		cd_registro, 
		ds_arquivo) 
	values (nextval('w_deiss_arquivo_seq'), 
		nm_usuario_p, 
		null, 
		9, 
		ds_texto_w);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_deiss_arquivo_pb (dt_inicio_p timestamp, dt_fim_p timestamp, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;
