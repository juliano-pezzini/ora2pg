-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_parcela_neg_cr ( nr_seq_parcela_p bigint, nm_usuario_p text, nm_usuario_lib_p text, ie_acao_p text, qt_lib_parc_p bigint) AS $body$
DECLARE

					 
/* 
ie_acao_p 
'L' - Liberar 
'D' - Desfazer liberação 
*/
 
 
nr_seq_parcela_anterior_w	bigint;
nr_seq_parcela_seguinte_w	bigint;
nr_seq_negociacao_w		bigint;
nr_parcela_w			bigint;
dt_liberacao_w			timestamp;
cd_estabelecimento_w		smallint;
qt_parcela_w			bigint;
ie_forma_pagto_w		varchar(2);			
qt_max_reg_w			bigint;
nm_usuario_w			varchar(15);
qt_usuario_parc_w		bigint;


BEGIN 
 
if (nr_seq_parcela_p IS NOT NULL AND nr_seq_parcela_p::text <> '') then 
	if (ie_acao_p = 'L') then 
		select	max(a.nr_seq_negociacao), 
			max(a.nr_parcela) 
		into STRICT	nr_seq_negociacao_w, 
			nr_parcela_w 
		from	negociacao_cr_parcela b, 
			negociacao_cr_parcela a 
		where	a.nr_seq_negociacao 	= b.nr_seq_negociacao 
		and	b.nr_sequencia		= nr_seq_parcela_p 
		and	a.nr_parcela		< b.nr_parcela;
		 
		if (nr_parcela_w IS NOT NULL AND nr_parcela_w::text <> '') then 
			select	a.dt_liberacao 
			into STRICT	dt_liberacao_w 
			from	negociacao_cr_parcela a 
			where	a.nr_seq_negociacao	= nr_seq_negociacao_w 
			and	a.nr_parcela		= nr_parcela_w;
			 
			if (coalesce(dt_liberacao_w::text, '') = '') then 
				--A parcela #@nr_parcela_w#@ precisa ser liberada primeiro! 
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(219841,'nr_parcela='||nr_parcela_w);
			end if;
			 
			select	max(nm_usuario_lib) 
			into STRICT	nm_usuario_w 
			from	negociacao_cr_parcela_lib 
			where 	nm_usuario_lib = nm_usuario_lib_p 
			and	nr_seq_parcela	= nr_seq_parcela_p;
			 
			if (nm_usuario_w IS NOT NULL AND nm_usuario_w::text <> '') then 
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(219842,'nr_parcela='||(nr_parcela_w + 1)||';nm_usuario='||nm_usuario_w);			
			else 
				insert into negociacao_cr_parcela_lib(dt_atualizacao, 
					nm_usuario, 
					nm_usuario_lib, 
					nr_seq_parcela, 
					nr_sequencia) 
				values (clock_timestamp(), 
					nm_usuario_p, 
					nm_usuario_lib_p, 
					nr_seq_parcela_p, 
					nextval('negociacao_cr_parcela_lib_seq'));
			end if;	
		end if;
		 
		select	count(*) 
		into STRICT	qt_usuario_parc_w 
		from	negociacao_cr_parcela_lib 
		where	nr_seq_parcela = nr_seq_parcela_p;
		 
		if (qt_usuario_parc_w >= qt_lib_parc_p) then 
			update	negociacao_cr_parcela 
			set	dt_liberacao 	= clock_timestamp(), 
				nm_usuario_lib	= nm_usuario_lib_p, 
				ie_tipo_liberacao = 'M', 
				nm_usuario	= nm_usuario_p, 
				dt_atualizacao	= clock_timestamp() 
			where	nr_sequencia	= nr_seq_parcela_p;
		 
			select	max(a.cd_estabelecimento) 
			into STRICT	cd_estabelecimento_w 
			from	negociacao_cr a 
			where	a.nr_sequencia	= nr_seq_negociacao_w;
			 
			select	max(qt_reg) 
			into STRICT	qt_max_reg_w 
			from (SELECT	ie_forma_pagto, 
					count(*) qt_reg 
				from	negociacao_cr_parcela a 
				where	a.nr_seq_negociacao = nr_seq_negociacao_w 
				and	(a.ie_forma_pagto IS NOT NULL AND a.ie_forma_pagto::text <> '') 
				group by 
					ie_forma_pagto) alias3;
					 
			if (qt_max_reg_w > 0) then 
				select	max(a.ie_forma_pagto), 
					count(*) qt_reg 
				into STRICT	ie_forma_pagto_w, 
					qt_max_reg_w 
				from	negociacao_cr_parcela a 
				where	a.nr_seq_negociacao	= nr_seq_negociacao_w 
				and	(a.ie_forma_pagto IS NOT NULL AND a.ie_forma_pagto::text <> '') 
				group by 
					a.ie_forma_pagto 
				having	count(*) = qt_max_reg_w;
			end if;
			 
			qt_parcela_w	:= nr_parcela_w + 1;
			 
			/* Recalcular negociacao */
 
			qt_parcela_w := gerar_simulacao_neg_cr(nr_seq_negociacao_w, nm_usuario_p, ie_forma_pagto_w, qt_parcela_w, cd_estabelecimento_w, null, null);
		end if;
		 
	elsif (ie_acao_p = 'D') then 
		select	min(proxima.nr_seq_negociacao), 
			min(proxima.nr_parcela) 
		into STRICT	nr_seq_negociacao_w, 
			nr_parcela_w 
		from	negociacao_cr_parcela selecionada, 
			negociacao_cr_parcela proxima 
		where	selecionada.nr_seq_negociacao	= proxima.nr_seq_negociacao 
		and	selecionada.nr_sequencia	= nr_seq_parcela_p 
		and	proxima.nr_parcela		> selecionada.nr_parcela;
		 
		if (nr_parcela_w IS NOT NULL AND nr_parcela_w::text <> '') then 
			select	a.dt_liberacao 
			into STRICT	dt_liberacao_w 
			from	negociacao_cr_parcela a 
			where	a.nr_seq_negociacao	= nr_seq_negociacao_w 
			and	a.nr_parcela		= nr_parcela_w;
			 
			if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then 
				--É necessário desfazer primeiro a liberação da parcela #@nr_parcela_w#@ primeiro! 
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(219840,'nr_parcela='||nr_parcela_w);
			end if;
		end if;
		 
		delete from negociacao_cr_parcela_lib 
		where	nr_seq_parcela = nr_seq_parcela_p;
	 
		update	negociacao_cr_parcela 
		set	dt_liberacao 	 = NULL, 
			nm_usuario_lib	 = NULL, 
			ie_tipo_liberacao = 'A', 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia	= nr_seq_parcela_p;
		 
		select	max(a.cd_estabelecimento) 
		into STRICT	cd_estabelecimento_w 
		from	negociacao_cr a 
		where	a.nr_sequencia	= nr_seq_negociacao_w;
		 
		select	max(qt_reg) 
		into STRICT	qt_max_reg_w 
		from (SELECT	ie_forma_pagto, 
				count(*) qt_reg 
			from	negociacao_cr_parcela a 
			where	a.nr_seq_negociacao = nr_seq_negociacao_w 
			and	(a.ie_forma_pagto IS NOT NULL AND a.ie_forma_pagto::text <> '') 
			group by 
				ie_forma_pagto) alias3;
				 
		if (qt_max_reg_w > 0) then 
			select	max(a.ie_forma_pagto), 
				count(*) qt_reg 
			into STRICT	ie_forma_pagto_w, 
				qt_max_reg_w 
			from	negociacao_cr_parcela a 
			where	a.nr_seq_negociacao	= nr_seq_negociacao_w 
			and	(a.ie_forma_pagto IS NOT NULL AND a.ie_forma_pagto::text <> '') 
			group by 
				a.ie_forma_pagto 
			having	count(*) = qt_max_reg_w;
		end if;
		 
		qt_parcela_w := nr_parcela_w -2;
		 
		/* Recalcular negociacao */
 
		qt_parcela_w := gerar_simulacao_neg_cr(nr_seq_negociacao_w, nm_usuario_p, ie_forma_pagto_w, qt_parcela_w, cd_estabelecimento_w, null, null);
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_parcela_neg_cr ( nr_seq_parcela_p bigint, nm_usuario_p text, nm_usuario_lib_p text, ie_acao_p text, qt_lib_parc_p bigint) FROM PUBLIC;
