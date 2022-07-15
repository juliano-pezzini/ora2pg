-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_regra_sae_item ( cd_perfil_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_prescricao_w		timestamp;
qt_registro_w		bigint;
nr_seq_proc_w		bigint;
nr_atendimento_w	 bigint;
ie_liberar_w		varchar(10);
nr_seq_sae_w		bigint;
nr_seq_erro_w		bigint;
nr_seq_modelo_w		bigint;
cd_setor_pac_w		bigint;
nr_seq_item_w		bigint;
qt_horas_vigencia_w smallint;
cd_pessoa_fisica_w varchar(10);
qt_regra_w smallint;

C01 CURSOR FOR 
	SELECT	NR_SEQ_ITEM, 
			qt_horas_vigencia 
	from	PE_SAE_MOD_ITEM a 
	where	nr_seq_modelo	= nr_seq_modelo_w 
	and	IE_OBRIGATORIO	= 'S' 
	and	coalesce(cd_setor_pac,cd_setor_pac_w)	= cd_setor_pac_w 
	and	not exists (	SELECT	1 
					from	PE_PRESCR_ITEM_RESULT x 
					where	x.nr_seq_item	= a.nr_seq_item 
					and	x.NR_SEQ_PRESCR	= nr_sequencia_p);

	 

BEGIN	 
 
delete	FROM pe_prescricao_erro 
where	nr_seq_prescr	= nr_sequencia_p 
and	(nr_seq_item IS NOT NULL AND nr_seq_item::text <> '');
begin 
select	nr_seq_modelo, 
	coalesce(cd_setor_atendimento,0), 
	cd_pessoa_fisica 
into STRICT	nr_seq_modelo_w, 
	cd_setor_pac_w, 
	cd_pessoa_fisica_w 
from	pe_prescricao 
where	nr_sequencia	= nr_sequencia_p;
exception 
	when others then 
	null;
end;
 
if (obter_se_consistir_regra_sae(2,cd_perfil_p)	<> 'X') then 
	ie_liberar_w	:= obter_se_consistir_regra_sae(2,cd_perfil_p);
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_item_w, 
		qt_horas_vigencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (coalesce(qt_horas_vigencia_w,0) > 0) and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '')then 
		 
			select Count(*) 
			into STRICT qt_regra_w 
			from pe_prescricao a 
			where cd_pessoa_fisica = cd_pessoa_fisica_w 
			and	 coalesce(a.dt_inativacao::text, '') = '' 
			and a.dt_atualizacao >= (clock_timestamp() - qt_horas_vigencia_w / 24) 
			and exists (	SELECT 1 
						from PE_PRESCR_ITEM_RESULT b 
						where b.nr_seq_prescr = a.nr_sequencia 
						and b.nr_seq_item = nr_seq_item_w);
						 
			if (qt_regra_w = 0 )	then 
				nr_seq_erro_w := gerar_erro_interv_sae(nr_sequencia_p, null, 2, ie_liberar_w, null, null, nm_usuario_p, nr_seq_erro_w, nr_seq_item_w);
			end if;
			 
		else 
			nr_seq_erro_w := gerar_erro_interv_sae(nr_sequencia_p, null, 2, ie_liberar_w, null, null, nm_usuario_p, nr_seq_erro_w, nr_seq_item_w);
		end if;
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
-- REVOKE ALL ON PROCEDURE consistir_regra_sae_item ( cd_perfil_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

