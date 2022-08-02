-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pp_inserir_anexo ( nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, ds_titulo_p pls_pagamento_anexo.ds_titulo%type, ds_arquivo_p pls_pagamento_anexo.ds_arquivo%type, nm_usuario_p usuario.nm_usuario%type, ie_funcao_pagamento_p text) AS $body$
DECLARE

					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ie_funcao_pagamento_p
1 - OPS - Pagamentos de Producao Medica (pagamento antigo)
2 - OSP - Pagamento de prestadores (pagamento novo)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
					
nr_seq_pagamento_w	pls_pagamento_anexo.nr_seq_pagamento%type;
ds_titulo_w		pls_pagamento_anexo.ds_titulo%type;


BEGIN
ds_titulo_w := coalesce(ds_titulo_p, ds_arquivo_p);

if (ie_funcao_pagamento_p = '2') and (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
		
	insert into pls_pp_prest_anexo(	nr_sequencia, nm_usuario, nm_usuario_nrec,
						dt_atualizacao, dt_atualizacao_nrec, nr_seq_prestador, 
						nr_seq_lote, ds_arquivo, ds_titulo)
				values (	nextval('pls_pp_prest_anexo_seq'), nm_usuario_p, nm_usuario_p,
						clock_timestamp(), clock_timestamp(), nr_seq_prestador_p,
						nr_seq_lote_p, ds_arquivo_p, ds_titulo_w);			
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_pagamento_w
	from	pls_pagamento_prestador
	where	nr_seq_lote		= nr_seq_lote_p
	and	nr_seq_prestador	= nr_seq_prestador_p;
	
	if (nr_seq_pagamento_w IS NOT NULL AND nr_seq_pagamento_w::text <> '') and (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then	
		
		insert into pls_pagamento_anexo(	nr_sequencia, dt_atualizacao, nm_usuario,
							dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_pagamento,
							ds_titulo, ds_arquivo, dt_liberacao)
					values (	nextval('pls_pagamento_anexo_seq'), clock_timestamp(), nm_usuario_p,
							clock_timestamp(), nm_usuario_p, nr_seq_pagamento_w,
							ds_titulo_w, ds_arquivo_p, null);		
	end if;				
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_inserir_anexo ( nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, ds_titulo_p pls_pagamento_anexo.ds_titulo%type, ds_arquivo_p pls_pagamento_anexo.ds_arquivo%type, nm_usuario_p usuario.nm_usuario%type, ie_funcao_pagamento_p text) FROM PUBLIC;

