-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_solic_rescisao_fin_pck.gerar_negociacao (nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_negociacao_w	negociacao_cr.nr_sequencia%type;
qt_tit_w		bigint;
cd_pessoa_fisica_w	pls_contrato_pagador.cd_pessoa_fisica%type;
cd_cgc_w		pls_contrato_pagador.cd_cgc%type;

C01 CURSOR FOR
	SELECT	nr_titulo
	from	titulo_receber
	where	ie_situacao = '1'
	and	nr_seq_pagador = nr_seq_pagador_p
	order by
		nr_titulo;

BEGIN

select	count(1)
into STRICT	qt_tit_w
from	titulo_receber
where	ie_situacao = '1'
and	nr_seq_pagador = nr_seq_pagador_p;

if (qt_tit_w < 2) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1041066);
end if;

select	max(cd_cgc),
	max(cd_pessoa_fisica)
into STRICT	cd_cgc_w,
	cd_pessoa_fisica_w
from	pls_contrato_pagador
where	nr_sequencia = nr_seq_pagador_p;

select	nextval('negociacao_cr_seq')
into STRICT	nr_seq_negociacao_w
;

insert into negociacao_cr(cd_estabelecimento, dt_atualizacao, dt_atualizacao_nrec,
	nm_usuario, nm_usuario_nrec, dt_negociacao,
	ie_status, nr_sequencia, vl_desconto,
	vl_juros, vl_multa, vl_negociado,
	nr_seq_solic_resc_fin, nr_seq_pagador, cd_cgc,
	cd_pessoa_fisica)
values (cd_estabelecimento_p, clock_timestamp(), clock_timestamp(),
	nm_usuario_p, nm_usuario_p, clock_timestamp(),
	'AS', nr_seq_negociacao_w, 0,
	0, 0, 0,
	nr_seq_solic_resc_fin_p, nr_seq_pagador_p, cd_cgc_w,
	cd_pessoa_fisica_w);

for r_c01_w in c01 loop
	begin
	CALL inserir_tit_rec_negociado(nr_seq_negociacao_w, r_c01_w.nr_titulo, nm_usuario_p);
	end;
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_solic_rescisao_fin_pck.gerar_negociacao (nr_seq_solic_resc_fin_p pls_solic_rescisao_fin.nr_sequencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
