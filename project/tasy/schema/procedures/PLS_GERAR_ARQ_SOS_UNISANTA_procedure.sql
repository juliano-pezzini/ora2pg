-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_arq_sos_unisanta ( nr_seq_lote_p bigint, nm_arquivo_p text, ie_tipo_movimento_p text) AS $body$
DECLARE


arq_texto_w			utl_file.file_type;
ds_local_w			varchar(255) 		:= null;
ds_erro_w			varchar(255);
nm_arquivo_w			varchar(255);
file_exist_w			boolean;
size_w				bigint;
block_size_w			bigint;


nr_seq_benef_w			ptu_litoral_sos_unisanta_v.nr_seq_benef%type;
nr_seq_lote_w			ptu_litoral_sos_unisanta_v.nr_seq_lote%type;
cd_cartao_unimed_w 		ptu_litoral_sos_unisanta_v.cd_cartao_unimed%type;
nm_beneficiario_w 		ptu_litoral_sos_unisanta_v.nm_beneficiario%type;
ie_sexo_w 			ptu_litoral_sos_unisanta_v.ie_sexo%type;
ie_estado_civil_w 		ptu_litoral_sos_unisanta_v.ie_estado_civil%type;
dt_nascimento_w 		ptu_litoral_sos_unisanta_v.dt_nascimento%type;
ie_tipo_cliente_w 		ptu_litoral_sos_unisanta_v.ie_tipo_cliente%type;
nr_cpf_w 			ptu_litoral_sos_unisanta_v.nr_cpf%type;
ds_empresa_w			ptu_litoral_sos_unisanta_v.ds_empresa%type;
ie_home_care_w			ptu_litoral_sos_unisanta_v.ie_home_care%type;
ie_regulamentacao_w		ptu_litoral_sos_unisanta_v.ie_regulamentacao%type;
ie_cartao_facil_w		ptu_litoral_sos_unisanta_v.ie_cartao_facil%type;
ie_possui_sos_w			ptu_litoral_sos_unisanta_v.ie_possui_sos%type;
ie_tipo_acomodacao_w		ptu_litoral_sos_unisanta_v.ds_plano_sos%type;
ds_plano_sos_w			ptu_litoral_sos_unisanta_v.ds_plano_sos%type;
dt_inclusao_sos_w		ptu_litoral_sos_unisanta_v.dt_inclusao_sos%type;
dt_exclusao_sos_w		ptu_litoral_sos_unisanta_v.dt_exclusao_sos%type;
ie_tab_unisanta_w		ptu_litoral_sos_unisanta_v.ie_tab_unisanta%type;
dt_inclusao_unisanta_w     	ptu_litoral_sos_unisanta_v.dt_inclusao_unisanta%type;
ds_periodo_inclu_unisanta_w	ptu_litoral_sos_unisanta_v.ds_periodo_inclu_unisanta%type;
dt_exclusao_unisanta_w		ptu_litoral_sos_unisanta_v.dt_exclusao_unisanta%type;
ds_periodo_excl_unisanta_w	ptu_litoral_sos_unisanta_v.ds_periodo_excl_unisanta%type;
dt_carencia_unisanta_w		ptu_litoral_sos_unisanta_v.dt_carencia_unisanta%type;
cd_tab_preco_w			ptu_litoral_sos_unisanta_v.cd_tab_preco%type;
ie_comissao_vend_w		ptu_litoral_sos_unisanta_v.ie_comissao_vend%type;
cd_unimed_atend_w		ptu_litoral_sos_unisanta_v.cd_unimed_atend%type;
ie_cooperado_w			ptu_litoral_sos_unisanta_v.ie_cooperado%type;
cd_unimed_coop_w		ptu_litoral_sos_unisanta_v.cd_unimed_coop%type;
ie_colaborador_w		ptu_litoral_sos_unisanta_v.ie_colaborador%type;
nr_ddd_cel_w			ptu_litoral_sos_unisanta_v.nr_ddd_cel%type;
nr_celular_w			ptu_litoral_sos_unisanta_v.nr_celular%type;
ds_contrato_w			ptu_litoral_sos_unisanta_v.ds_contrato%type;
nr_ddd_contato_w		ptu_litoral_sos_unisanta_v.nr_ddd_contato%type;
nr_fone_contato_w		ptu_litoral_sos_unisanta_v.nr_fone_contato%type;
ds_endereco_resc_w		ptu_litoral_sos_unisanta_v.ds_endereco_resc%type;
ds_bairro_resc_w		ptu_litoral_sos_unisanta_v.ds_bairro_resc%type;
cd_cep_resc_w			ptu_litoral_sos_unisanta_v.cd_cep_resc%type;
cd_cidade_resc_w		ptu_litoral_sos_unisanta_v.cd_cidade_resc%type;
uf_sg_resc_w			ptu_litoral_sos_unisanta_v.uf_sg_resc%type;
ds_complemento_resc_w		ptu_litoral_sos_unisanta_v.ds_complemento_resc%type;
nr_ddd_resc_w			ptu_litoral_sos_unisanta_v.nr_ddd_resc%type;
nr_fone_resc_w			ptu_litoral_sos_unisanta_v.nr_fone_resc%type;
ds_endereco_comer_w		ptu_litoral_sos_unisanta_v.ds_endereco_comer%type;
ds_bairro_comer_w		ptu_litoral_sos_unisanta_v.ds_bairro_comer%type;
cd_cep_comer_w			ptu_litoral_sos_unisanta_v.cd_cep_comer%type;
ds_cidade_comer_w		ptu_litoral_sos_unisanta_v.ds_cidade_comer%type;
uf_sg_comer_w			ptu_litoral_sos_unisanta_v.uf_sg_comer%type;
ds_complemento_comer_w		ptu_litoral_sos_unisanta_v.ds_complemento_comer%type;
nr_ddd_comer_w			ptu_litoral_sos_unisanta_v.nr_ddd_comer%type;
nr_fone_comer_w			ptu_litoral_sos_unisanta_v.nr_fone_comer%type;
nm_mae_w			ptu_litoral_sos_unisanta_v.nm_mae%type;
dt_atualizaco_w			ptu_litoral_sos_unisanta_v.dt_atualizaco%type;
ie_possui_unimed_w		ptu_litoral_sos_unisanta_v.ie_possui_unimed%type;
cd_unimed_origem_w		ptu_litoral_sos_unisanta_v.cd_unimed_origem%type;
ie_ativo_w			ptu_litoral_sos_unisanta_v.ie_ativo%type;


