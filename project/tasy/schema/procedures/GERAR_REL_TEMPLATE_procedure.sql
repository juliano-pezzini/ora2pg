-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rel_template ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

  
 /*	Criado por Thiago F. Ferretti 
	Criado por o template ser muito extenso e demorar para gerar 
	Antes de alterar entrar em contato com Thiago 
*/
 
ds_cabecalho_w    		varchar(32767);
ds_conteudo_w    		varchar(32000);
--ds_conteudo_w    		W_RELAT_EMISSAO_TEMPLATE.DS_TEMPLATE%type; 
ds_resultado_w    		varchar(32000);
ds_unid_medida_w		varchar(255);
ds_label_w    			varchar(255);
ds_template_w				varchar(255);
nr_seq_template_cluster_w	bigint;
nr_seq_registro_w			bigint;
dt_registro_w				timestamp;
nr_seq_template_w			bigint;
nr_ehr_template_w			bigint;
nr_seq_reg_template_w		bigint;
nr_registro_cluster_w		bigint;
dt_inicio_w					timestamp;
dt_final_w					timestamp;
ds_valor_w					varchar(4000);
cd_profissional_w			varchar(255);
ds_cod_prof_w			varchar(100);

--Cursor para trazer os registros dos templates 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
			a.dt_registro, 
			cd_profissional 
	from	ehr_registro a, 
			prontuario_emissao_item b 
	where	a.nr_sequencia = b.nr_seq_item 
	and		a.dt_registro between dt_inicio_w and dt_final_w 
	and		b.ie_tipo_item = 'TEMPLATEPEP' 
	and	b.nr_atendimento = (SELECT c.nr_atendimento from prontuario_emissao c where c.nr_sequencia = nr_sequencia_p) 
	and	obter_se_reg_lib_atencao(a.cd_paciente,a.cd_profissional,a.ie_nivel_atencao,a.nm_usuario,0) = 'S' 
	order by a.dt_registro;

--Cursor para trazer os tipos dos templates utilizados no registro 
C02 CURSOR FOR 
	SELECT	f.ds_template, 
			f.nr_sequencia, 
			d.nr_sequencia nr_seq_reg_template, 
			d.nr_seq_template 
	from	ehr_reg_template d, 
			ehr_template f 
	where	f.nr_sequencia  	= d.nr_seq_template 
	and		d.nr_seq_reg 		= nr_seq_registro_w 
	order by d.nr_seq_template;

--Cursor para trazer os resultados dos templates 
C03 CURSOR FOR 
SELECT	CASE WHEN coalesce(a.nr_seq_elem_visual::text, '') = '' THEN  rpad(coalesce(a.ds_label,' '),70,'_')  ELSE a.ds_label END  ds_label, 
		ehr_vlr(nr_seq_reg_template_w,a.nr_sequencia) ds_resultado, 
		a.ds_unid_medida, 
		nr_seq_elem_visual, 
		coalesce(a.nr_seq_template_cluster,0) nr_seq_template_cluster 
from	ehr_template_conteudo_v a 
where	a.nr_seq_template 		= nr_ehr_template_w 
and		coalesce(a.ie_situacao,'A') 	= 'A' 
and	(((ehr_vlr(nr_seq_reg_template_w,a.nr_sequencia) IS NOT NULL AND (ehr_vlr(nr_seq_reg_template_w,a.nr_sequencia))::text <> '')) or (nr_seq_elem_visual = 4)) 
order by coalesce(nr_seq_grid, a.nr_seq_apres);

C03_w C03%rowtype;

--Cursores c03 e c04 são para trazer as informações dos clusters 
C04 CURSOR FOR 
	SELECT	distinct a.nr_registro_cluster 
	from	ehr_reg_elemento a, 
			ehr_template_conteudo b 
	where	a.nr_seq_reg_template = nr_seq_reg_template_w 
	and		(a.nr_registro_cluster IS NOT NULL AND a.nr_registro_cluster::text <> '') 
	and		a.nr_seq_temp_conteudo = b.nr_sequencia 
	and		b.nr_seq_template = nr_seq_template_cluster_w 
	order by a.nr_registro_cluster;

 
C05 CURSOR FOR 
	SELECT	a.nr_seq_reg_template, 
			b.nr_sequencia, 
			rpad('   '||b.ds_label,70,'_') ds_label, 
			a.ds_resultado, 
			a.dt_resultado, 
			a.vl_resultado, 
			a.nr_registro_cluster, 
			substr(obter_desc_tipo_openehr(ehr_obter_inf_elemento(a.nr_seq_elemento,'TDADO')),1,50) ie_tipo_dado 
	from	ehr_reg_elemento a, 
			ehr_template_conteudo b 
	where	a.nr_seq_reg_template = nr_seq_reg_template_w 
	and		(a.nr_registro_cluster IS NOT NULL AND a.nr_registro_cluster::text <> '') 
	and		a.nr_seq_temp_conteudo = b.nr_sequencia 
	and		b.nr_seq_template = nr_seq_template_cluster_w 
	and		a.nr_registro_cluster = nr_registro_cluster_w 
	order by a.nr_registro_cluster;

C05_w C05%rowtype;

PROCEDURE gravarInformacaoBancoTemp(ds_descricao_p	text) IS 
	 
	ds_informacao_w	varchar(32000);
	
  
