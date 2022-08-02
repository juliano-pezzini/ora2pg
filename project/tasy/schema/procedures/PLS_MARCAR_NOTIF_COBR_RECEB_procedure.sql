-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_marcar_notif_cobr_receb ( nr_seq_registro_cobr_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nm_contato_w			varchar(255);
ie_proprio_devedor_w		varchar(1);
nr_seq_notif_pagador_w		bigint;
nr_seq_vinculo_pag_w		bigint;
dt_registro_w			timestamp;
nr_seq_lote_notif_w		registro_cobranca.nr_seq_lote_notif%type;

C01 CURSOR FOR 
	SELECT	d.nr_sequencia 
	from	pls_notificacao_lote e, 
		pls_notificacao_pagador d, 
		pls_notificacao_item c, 
		cobranca b, 
		registro_cobr_item a 
	where	e.nr_sequencia		= d.nr_seq_lote 
	and	d.nr_sequencia		= c.nr_seq_notific_pagador 
	and	b.nr_titulo		= c.nr_titulo 
	and	b.nr_sequencia		= a.nr_seq_cobranca 
	and	coalesce(d.dt_recebimento_notif::text, '') = '' 
	and (coalesce(e.dt_limite_notif_tel::text, '') = '' or e.dt_limite_notif_tel > fim_dia(clock_timestamp())) 
	and	a.nr_seq_registro	= nr_seq_registro_cobr_p 
	and	((d.nr_seq_lote = nr_seq_lote_notif_w) or (coalesce(nr_seq_lote_notif_w::text, '') = ''));


BEGIN 
if (nr_seq_registro_cobr_p IS NOT NULL AND nr_seq_registro_cobr_p::text <> '') then 
	select	a.nm_contato, 
		a.nr_seq_vinculo_pag, 
		coalesce(a.ie_proprio_devedor,'N'), 
		a.dt_registro, 
		a.nr_seq_lote_notif 
	into STRICT	nm_contato_w, 
		nr_seq_vinculo_pag_w, 
		ie_proprio_devedor_w, 
		dt_registro_w, 
		nr_seq_lote_notif_w 
	from	registro_cobranca a 
	where	a.nr_sequencia	= nr_seq_registro_cobr_p;
	 
	if	((coalesce(nm_contato_w::text, '') = '') or (coalesce(nr_seq_vinculo_pag_w::text, '') = '')) and (ie_proprio_devedor_w = 'N') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(188967);
	end if;
	 
	if (ie_proprio_devedor_w = 'S') then 
		select	obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc) 
		into STRICT	nm_contato_w 
		from	registro_cobranca a 
		where	a.nr_sequencia	= nr_seq_registro_cobr_p;
		 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_vinculo_pag_w 
		from	pls_vinculo_pagador a 
		where	a.cd_estabelecimento	= cd_estabelecimento_p 
		and	a.ie_proprio_pagador	= 'S';
	end if;
	 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_notif_pagador_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		update	pls_notificacao_pagador 
		set	dt_recebimento_notif	= dt_registro_w, 
			nm_pessoa_notific	= nm_contato_w, 
			nr_seq_vinculo_pagador	= nr_seq_vinculo_pag_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp(), 
			ie_status_ant  = ie_status, 
			ie_status		= 'R', 
			nr_seq_registro_cobr	= nr_seq_registro_cobr_p 
		where	nr_sequencia		= nr_seq_notif_pagador_w;
			 
		CALL pls_registrar_receb_notif(nr_seq_notif_pagador_w, 
				nm_contato_w, 
				dt_registro_w, 
				'L', 
				nr_seq_registro_cobr_p);
		end;
	end loop;
	close C01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_marcar_notif_cobr_receb ( nr_seq_registro_cobr_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

