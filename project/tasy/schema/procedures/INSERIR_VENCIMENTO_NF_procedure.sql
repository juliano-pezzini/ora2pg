-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_vencimento_nf ( nr_sequencia_p bigint, dt_vencimento_p timestamp, vl_vencimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_serie_nf_w		nota_fiscal.cd_serie_nf%type;
nr_sequencia_nf_w		bigint;
cd_estabelecimento_w	smallint;
cd_cgc_emitente_w	varchar(14);
nr_nota_fiscal_w		varchar(255);



BEGIN

select	cd_serie_nf,
	nr_sequencia_nf,
	cd_estabelecimento,
	nr_nota_fiscal,
	cd_cgc_emitente
into STRICT	cd_serie_nf_w,
	nr_sequencia_nf_w,
	cd_estabelecimento_w,
	nr_nota_fiscal_w,
	cd_cgc_emitente_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

insert into nota_fiscal_venc(	nr_sequencia,
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_nota_fiscal,
				nr_sequencia_nf,
				dt_vencimento,
				vl_vencimento,
				dt_atualizacao,
				nm_usuario,
				vl_base_venc,
				vl_desconto,
				vl_desc_financ,
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
				vl_vencimento_p,
				0,
				0,
				'N');
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_vencimento_nf ( nr_sequencia_p bigint, dt_vencimento_p timestamp, vl_vencimento_p bigint, nm_usuario_p text) FROM PUBLIC;