BEGIN 
	ds_informacao_w := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Courier New;}{\f1\fnil Courier New;}}{\colortbl ;\red0\green0\blue0;}\viewkind4\uc1\pard\cf1\lang1046\f0\fs20 '||wheb_rtf_pck.get_fonte(14);--Tamanho da letra 14 
	ds_informacao_w := ds_informacao_w||ds_descricao_p;
	--ds_informacao_w	:= replace(ds_informacao_w,'}',' \} '); 
	--ds_informacao_w	:= replace(ds_informacao_w,'{',' \{ '); 
 
	ds_informacao_w	:= ds_informacao_w||'}';
	 
	insert into W_RELAT_EMISSAO_TEMPLATE( 
			NR_SEQUENCIA, 
			DT_ATUALIZACAO, 
			DS_TEMPLATE, 
			dt_registro, 
			nm_usuario) 
	values (nextval('w_relat_emissao_template_seq'), 
			clock_timestamp(), 
			ds_informacao_w, 
			dt_registro_w, 
			nm_usuario_p);
 
	commit;
	 
	ds_conteudo_w := '';
  END;
 
begin 
 
delete from W_RELAT_EMISSAO_TEMPLATE 
where nm_usuario = nm_usuario_p;
 
select	max(dt_inicial), 
		max(dt_final) 
into STRICT	dt_inicio_w, 
		dt_final_w 
from	prontuario_emissao 
where	nr_sequencia = nr_sequencia_p;
 
open C01;
loop 
fetch C01 into 
	nr_seq_registro_w, 
	dt_registro_w, 
	cd_profissional_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	open C02;
	loop 
	fetch C02 into 
		ds_template_w, 
		nr_ehr_template_w, 
		nr_seq_reg_template_w, 
		nr_seq_template_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
			begin 
			select	substr(' (' || substr(max(coalesce(obter_dados_medico(cd_profissional_w,'SGCRM'),obter_dados_pf(cd_profissional_w,'CON')) || ':' || coalesce(obter_dados_medico(cd_profissional_w,'CRM'),obter_dados_pf(cd_profissional_w,'CPR'))),1,20) || ')',1,100) 
			into STRICT	ds_cod_prof_w 
			;
 
			ds_conteudo_w := wheb_rtf_pck.get_centralizado(true)||wheb_rtf_pck.get_negrito(true) || obter_desc_expressao(299216) || ' ' || ds_template_w||' - '|| 
								 to_char(dt_registro_w,'dd/mm/yyyy hh24:mi:ss')||wheb_rtf_pck.get_negrito(false)||' - '|| 
								 substr(obter_nome_pf(cd_profissional_w),1,255)||ds_cod_prof_w||wheb_rtf_pck.get_centralizado(false)||wheb_rtf_pck.get_quebra_linha;
			exception when others then 
				begin 
				gravarInformacaoBancoTemp(ds_conteudo_w);
				end;
			end;
		open C03;
		loop 
		fetch C03 into 
			C03_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			ds_resultado_w			:= substr(C03_w.ds_resultado,1,32000);
			ds_label_w  			:= substr(C03_w.ds_label,1,255);
			ds_unid_medida_w		:= substr(C03_w.ds_unid_medida,1,255);
			nr_seq_template_cluster_w	:= C03_w.nr_seq_template_cluster;
				begin 
				ds_conteudo_w := ds_conteudo_w||wheb_rtf_pck.get_negrito(true)||ds_label_w||wheb_rtf_pck.get_negrito(false)||ds_resultado_w||' '||ds_unid_medida_w||wheb_rtf_pck.get_quebra_linha;
				exception when others then 
					begin 
					gravarInformacaoBancoTemp(ds_conteudo_w);
					end;
			end;
			if (nr_seq_template_cluster_w > 0) then 
 
				open C04;
				loop 
				fetch C04 into 
					nr_registro_cluster_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */
					begin 
 
					open C05;
					loop 
					fetch C05 into 
						C05_w;
					EXIT WHEN NOT FOUND; /* apply on C05 */
						begin 
						ds_valor_w	:= null;
 
						if (C05_w.ie_tipo_dado = 'DV_TEXT') or (C05_w.ie_tipo_dado = 'DV_CODED_TEXT') or (C05_w.ie_tipo_dado = 'DV_TASY') or (C05_w.ie_tipo_dado = 'DV_BOOLEAN') then 
							ds_valor_w	:= C05_w.ds_resultado;
						elsif (C05_w.ie_tipo_dado = 'DV_COUNT') or (C05_w.ie_tipo_dado = 'DV_QUANTITY') then 
							ds_valor_w	:= C05_w.vl_resultado;
						elsif (C05_w.ie_tipo_dado = 'DV_DATE') or (C05_w.ie_tipo_dado = 'DV_TIME') or (C05_w.ie_tipo_dado = 'DV_DATE_TIME') then 
							ds_valor_w	:= to_char(C05_w.dt_resultado,'dd/mm/yyyy hh24:mi:ss');
						end if;
 
						if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then 
							begin 
							ds_conteudo_w := ds_conteudo_w ||wheb_rtf_pck.get_negrito(true)||c05_w.ds_label||wheb_rtf_pck.get_negrito(false)|| 
											 ds_valor_w||wheb_rtf_pck.get_quebra_linha;
							exception when others then 
								begin 
								gravarInformacaoBancoTemp(ds_conteudo_w);
								end;
							end;
						end if;
						end;
					end loop;
					close C05;
 
					end;
				end loop;
				close C04;
 
			end if;
 
			end;
		end loop;
		close C03;
 
	end;
	end loop;
	close C02;
	 
	gravarInformacaoBancoTemp(ds_conteudo_w);
 
end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rel_template ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

