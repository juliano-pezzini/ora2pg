-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_titulos_desconto_folha ( nr_seq_cobranca_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_banco_w		cobranca_escritural.nr_seq_conta_banco%type;
nr_conta_w			pls_contrato_pagador_fin.cd_conta%type;
ie_digito_conta_w		pls_contrato_pagador_fin.ie_digito_conta%type;
nr_seq_empresa_w		pls_desc_empresa.nr_sequencia%type;
nr_seq_vinculo_empresa_w	pls_empresa_vinculo.nr_sequencia%type;
nr_titulo_w			titulo_receber.nr_titulo%type;
cd_banco_w			titulo_receber.cd_banco%type;
cd_agencia_bancaria_w		titulo_receber.cd_agencia_bancaria%type;
cd_moeda_w			titulo_receber.cd_moeda%type;
dt_liquidacao_w			titulo_receber.dt_liquidacao%type;
vl_desc_previsto_w		titulo_receber.vl_desc_previsto%type;
vl_titulo_w			titulo_receber.vl_titulo%type;
vl_juros_w			double precision;
vl_multa_w			double precision;
qt_titulo_w			integer;

C01 CURSOR FOR
	SELECT	c.nr_titulo,
		d.cd_conta,
		d.ie_digito_conta
	from	titulo_receber			c,
		pls_mensalidade			a,
		pls_lote_mensalidade		b,
		pls_contrato_pagador_fin	d
	where	c.nr_seq_mensalidade	= a.nr_sequencia
	and	b.nr_sequencia		= a.nr_seq_lote
	and	a.nr_seq_pagador_fin	= d.nr_sequencia
	and	d.nr_seq_conta_banco	= nr_seq_conta_banco_w
	and	d.nr_seq_forma_cobranca	= 4
	and	trunc(b.dt_mesano_referencia,'Month') = trunc(clock_timestamp(),'Month')
	and	d.nr_seq_empresa = nr_seq_empresa_w
	and	((d.nr_seq_vinculo_empresa = nr_seq_vinculo_empresa_w) or (coalesce(nr_seq_vinculo_empresa_w::text, '') = ''))
	order by a.nr_seq_pagador;


BEGIN

select	nr_seq_conta_banco,
	nr_seq_empresa,
	nr_seq_vinculo_empresa
into STRICT	nr_seq_conta_banco_w,
	nr_seq_empresa_w,
	nr_seq_vinculo_empresa_w
from	cobranca_escritural
where	nr_sequencia = nr_seq_cobranca_p;

open C01;
loop
fetch C01 into
	nr_titulo_w,
	nr_conta_w,
	ie_digito_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(cd_banco),
		max(cd_agencia_bancaria),
		max(cd_moeda),
		max(dt_liquidacao),
		max(vl_desc_previsto),
		coalesce(obter_juros_multa_titulo(max(nr_titulo),clock_timestamp(),'R','J'),0),
		coalesce(obter_juros_multa_titulo(max(nr_titulo),clock_timestamp(),'R','M'),0),
		max(vl_titulo)
	into STRICT	cd_banco_w,
		cd_agencia_bancaria_w,
		cd_moeda_w,
		dt_liquidacao_w,
		vl_desc_previsto_w,
		vl_juros_w,
		vl_multa_w,
		vl_titulo_w
	from	titulo_receber
	where	nr_titulo = nr_titulo_w;

	select	count(1)
	into STRICT	qt_titulo_w
	from	titulo_receber_cobr
	where	nr_titulo = nr_titulo_w;

	if (qt_titulo_w = 0) then
		insert into titulo_receber_cobr(	nr_sequencia, nr_seq_cobranca, nr_titulo,
				vl_cobranca, dt_atualizacao, nm_usuario,
				cd_banco, cd_agencia_bancaria, nr_conta,
				cd_moeda, dt_liquidacao, vl_liquidacao,
				ie_digito_conta, cd_camara_compensacao, vl_desconto,
				vl_acrescimo, cd_ocorrencia, cd_instrucao,
				qt_dias_instrucao, nr_seq_ocorrencia_ret, dt_atualizacao_nrec,
				nm_usuario_nrec, vl_despesa_bancaria, vl_juros,
				vl_multa, vl_desc_previsto)
			values ( nextval('titulo_receber_cobr_seq'), nr_seq_cobranca_p, nr_titulo_w,
				vl_titulo_w, clock_timestamp(), nm_usuario_p,
				cd_banco_w, cd_agencia_bancaria_w, nr_conta_w,
				cd_moeda_w, dt_liquidacao_w, 0,
				ie_digito_conta_w, null, 0,
				null, null, null,
				null, null, clock_timestamp(),
				nm_usuario_p, 0, vl_juros_w,
				vl_multa_w, vl_desc_previsto_w);
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_titulos_desconto_folha ( nr_seq_cobranca_p bigint, nm_usuario_p text) FROM PUBLIC;
