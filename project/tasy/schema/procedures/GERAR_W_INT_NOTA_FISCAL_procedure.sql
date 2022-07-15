-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_int_nota_fiscal ( cd_fornecedor_p text, cd_condicao_pagamento_p text, cd_estabelecimento_p text, cd_natureza_operacao_p text, cd_operacao_nf_p text, cd_pessoa_fisica_p text, cd_serie_nf_p text, ds_erro_p text, ds_observacao_p text, dt_emissao_p text, dt_entrada_saida_p text, ie_processado_p text, nm_usuario_p text, nr_nota_fiscal_p text, vl_descontos_p text, vl_despesa_acessoria_p text, vl_frete_p text, vl_seguro_p text, nr_seq_nota_fiscal_p INOUT text) AS $body$
DECLARE


nr_seq_nota_fiscal_w	bigint;
ds_erro_w		varchar(4000);


BEGIN

select	nextval('w_int_nota_fiscal_seq')
into STRICT	nr_seq_nota_fiscal_w
;

begin

insert into w_int_nota_fiscal(
				nr_sequencia,
				cd_cnpj,
				nr_nota_fiscal,
				cd_condicao_pagamento,
				cd_estabelecimento,
				cd_natureza_operacao,
				cd_operacao_nf,
				cd_pessoa_fisica,
				cd_serie_nf,
				ds_observacao,
				dt_atualizacao,
				dt_atualizacao_nrec,
				dt_emissao,
				dt_entrada_saida,
				nm_usuario,
				nm_usuario_nrec,
				vl_descontos,
				vl_despesa_acessoria,
				vl_frete,
				vl_seguro)
values (	nr_seq_nota_fiscal_w,
	cd_fornecedor_p,
	nr_nota_fiscal_p,
	cd_condicao_pagamento_p,
	cd_estabelecimento_p,
	cd_natureza_operacao_p,
	cd_operacao_nf_p,
	cd_pessoa_fisica_p,
	cd_serie_nf_p,
	ds_observacao_p,
	clock_timestamp(),
	clock_timestamp(),
	to_date(dt_emissao_p,'dd/mm/yyyy'),
	to_date(dt_entrada_saida_p,'dd/mm/yyyy'),
	nm_usuario_p,
	nm_usuario_p,
	vl_descontos_p,
	vl_despesa_acessoria_p,
	vl_frete_p,
	vl_seguro_p);


exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
end;


nr_seq_nota_fiscal_p := nr_seq_nota_fiscal_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_int_nota_fiscal ( cd_fornecedor_p text, cd_condicao_pagamento_p text, cd_estabelecimento_p text, cd_natureza_operacao_p text, cd_operacao_nf_p text, cd_pessoa_fisica_p text, cd_serie_nf_p text, ds_erro_p text, ds_observacao_p text, dt_emissao_p text, dt_entrada_saida_p text, ie_processado_p text, nm_usuario_p text, nr_nota_fiscal_p text, vl_descontos_p text, vl_despesa_acessoria_p text, vl_frete_p text, vl_seguro_p text, nr_seq_nota_fiscal_p INOUT text) FROM PUBLIC;