C01 CURSOR FOR
SELECT 	nr_seq_benef,
	nr_seq_lote,
	cd_cartao_unimed,
	nm_beneficiario,
	ie_sexo,
	ie_estado_civil,
	dt_nascimento,
	ie_tipo_cliente,
	nr_cpf,
	ds_empresa,
	ie_home_care ,
	ie_regulamentacao,
	ie_cartao_facil,
	ie_possui_sos,
	ie_tipo_acomodacao,
	ds_plano_sos,
	dt_inclusao_sos,
	dt_exclusao_sos,
	ie_tab_unisanta,
	dt_inclusao_unisanta,
	ds_periodo_inclu_unisanta,
	dt_exclusao_unisanta,
	ds_periodo_excl_unisanta,
	dt_carencia_unisanta,
	cd_tab_preco,
	ie_comissao_vend,
	cd_unimed_atend,
	ie_cooperado,
	cd_unimed_coop,
	ie_colaborador,
	nr_ddd_cel,
	nr_celular,
	ds_contrato,
	nr_ddd_contato,
	nr_fone_contato,
	ds_endereco_resc,
	ds_bairro_resc,
	cd_cep_resc,
	cd_cidade_resc,
	uf_sg_resc,
	ds_complemento_resc,
	nr_ddd_resc,
	nr_fone_resc,
	ds_endereco_comer,
	ds_bairro_comer,
	cd_cep_comer,
	ds_cidade_comer,
	uf_sg_comer,
	ds_complemento_comer,
	nr_ddd_comer,
	nr_fone_comer,
	nm_mae,
	dt_atualizaco,
	ie_possui_unimed,
	cd_unimed_origem,
	ie_ativo
