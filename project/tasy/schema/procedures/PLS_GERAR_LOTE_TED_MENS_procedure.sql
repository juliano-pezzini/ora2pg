-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_ted_mens ( nr_seq_lote_mens_p bigint, nr_seq_regra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_gerar_w			varchar(1)	:= 'S';
nr_seq_mensalidade_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_lote_mens_ted_w		bigint;
nr_seq_pagador_w		pls_contrato_pagador.nr_sequencia%type;
cd_cep_w			pls_mensalidade_ted.cd_cep%type;
nm_pagador_w			pls_mensalidade_ted.nm_pagador%type;
cd_cartao_benef_pagador_w	pls_mensalidade_ted.cd_cartao_benef_pagador%type;
ds_destino_correspondencia_w	pls_mensalidade_ted.ds_destino_correspondencia%type;
nr_seq_destino_corresp_w	pls_destino_corresp.nr_sequencia%type;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_seq_pagador 
	from	pls_mensalidade	a 
	where	a.nr_seq_lote	= nr_seq_lote_mens_p;


BEGIN 
open C01;
loop 
fetch C01 into 
	nr_seq_mensalidade_w, 
	nr_seq_pagador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nr_seq_regra_w := pls_obter_regra_ted_incid_mens(nr_seq_mensalidade_w, nr_seq_regra_p, nr_seq_regra_w);
	 
	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_lote_mens_ted_w 
		from	pls_mensalidade_ted		b, 
			pls_lote_mensalidade_ted	a 
		where	b.nr_seq_lote_ted	= a.nr_sequencia 
		and	b.nr_seq_lote_mens	= nr_seq_lote_mens_p 
		and	a.nr_seq_regra		= nr_seq_regra_w;
		 
		if (coalesce(nr_seq_lote_mens_ted_w::text, '') = '') or (ie_gerar_w = 'S')then 
			select	nextval('pls_lote_mensalidade_ted_seq') 
			into STRICT	nr_seq_lote_mens_ted_w 
			;
			 
			insert into pls_lote_mensalidade_ted(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_regra, 
				dt_lote, 
				ie_geracao_lote, 
				dt_geracao_lote) 
			values (nr_seq_lote_mens_ted_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_regra_p, 
				clock_timestamp(), 
				'Mensalidade', 
				clock_timestamp());
			 
			ie_gerar_w	:= 'N';
		end if;
		 
		select	max(nr_seq_destino_corresp) 
		into STRICT	nr_seq_destino_corresp_w 
		from	pls_contrato_pagador 
		where	nr_sequencia	= nr_seq_pagador_w;
		 
		cd_cep_w			:= substr(pls_obter_compl_pagador(nr_seq_pagador_w,'CEP'),1,15);
		nm_pagador_w			:= substr(pls_obter_dados_pagador(nr_seq_pagador_w,'N'),1,255);
		cd_cartao_benef_pagador_w	:= substr(pls_obter_cart_seq_pagador(nr_seq_pagador_w,null),1,30);
		ds_destino_correspondencia_w	:= substr(pls_obter_destino_corresp_pag(nr_seq_pagador_w),1,255);
		 
		insert into pls_mensalidade_ted(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_lote_mens, 
			nr_seq_lote_ted, 
			nr_seq_mensalidade, 
			cd_cep, 
			nm_pagador, 
			cd_cartao_benef_pagador, 
			nr_seq_destino_corresp, 
			ds_destino_correspondencia) 
		values (nextval('pls_mensalidade_ted_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_lote_mens_p, 
			nr_seq_lote_mens_ted_w, 
			nr_seq_mensalidade_w, 
			cd_cep_w, 
			nm_pagador_w, 
			cd_cartao_benef_pagador_w, 
			nr_seq_destino_corresp_w, 
			ds_destino_correspondencia_w);
	end if;
	end;
end loop;
close C01;
 
if (nr_seq_lote_mens_ted_w IS NOT NULL AND nr_seq_lote_mens_ted_w::text <> '') then 
	CALL pls_ordernar_lote_ted(nr_seq_lote_mens_ted_w);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_ted_mens ( nr_seq_lote_mens_p bigint, nr_seq_regra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
