-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_fiscal_venc_import ( nr_sequencia_p nota_fiscal.nr_sequencia%type, vl_vencimento_p nota_fiscal_venc.vl_vencimento%type, dt_vencimento_p timestamp, nm_usuario_p text) AS $body$
DECLARE

	
cd_serie_nf_w           nota_fiscal.cd_serie_nf%type;
cd_estabelecimento_w    nota_fiscal.cd_estabelecimento%type;
dt_emissao_w		nota_fiscal.dt_emissao%type;
cd_cgc_emitente_w	nota_fiscal.cd_cgc_emitente%type;
nr_nota_fiscal_w	nota_fiscal.nr_nota_fiscal%type;
nr_sequencia_nf_w	nota_fiscal.nr_sequencia_nf%type;
dt_entrada_saida_w  nota_fiscal.dt_entrada_saida%type;


BEGIN

select	cd_estabelecimento,
	dt_emissao,
	dt_entrada_saida,
	cd_cgc_emitente,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf
into STRICT	cd_estabelecimento_w,
	dt_emissao_w,
	dt_entrada_saida_w,
	cd_cgc_emitente_w,
	cd_serie_nf_w,
	nr_nota_fiscal_w,
	nr_sequencia_nf_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

delete	from nota_fiscal_venc
where	nr_sequencia = nr_sequencia_p;

insert into nota_fiscal_venc(
    nr_sequencia,
    cd_estabelecimento,
    cd_cgc_emitente,
    cd_serie_nf,
    nr_nota_fiscal,
    nr_sequencia_nf,
    dt_vencimento,
    vl_vencimento,
    dt_atualizacao,
    nm_usuario,
    ie_origem)
values (	nr_sequencia_p,
    cd_estabelecimento_w,
    cd_cgc_emitente_w,
    cd_serie_nf_w,
    nr_nota_fiscal_w,
    nr_sequencia_nf_w,
    dt_vencimento_p,
    vl_vencimento_p,
    clock_timestamp(),
    nm_usuario_p,
    'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_fiscal_venc_import ( nr_sequencia_p nota_fiscal.nr_sequencia%type, vl_vencimento_p nota_fiscal_venc.vl_vencimento%type, dt_vencimento_p timestamp, nm_usuario_p text) FROM PUBLIC;
