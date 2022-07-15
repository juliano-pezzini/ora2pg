-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_perda (nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w		bigint;		
ie_proc_mat_w			smallint;
nr_sequencia_w			bigint;
nr_seq_partic_w			bigint;
nr_seq_proc_w			bigint;
vl_item_w			double precision;
vl_medico_w			double precision;
vl_anestesista_w		double precision;
vl_filme_w			double precision;
vl_auxiliares_w			double precision;
vl_custo_operacional_w		double precision;
cd_estabelecimento_w		bigint;
ie_liquidar_titulo_w		varchar(1);
nr_seq_trans_fin_perda_w	bigint;
cd_tipo_receb_perda_w		integer;
nr_titulo_w			bigint;
vl_saldo_titulo_w		double precision;
ds_nls_territory_w		varchar(64);

C01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	conta_paciente 
	where	nr_seq_protocolo = nr_seq_protocolo_p	 
	order by nr_interno_conta;
	
C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		ie_proc_mat, 
		vl_item, 
		vl_medico, 
		vl_anestesista, 
		vl_filme, 
		vl_auxiliares, 
		vl_custo_operacional 
	from	conta_paciente_valor_v 
	where	nr_interno_conta = nr_interno_conta_w 
	order by ie_proc_mat, 
		nr_sequencia;
		
C03 CURSOR FOR 
	SELECT	nr_seq_partic 
	from	procedimento_participante 
	where	nr_sequencia = nr_sequencia_w 
	order by 1;

c04 CURSOR FOR 
SELECT	a.nr_titulo, 
	a.vl_saldo_titulo 
from	titulo_receber a 
where	a.nr_seq_protocolo	= nr_seq_protocolo_p 

union
 
SELECT	b.nr_titulo, 
	b.vl_saldo_titulo 
from	titulo_receber b, 
	conta_paciente a 
where	a.nr_interno_conta	= b.nr_interno_conta 
and	a.nr_seq_protocolo	= nr_seq_protocolo_p;
		

BEGIN 
 
select	max(a.cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	protocolo_convenio a 
where	a.nr_seq_protocolo	= nr_seq_protocolo_p;
 
ie_liquidar_titulo_w := obter_param_usuario(85, 180, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_liquidar_titulo_w);
 
select	a.cd_tipo_receb_perda, 
	a.nr_seq_trans_fin_perda 
into STRICT	cd_tipo_receb_perda_w, 
	nr_seq_trans_fin_perda_w 
from	parametro_contas_receber a 
where	a.cd_estabelecimento	= cd_estabelecimento_w;
 
begin 
select	substr(value,1,64) 
into STRICT	ds_nls_territory_w 
from	v$nls_parameters 
where	parameter = 'NLS_TERRITORY';
exception 
when others then 
	ds_nls_territory_w := null;
end;
 
open C01;
loop 
fetch C01 into	 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_sequencia_w, 
		ie_proc_mat_w, 
		vl_item_w, 
		vl_medico_w, 
		vl_anestesista_w, 
		vl_filme_w, 
		vl_auxiliares_w, 
		vl_custo_operacional_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		if (ie_proc_mat_w = 1) then 
		 
			update	procedimento_paciente 
			set	ie_valor_informado 	= 'S', 
				vl_procedimento		= 0, 
				vl_medico		= 0, 
				vl_anestesista		= 0,				 
				vl_materiais		= 0, 
				vl_auxiliares		= 0, 
				vl_custo_operacional	= 0, 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp()				 
			where 	nr_sequencia = nr_sequencia_w;
 
			if	((2 = philips_param_pck.get_cd_pais) or (upper(ds_nls_territory_w) = 'MEXICO')) then -- 2 = México 
				delete from propaci_imposto 
				where nr_seq_propaci = nr_sequencia_w;
			end if;
			 
			open C03;
			loop 
			fetch C03 into	 
				nr_seq_partic_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
				 
				update	procedimento_participante 
				set 	ie_valor_informado = 'S', 
					nm_usuario 	= nm_usuario_p, 
					dt_atualizacao = clock_timestamp(), 
					VL_PARTICIPANTE = 0, 
					VL_CONTA    	= 0 
				where	nr_sequencia	= nr_sequencia_w 
				and 	nr_seq_partic	= nr_seq_partic_w;
				 
				end;
			end loop;
			close C03;
			 
			delete	 
			from 	proc_paciente_valor 
			where	nr_seq_procedimento	= nr_sequencia_w 
			and	ie_tipo_valor		= 4;
 
			select	coalesce(max(nr_sequencia),0) + 1 
			into STRICT 	nr_seq_proc_w 
			from	proc_paciente_valor 
			where	nr_seq_procedimento 	= nr_sequencia_w;
 
			insert into proc_paciente_valor(nr_seq_procedimento, 
				nr_sequencia, 
				ie_tipo_valor, 
				dt_atualizacao, 
				nm_usuario, 
				vl_procedimento, 
				vl_medico, 
				vl_anestesista, 
				vl_materiais, 
				vl_auxiliares, 
				vl_custo_operacional) 
			values (nr_sequencia_w, 
				nr_seq_proc_w, 
				4, 
				clock_timestamp(), 
				nm_usuario_p, 
				vl_item_w, 
				vl_medico_w, 
				vl_anestesista_w, 
				vl_filme_w, 
				vl_auxiliares_w, 
				vl_custo_operacional_w);
			 
		 
		elsif (ie_proc_mat_w = 2) then 
		 
			update	material_atend_paciente 
			set	ie_valor_informado 	= 'S', 
				vl_tabela_original	= vl_material, 
				vl_material		= 0, 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp()				 
			where 	nr_sequencia = nr_sequencia_w;
			 
			if	((2 = philips_param_pck.get_cd_pais) or (upper(ds_nls_territory_w) = 'MEXICO')) then -- 2 = México 
				delete from matpaci_imposto 
				where nr_seq_matpaci = nr_sequencia_w;
			end if;					
		end if;
		 
		end;
	end loop;
	close C02;
	 
	commit; -- Precisa ter o commit para a atualização do resumo da conta 
	
	update	conta_paciente 
	set	vl_conta = 0 
	where 	nr_interno_conta = nr_interno_conta_w;
	 
	CALL Atualizar_resumo_conta(nr_interno_conta_w,2);
	 
	end;
end loop;
close C01;
 
if (ie_liquidar_titulo_w = 'S') and (cd_tipo_receb_perda_w IS NOT NULL AND cd_tipo_receb_perda_w::text <> '') then 
 
	open	c04;
	loop 
	fetch	c04 into 
		nr_titulo_w, 
		vl_saldo_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
 
		CALL Baixa_Titulo_Receber(cd_estabelecimento_w, 
					cd_tipo_receb_perda_w, 
					nr_titulo_w, 
					nr_seq_trans_fin_perda_w, 
					vl_saldo_titulo_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					0, 
					null, 
					null, 
					0, 
					0);
 
		CALL Atualizar_Saldo_Tit_Rec(nr_titulo_w, nm_usuario_p);
 
	end	loop;
	close	c04;
 
end if;
 
update	protocolo_convenio 
set	ie_status_protocolo	= '4', 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp() 
where	nr_seq_protocolo	= nr_seq_protocolo_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_perda (nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

