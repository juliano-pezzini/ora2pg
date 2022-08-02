-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_recalcular_fat_analise ( nr_seq_analise_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_tipo_despesa_w		varchar(10);
ie_tipo_item_w			varchar(2);
ie_atualiza_apresentado_w	varchar(1);
vl_unitario_apres_w		double precision;
vl_total_apres_w		double precision;
vl_calculado_w			double precision;
qt_item_w			double precision;
nr_seq_conta_w			bigint;
qt_apresentado_w		bigint;
qt_liberado_w			bigint;
nr_seq_item_w			bigint;
tx_item_w			double precision;
ie_pos_estab_faturamento_w	pls_parametros.ie_pos_estab_faturamento%type;
ie_geracao_pos_estabelecido_w	pls_parametros.ie_geracao_pos_estabelecido%type;
dados_regra_preco_proc_w	pls_cta_valorizacao_pck.dados_regra_preco_proc;
dados_regra_preco_material_w	pls_cta_valorizacao_pck.dados_regra_preco_material;

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		'P', 
		tx_item, 
		qt_procedimento_imp, 
		vl_unitario_imp, 
		vl_procedimento_imp, 
		vl_procedimento		 
	from	pls_conta_proc 
	where	nr_seq_conta	= nr_seq_conta_w 
	
union
 
	SELECT	nr_sequencia, 
		'M', 
		tx_reducao_acrescimo, 
		qt_material_imp, 
		vl_unitario_imp, 
		vl_material_imp, 
		vl_material		 
	from	pls_conta_mat 
	where	nr_seq_conta	= nr_seq_conta_w;	
 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 

BEGIN 
 
begin 
	select	coalesce(max(ie_pos_estab_faturamento),'N'), 
		coalesce(max(ie_geracao_pos_estabelecido),'F') 
	into STRICT	ie_pos_estab_faturamento_w, 
		ie_geracao_pos_estabelecido_w 
	from	pls_parametros 
	where	cd_estabelecimento	= cd_estabelecimento_p;
exception 
when others then 
	ie_pos_estab_faturamento_w	:= 'N';
	ie_geracao_pos_estabelecido_w	:= 'F';
end;
 
if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then 
	select	nr_seq_conta, 
		ie_tipo_despesa 
	into STRICT	nr_seq_conta_w, 
		ie_tipo_despesa_w 
	from	pls_conta_proc 
	where	nr_sequencia	= nr_seq_conta_proc_p;
 
	dados_regra_preco_proc_w := pls_atualiza_valor_proc_co(	nr_seq_conta_proc_p, ie_tipo_despesa_w, 'S', ie_pos_estab_faturamento_w, ie_geracao_pos_estabelecido_w, nm_usuario_p, dados_regra_preco_proc_w);
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then 
	select	max(nr_seq_conta) 
	into STRICT	nr_seq_conta_w 
	from	pls_conta_mat 
	where	nr_sequencia	= nr_seq_conta_mat_p;
 
	dados_regra_preco_material_w := pls_atualiza_valor_mat_co( 	nr_seq_conta_mat_p, 'S', ie_pos_estab_faturamento_w, ie_geracao_pos_estabelecido_w, nm_usuario_p, dados_regra_preco_material_w);
end if;
 
begin 
select	coalesce(ie_atualizar_valor_apresent,'N') 
into STRICT	ie_atualiza_apresentado_w 
from 	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
exception 
when others then 
	ie_atualiza_apresentado_w	:= 'N';
end;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_item_w, 
	ie_tipo_item_w, 
	tx_item_w, 
	qt_item_w, 
	vl_unitario_apres_w, 
	vl_total_apres_w, 
	vl_calculado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (ie_tipo_item_w = 'P') then 
		/* Retornar o procedimento para analise */
 
		update	pls_conta_proc 
		set	ie_status = 'A' 
		where	nr_sequencia	= nr_seq_item_w;	
		 
		if (ie_atualiza_apresentado_w <> 'N') then 
			CALL pls_atualiza_valor_apresentado( null, null, null, null, nr_seq_item_w, cd_estabelecimento_p, nm_usuario_p);
			 
			select	vl_procedimento_imp, 
				vl_unitario_imp 
			into STRICT	vl_total_apres_w, 
				vl_unitario_apres_w 
			from	pls_conta_proc 
			where	nr_sequencia	= nr_seq_item_w;
		end if;
	else 
		/* Retornar o material para analise */
 
		update	pls_conta_mat 
		set	ie_status	= 'A' 
		where	nr_sequencia	= nr_seq_item_w;
	end if;	
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_fat_analise ( nr_seq_analise_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

