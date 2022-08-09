-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_susp_mens_pagador_notif ( nr_seq_pagador_p bigint, dt_inicio_susp_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_regra_w			bigint;
nr_seq_motivo_susp_cobr_w	bigint;
nr_seq_lote_w			bigint;
nr_seq_contrato_w		bigint;
ie_suspensao_mens_w		varchar(1);
ds_nr_processo_w		varchar(255);


BEGIN 
select	nr_seq_lote 
into STRICT	nr_seq_lote_w 
from	pls_notificacao_pagador 
where	nr_seq_pagador = nr_seq_pagador_p;
 
select	nr_seq_regra 
into STRICT	nr_seq_regra_w 
from	pls_notificacao_lote 
where	nr_sequencia = nr_seq_lote_w;
 
select	max(nr_seq_motivo_susp_cobr) 
into STRICT	nr_seq_motivo_susp_cobr_w 
from	pls_notificacao_regra 
where	nr_sequencia = nr_seq_regra_w;
 
if (coalesce(nr_seq_motivo_susp_cobr_w::text, '') = '') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(264797);
end if;
 
begin 
ie_suspensao_mens_w 	:= pls_obter_processo_jud_notif(nr_seq_lote_w, nr_seq_pagador_p, null, 'PSA');
exception 
when others then 
	ie_suspensao_mens_w := 'N';
end;
 
if (ie_suspensao_mens_w = 'N') then 
	ds_nr_processo_w := pls_obter_processo_jud_notif(nr_seq_lote_w, nr_seq_pagador_p, null, 'NRP');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(337228,'NR_PROCESSO_P=' ||ds_nr_processo_w);
end if;	
 
if (nr_seq_pagador_p IS NOT NULL AND nr_seq_pagador_p::text <> '') then 
	select 	nr_seq_contrato 
	into STRICT 	nr_seq_contrato_w 
	from 	pls_contrato_pagador 
	where 	nr_sequencia = nr_seq_pagador_p;
 
	if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then 
		insert into	pls_contrato_susp_mens( 
			nr_sequencia, 
			nr_seq_contrato, 
			nr_seq_pagador, 
			nr_seq_motivo_suspensao, 
			dt_inicio_suspensao, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			dt_fim_suspensao, 
			dt_liberacao, 
			nm_usuario_liberacao, 
			ds_observacao, 
			nr_seq_notificacao) 
		values (	nextval('pls_contrato_susp_mens_seq'), 
			nr_seq_contrato_w, 
			nr_seq_pagador_p, 
			nr_seq_motivo_susp_cobr_w, 
			dt_inicio_susp_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			null, 
			clock_timestamp(), 
			nm_usuario_p, 
			'Suspensão gerada a partir do contrato '||nr_seq_contrato_w||' do lote de notificação '||nr_seq_lote_w||'.', 
			nr_seq_lote_w);	
	end if;
end if;
 
 
update	pls_notificacao_lote 
set	dt_susp_mens 		= clock_timestamp(), 
	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p 
where	nr_sequencia 		= nr_seq_lote_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_susp_mens_pagador_notif ( nr_seq_pagador_p bigint, dt_inicio_susp_p timestamp, nm_usuario_p text) FROM PUBLIC;
