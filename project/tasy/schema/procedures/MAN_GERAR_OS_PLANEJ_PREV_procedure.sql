-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_os_planej_prev ( nr_seq_planej_prev_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_planej_w			bigint;
nr_seq_equip_w			bigint;
nr_seq_ordem_serv_w		bigint;
nr_seq_ult_os_prev_w		bigint;
ie_equip_regra_excl_w		varchar(1) := 'N';
qt_reg_w			bigint;
			
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		b.nr_sequencia 
	from	man_localizacao d, 
		man_freq_planej c, 
		man_equipamento b, 
		man_planej_prev a	 
	where	a.nr_seq_tipo_equip	= b.nr_seq_tipo_equip 
	and	a.nr_seq_frequencia	= c.nr_sequencia 
	and	b.nr_seq_local		= d.nr_sequencia 
	and	coalesce(a.ie_situacao,'A')	= 'A' 
	and	coalesce(b.ie_situacao,'A')	= 'A' 
	and	coalesce(a.ie_contador,'N')	= 'N' 
	and	d.cd_setor		= coalesce(a.cd_setor_atendimento,d.cd_setor) 
	and	b.nr_sequencia		= coalesce(a.nr_seq_equip,b.nr_sequencia) 
	and	coalesce(b.nr_seq_marca,0)	= coalesce(a.nr_seq_marca,coalesce(b.nr_seq_marca,0)) 
	and	coalesce(b.nr_seq_modelo,0)	= coalesce(a.nr_seq_modelo,coalesce(b.nr_seq_modelo,0)) 
	and (coalesce(a.ie_impacto,'T')	= 'T' or a.ie_impacto = coalesce(b.cd_impacto,a.ie_impacto)) 
	and	coalesce(b.cd_estab_contabil,0)	= coalesce(a.cd_estabelecimento,coalesce(b.cd_estab_contabil,0)) 
	and	a.nr_sequencia		= nr_seq_planej_prev_p 
	and not exists (	SELECT	1 
			from	man_planej_prev x 
			where	x.nr_seq_equip = b.nr_sequencia 
			and	coalesce(a.nr_seq_equip::text, '') = '');
			

BEGIN 
 
 
if (coalesce(nr_seq_planej_prev_p,0) > 0) then 
	begin 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_planej_w, 
		nr_seq_equip_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
 
		select	count(nr_sequencia) 
		into STRICT	qt_reg_w 
		from	man_planej_prev_equip_excl 
		where	nr_seq_equipamento = nr_seq_equip_w 
		and	nr_seq_planej_prev = nr_seq_planej_w;
		 
		ie_equip_regra_excl_w := 'N';
		if (qt_reg_w > 0) then 
			ie_equip_regra_excl_w := 'S';
		end if;
		 
		if (ie_equip_regra_excl_w = 'N') then 
		 
			nr_seq_ordem_serv_w := man_gerar_os_planejada(nr_seq_equip_w, nr_seq_planej_w, clock_timestamp(), nm_usuario_p, nr_seq_ordem_serv_w, 'N');
			 
			select	coalesce(max(nr_sequencia),0) 
			into STRICT	nr_seq_ult_os_prev_w 
			from 	man_ordem_servico 
			where 	ie_tipo_ordem 			= 2 
			and	nr_seq_equipamento 		= nr_seq_equip_w 
			and 	coalesce(nr_seq_planej,nr_seq_planej_w)	= nr_seq_planej_w;
			 
			insert into man_planej_prev_log( 
					nr_sequencia, 
					nr_seq_planej, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_equipamento, 
					ie_status, 
					nr_seq_ultima_prev, 
					nr_seq_ordem_servico) 
				values (	nextval('man_planej_prev_log_seq'), 
					nr_seq_planej_w, 
					clock_timestamp(), 
					'Tasy', 
					clock_timestamp(), 
					'Tasy', 
					nr_seq_equip_w, 
					'G', 
					nr_seq_ult_os_prev_w, 
					nr_seq_ordem_serv_w);
		end if;
		end;
	end loop;
	close C01;
	 
	commit;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_os_planej_prev ( nr_seq_planej_prev_p bigint, nm_usuario_p text) FROM PUBLIC;