from 	ptu_litoral_sos_unisanta_v
where	nr_seq_lote  = 	nr_seq_lote_p
order by nr_seq_lote,nr_seq_benef;


BEGIN
nm_arquivo_w := replace(nm_arquivo_p,'\','');	--' -- comentario pra não deixar o resto do fonte em vermelho
--Obtém os dados do arquivo no diretório
utl_file.fgetattr(ds_local_w,nm_arquivo_w,file_exist_w,size_w,block_size_w);

--Caso existir, remove ele para não criar registros no arquivo já criado
if (file_exist_w) then
	utl_file.fremove(ds_local_w,nm_arquivo_w);
end if;

begin
SELECT * FROM obter_evento_utl_file(17, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
exception
when others then
	ds_local_w := null;
end;

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
end if;

begin
arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W');
exception
when others then
	ds_erro_w := obter_erro_utl_open(SQLSTATE);
	CALL wheb_mensagem_pck.exibir_mensagem_abort('Local: '||ds_local_w||' Nome arquivo: '||nm_arquivo_w||' '||ds_erro_w);
end;

open C01;
loop
fetch C01 into
	nr_seq_benef_w,
	nr_seq_lote_w,
	cd_cartao_unimed_w,
	nm_beneficiario_w,
	ie_sexo_w,
	ie_estado_civil_w,
	dt_nascimento_w,
	ie_tipo_cliente_w,
	nr_cpf_w,
	ds_empresa_w,
	ie_home_care_w,
	ie_regulamentacao_w,
	ie_cartao_facil_w,
	ie_possui_sos_w,
	ie_tipo_acomodacao_w,
	ds_plano_sos_w,
	dt_inclusao_sos_w,
	dt_exclusao_sos_w,
	ie_tab_unisanta_w,
	dt_inclusao_unisanta_w,
	ds_periodo_inclu_unisanta_w,
	dt_exclusao_unisanta_w,
	ds_periodo_excl_unisanta_w,
	dt_carencia_unisanta_w,
	cd_tab_preco_w,
	ie_comissao_vend_w,
	cd_unimed_atend_w,
	ie_cooperado_w,
	cd_unimed_coop_w,
	ie_colaborador_w,
	nr_ddd_cel_w,
	nr_celular_w,
	ds_contrato_w,
	nr_ddd_contato_w,
	nr_fone_contato_w,
	ds_endereco_resc_w,
	ds_bairro_resc_w,
	cd_cep_resc_w,
	cd_cidade_resc_w,
	uf_sg_resc_w,
	ds_complemento_resc_w,
	nr_ddd_resc_w,
	nr_fone_resc_w,
	ds_endereco_comer_w,
	ds_bairro_comer_w,
	cd_cep_comer_w,
	ds_cidade_comer_w,
	uf_sg_comer_w,
	ds_complemento_comer_w,
	nr_ddd_comer_w,
	nr_fone_comer_w,
	nm_mae_w,
	dt_atualizaco_w,
	ie_possui_unimed_w,
	cd_unimed_origem_w,
	ie_ativo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	utl_file.put_line( arq_texto_w,substr(lpad(coalesce( cd_cartao_unimed_w,0),17,' '),1,17)||
		substr(rpad(coalesce(nm_beneficiario_w,' '),60,' '),1,60)||
		substr(rpad(coalesce(ie_sexo_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(ie_estado_civil_w,' '),1,' '),1,1)||
		lpad(coalesce(to_char(dt_nascimento_w, 'dd/mm/yyyy'),0),10,' ')||
		substr(rpad(coalesce(ie_tipo_cliente_w,' '),1,' '),1,1)||
		substr(lpad(coalesce(nr_cpf_w,'0'),11,'0'),1,11)||
		substr(lpad(coalesce(ds_empresa_w,' '),20,' '),1,20)||
		substr(rpad(coalesce(ie_home_care_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(ie_regulamentacao_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(ie_tipo_acomodacao_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(ie_cartao_facil_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(ie_possui_sos_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(ds_plano_sos_w,' '),2,' '),1,2)||
		lpad(coalesce(to_char(dt_inclusao_sos_w, 'dd/mm/yyyy'),' '),10,' ')||
		lpad(coalesce(to_char(dt_exclusao_sos_w, 'dd/mm/yyyy'),' '),10,' ')||
		substr(rpad(coalesce(ie_tab_unisanta_w,0),1,' '),1,1)||
		lpad(coalesce(to_char(dt_inclusao_unisanta_w, 'dd/mm/yyyy'),' '),10,' ')||
		substr(rpad(coalesce(ds_periodo_inclu_unisanta_w,' '),6,' '),1,6)||
		lpad(coalesce(to_char(dt_exclusao_unisanta_w, 'dd/mm/yyyy'),' '),10,' ')||
		substr(rpad(coalesce(ds_periodo_excl_unisanta_w,' '),6,' '),1,6)||
		lpad(coalesce(to_char(dt_carencia_unisanta_w, 'dd/mm/yyyy'),' '),10,' ')||
		substr(rpad(coalesce(cd_tab_preco_w,' '),4,' '),1,4)||
		substr(rpad(coalesce(ie_comissao_vend_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(cd_unimed_atend_w,' '),4,' '),1,4)||
		substr(rpad(coalesce(ie_cooperado_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(cd_unimed_coop_w,' '),9,' '),1,9)||
		substr(rpad(coalesce(ie_colaborador_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(nr_ddd_cel_w,' '),3,' '),1,3)||
		substr(rpad(coalesce(nr_celular_w,' '),9,' '),1,9)||
		substr(rpad(coalesce(ds_contrato_w,' '),60,' '),1,60)||
		substr(rpad(coalesce(nr_ddd_contato_w,' '),3,' '),1,3)||
		substr(rpad(coalesce(nr_fone_contato_w,' '),9,' '),1,9)||
		substr(rpad(coalesce(ds_endereco_resc_w,' '),60,' '),1,60)||
		substr(rpad(coalesce(ds_bairro_resc_w,' '),40,' '),1,40)||
		substr(rpad(coalesce(cd_cep_resc_w,0),8,' '),1,8)||
		substr(rpad(coalesce(cd_cidade_resc_w,' '),40,' '),1,40)||
		substr(rpad(coalesce(uf_sg_resc_w,' '),2,' '),1,2)||
		substr(rpad(coalesce(ds_complemento_resc_w,' '),40,' '),1,40)||
		substr(rpad(coalesce(nr_ddd_resc_w,0),3,' '),1,3)||
		substr(rpad(coalesce(nr_fone_resc_w,0),9,' '),1,9)||
		substr(rpad(coalesce(ds_endereco_comer_w,' '),60,' '),1,60)||
		substr(rpad(coalesce(ds_bairro_comer_w,' '),40,' '),1,40)||
		substr(rpad(coalesce(cd_cep_comer_w,' '),8,' '),1,8)||
		substr(rpad(coalesce(ds_cidade_comer_w,' '),40,' '),1,40)||
		substr(rpad(coalesce(uf_sg_comer_w,' '),2,' '),1,2)||
		substr(rpad(coalesce(ds_complemento_comer_w,' '),40,' '),1,40)||
		substr(rpad(coalesce(nr_ddd_comer_w,' '),3,' '),1,3)||
		substr(rpad(coalesce(nr_fone_comer_w,' '),9,' '),1,9)||
		substr(rpad(coalesce(nm_mae_w,' '),60,' '),1,60)||
		lpad(coalesce(to_char(dt_atualizaco_w, 'dd/mm/yyyy'),' '),10,' ')||
		substr(rpad(coalesce(ie_possui_unimed_w,' '),1,' '),1,1)||
		substr(rpad(coalesce(cd_unimed_origem_w,' '),4,' '),1,4)||
		substr(rpad(coalesce(ie_ativo_w,' '),1,' '),1,1)

		||chr(13));
		utl_file.fflush(arq_texto_w);
	end;
end loop;
close C01;


utl_file.fclose(arq_texto_w);

update  ptu_mov_produto_lote
set     ds_arquivo = nm_arquivo_w
where   nr_sequencia = nr_seq_lote_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_arq_sos_unisanta ( nr_seq_lote_p bigint, nm_arquivo_p text, ie_tipo_movimento_p text) FROM PUBLIC;
