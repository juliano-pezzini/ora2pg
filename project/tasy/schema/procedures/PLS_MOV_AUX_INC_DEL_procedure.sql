-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_mov_aux_inc_del ( nr_seq_registro_p bigint, ie_tipo_registro_p text, nr_seq_movimento_p bigint, ie_tipo_acao_p text, nr_linha_p bigint) AS $body$
DECLARE


qt_registros_w 		bigint;
nr_linha_w		w_ctb_livro_aux_event_liq.nr_linha%type;
nr_sequencia_w		w_ctb_aux_contra_emit.nr_sequencia%type;
				

BEGIN

CALL wheb_usuario_pck.set_ie_executar_trigger('N');

if (ie_tipo_acao_p = 'I') then
	begin
	
	update	ctb_livro_auxiliar
	set	qt_registros	= qt_registros + 1
	where	nr_sequencia	= nr_seq_registro_p;
	
	commit;	
	
	if	ie_tipo_registro_p in ('8000','8001','8002','8003','8004','8005','8006','8011','8012','8013','8020','8022','8025','8029') then
		begin
		
		select 	count(*)
		into STRICT	qt_registros_w
		from	w_ctb_livro_aux_event_liq
		where	nr_seq_reg_auxiliar = nr_seq_registro_p;
		
		update	w_ctb_livro_aux_event_liq
		set	nr_linha	= qt_registros_w
		where	nr_sequencia	= nr_seq_movimento_p
		and	nr_seq_reg_auxiliar = nr_seq_registro_p;
			
		commit;
			
		end;
		
	elsif	ie_tipo_registro_p in ('8007','8008','8009','8010','8014','8016','8018','8024') then
		begin
		
		select 	count(*)
		into STRICT	qt_registros_w
		from	w_ctb_aux_contra_emit
		where	nr_seq_reg_auxiliar = nr_seq_registro_p;
		
		update	w_ctb_aux_contra_emit
		set	nr_linha	= qt_registros_w
		where	nr_sequencia	= nr_seq_movimento_p
		and	nr_seq_reg_auxiliar = nr_seq_registro_p;
			
		commit;
			
		end;
	end if;
		
	end;
end if;

if (ie_tipo_acao_p = 'D') then
	begin
	
		update	ctb_livro_auxiliar
		set	qt_registros	= qt_registros - 1
		where	nr_sequencia	= nr_seq_registro_p;
		commit;	
		
		if	ie_tipo_registro_p in ('8000','8001','8002','8003','8004','8005','8006','8011','8012','8013','8020','8022','8025','8029') then
		
			select	max(nr_linha)
			into STRICT	nr_linha_w
			from	w_ctb_livro_aux_event_liq
			where	nr_sequencia		= nr_seq_movimento_p
			and	nr_seq_reg_auxiliar 	= nr_seq_registro_p;
		
			delete
			from	w_ctb_livro_aux_event_liq
			where	nr_sequencia		= nr_seq_movimento_p
			and	nr_seq_reg_auxiliar 	= nr_seq_registro_p;
		
			update	w_ctb_livro_aux_event_liq
			set	nr_linha		= nr_linha - 1
			where	nr_linha		> nr_linha_w
			and	nr_seq_reg_auxiliar 	= nr_seq_registro_p;
		
			/*select 	max(nr_sequencia)
			into	nr_sequencia_w
			from	w_ctb_livro_aux_event_liq
			where	nr_seq_reg_auxiliar = nr_seq_registro_p;
									
			update	w_ctb_livro_aux_event_liq
			set	nr_linha	= nr_linha_p
			where	nr_sequencia	= nr_sequencia_w;*/
		
		elsif	ie_tipo_registro_p in ('8007','8008','8009','8010','8014','8016','8018','8024') then
			begin
			
			select	max(nr_linha)
			into STRICT	nr_linha_w
			from	w_ctb_aux_contra_emit
			where	nr_sequencia		= nr_seq_movimento_p
			and	nr_seq_reg_auxiliar 	= nr_seq_registro_p;
		
			delete
			from	w_ctb_aux_contra_emit
			where	nr_sequencia		= nr_seq_movimento_p
			and	nr_seq_reg_auxiliar 	= nr_seq_registro_p;
		
			update	w_ctb_aux_contra_emit
			set	nr_linha		= nr_linha - 1
			where	nr_linha		> nr_linha_w
			and	nr_seq_reg_auxiliar 	= nr_seq_registro_p;
			
			/*select 	max(nr_sequencia)
			into	nr_sequencia_w
			from	w_ctb_aux_contra_emit
			where	nr_seq_reg_auxiliar = nr_seq_registro_p;
			
			delete
			from	w_ctb_aux_contra_emit
			where	nr_sequencia	= nr_seq_movimento_p
			and	nr_seq_reg_auxiliar = nr_seq_registro_p;
			
			update	w_ctb_aux_contra_emit
			set	nr_linha	= nr_linha_p
			where	nr_sequencia	= nr_sequencia_w;*/
			commit;
			
			end;
		end if;
	
	end;
end if;
	
CALL wheb_usuario_pck.set_ie_executar_trigger('S');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_aux_inc_del ( nr_seq_registro_p bigint, ie_tipo_registro_p text, nr_seq_movimento_p bigint, ie_tipo_acao_p text, nr_linha_p bigint) FROM PUBLIC;

