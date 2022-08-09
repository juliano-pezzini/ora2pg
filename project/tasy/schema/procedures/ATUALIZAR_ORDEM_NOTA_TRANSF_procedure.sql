-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ordem_nota_transf ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_ordem_compra_w	bigint;
cd_estabelecimento_w	smallint;
nm_estabelecimento_w	varchar(80);
ds_historico_w		varchar(255);


BEGIN

select	nr_ordem_compra,
	cd_estabelecimento
into STRICT	nr_ordem_compra_w,
	cd_estabelecimento_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

select	substr(obter_nome_estabelecimento(cd_estabelecimento_w),1,80)
into STRICT	nm_estabelecimento_w
;


ds_historico_w	:= WHEB_MENSAGEM_PCK.get_texto(100332687, 'nm_estabelecimento_w='||nm_estabelecimento_w);

CALL inserir_historico_ordem_compra(
			nr_ordem_compra_w,
			'S',
			obter_desc_expressao(728564),
			ds_historico_w,
			nm_usuario_p);

/*commit; Não pode ter commit....*/

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ordem_nota_transf ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
