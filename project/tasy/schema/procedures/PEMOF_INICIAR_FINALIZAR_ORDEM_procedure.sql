-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pemof_iniciar_finalizar_ordem ( nr_seq_ordem_p bigint, nr_seq_area_prep_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE

				 
nr_seq_processo_w	bigint;
ie_conferencia_w	adep_area_prep.ie_conferencia%type;
ie_dispensacao_w	adep_area_prep.ie_dispensacao%type;
			

BEGIN 
if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') and (ie_acao_p IS NOT NULL AND ie_acao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	 
	if (ie_acao_p = 'I') then 
		update	adep_processo_frac 
		set	dt_preparo		= clock_timestamp(), 
			nm_usuario_preparo	= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p 
		where	nr_sequencia		= nr_seq_ordem_p;
	elsif (ie_acao_p = 'F') then 
		update	adep_processo_frac 
		set	dt_fim_preparo		= clock_timestamp(), 
			nm_usuario_fim_preparo	= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp(),			 
			nm_usuario		= nm_usuario_p 
		where	nr_sequencia		= nr_seq_ordem_p;	
		 
		if (coalesce(nr_seq_area_prep_p,0) > 0) then 
			select	coalesce(max(nr_seq_processo),0) 
			into STRICT	nr_seq_processo_w 
			from	adep_processo_frac 
			where	nr_sequencia = nr_seq_ordem_p;
			 
			update	adep_processo_area a 
			set	a.dt_preparo 		= clock_timestamp(), 
				a.nm_usuario_preparo	= nm_usuario_p 
			where	a.nr_seq_processo	= nr_seq_processo_w 
			and	a.nr_seq_area_prep	= nr_seq_area_prep_p 
			and	not exists ( 
					SELECT	1 
					from	adep_processo_frac x, 
						prescr_mat_hor y 
					where	y.nr_seq_etiqueta	= x.nr_sequencia 
					and	y.nr_seq_processo	= x.nr_seq_processo 
					and	x.nr_seq_processo	= nr_seq_processo_w 
					and	y.nr_seq_area_prep	= nr_seq_area_prep_p 
					and	coalesce(x.dt_fim_preparo::text, '') = '' 
					and	coalesce(y.dt_suspensao::text, '') = '' 
					and	x.nr_sequencia		<> nr_seq_ordem_p);
			 
			/* 
			update	adep_processo a 
			set	a.dt_preparo		= sysdate, 
				a.nm_usuario_preparo	= nm_usuario_p 
			where	a.nr_sequencia		= nr_seq_processo_w 
			and	not exists ( 
					select	1 
					from	adep_processo_area x 
					where	x.nr_seq_processo	= nr_seq_processo_w 
					and	x.nr_seq_area_prep	<> nr_seq_area_prep_p 
					and	x.dt_preparo		is null) 
			and	not exists ( 
					select	1 
					from	prescr_mat_hor x 
					where	x.nr_seq_processo	= nr_seq_processo_w 
					and	x.nr_seq_area_prep	<> nr_seq_area_prep_p 
					and	not exists ( 
							select	1 
							from	adep_processo_area z 
							where	z.nr_seq_processo	= x.nr_seq_processo 
							and	z.nr_seq_area_prep	= x.nr_seq_area_prep)); 
			*/
 
			 
			CALL atualiza_status_processo_adep(nr_seq_processo_w, nr_seq_area_prep_p, 'G', 'P', clock_timestamp(), nm_usuario_p);
			 
			select	max(coalesce(ie_conferencia,'S')), 
					max(coalesce(ie_dispensacao,'S')) 
			into STRICT	ie_conferencia_w, 
					ie_dispensacao_w 
			from	adep_area_prep 
			where	nr_sequencia	= nr_seq_area_prep_p;
				 
			if (ie_conferencia_w = 'N') and (ie_dispensacao_w = 'N') then 
				CALL atualiza_status_processo_adep(nr_seq_processo_w, nr_seq_area_prep_p, 'G', 'E', clock_timestamp(), nm_usuario_p);								
			end if;
			 
		end if;
	elsif (ie_acao_p = 'C') then 
		update	adep_processo_frac 
		set	dt_cancelamento		= clock_timestamp(), 
			nm_usuario_cancelamento	= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp(),			 
			nm_usuario		= nm_usuario_p 
		where	nr_sequencia		= nr_seq_ordem_p;
	elsif (ie_acao_p = 'D') then 
		update	adep_processo_frac 
		set	dt_preparo		 = NULL, 
			nm_usuario_preparo	 = NULL, 
			ie_status_frac		= 'G',	 
			dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p 
		where	nr_sequencia		= nr_seq_ordem_p;
	end if;	
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pemof_iniciar_finalizar_ordem ( nr_seq_ordem_p bigint, nr_seq_area_prep_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

