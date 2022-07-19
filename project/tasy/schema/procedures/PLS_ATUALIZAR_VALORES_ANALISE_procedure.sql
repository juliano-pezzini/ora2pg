-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_valores_analise ( nr_seq_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE

				 
tx_item_w			double precision;
qt_apresentado_w		bigint;
qt_liberado_w			bigint;
vl_unitario_w			double precision;
vl_total_w			double precision;
vl_unitario_apres_w		double precision;
vl_total_apres_w		double precision;
vl_calculado_w			double precision;
nr_seq_item_w			bigint;
ie_tipo_item_w			varchar(1);
qt_item_w			double precision;
ie_atualiza_apresentado_w	varchar(1);
C01 CURSOR FOR
	SELECT	nr_sequencia, 
		'P', 
		tx_item, 
		--vl_unitario, 
		--vl_liberado, 
		qt_procedimento_imp, 
		vl_unitario_imp, 
		vl_procedimento_imp, 
		vl_procedimento 
	from	pls_conta_proc 
	where	nr_seq_conta	= nr_seq_conta_p 
	
union
 
	SELECT	nr_sequencia, 
		'M', 
		tx_reducao_acrescimo, 
		--vl_unitario, 
		--vl_liberado, 
		qt_material_imp, 
		vl_unitario_imp, 
		vl_material_imp, 
		vl_material 
	from	pls_conta_mat 
	where	nr_seq_conta	= nr_seq_conta_p;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_item_w, 
	ie_tipo_item_w, 
	tx_item_w, 
	--vl_unitario_w, 
	--vl_total_w, 
	qt_item_w, 
	vl_unitario_apres_w, 
	vl_total_apres_w, 
	vl_calculado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	if (ie_tipo_item_w = 'P') then 
		/*Retornar o procedimento para analise*/
 
		update	pls_conta_proc 
		set	ie_status 	= 'A' 
		where	nr_sequencia 	= nr_seq_item_w 
		and	ie_status 	<> 'D';
		 
		select	coalesce(ie_atualizar_valor_apresent,'N') 
		into STRICT	ie_atualiza_apresentado_w 
		from 	pls_parametros 
		where	cd_estabelecimento = cd_estabelecimento_p;
		 
		if (coalesce(ie_atualiza_apresentado_w,'N') <> 'N') then 
 
			CALL pls_atualiza_valor_apresentado( null, null, null, null, nr_seq_item_w, 
							cd_estabelecimento_p, nm_usuario_p);
			 
			select	vl_procedimento_imp, 
				vl_unitario_imp 
			into STRICT	vl_total_apres_w, 
				vl_unitario_apres_w 
			from	pls_conta_proc 
			where	nr_sequencia = nr_seq_item_w;
		end if;
	else 
		/*Retornar o material para analise*/
 
		update	pls_conta_mat 
		set	ie_status = 'A' 
		where	nr_sequencia = nr_seq_item_w;
	end if;	
	/*caso o valor apresentado seja igual a 0, e exista valor calculado o valor apresentado recebe o calculado OS 393193*/
 
		 
	update	w_pls_resumo_conta 
	set	--vl_total 			= vl_total_w, 
		vl_unitario_apres 	= vl_unitario_apres_w, 
		vl_total_apres		= vl_total_apres_w, 
		tx_item			= tx_item_w, 
		vl_calculado		= vl_calculado_w, 
		nm_usuario		= nm_usuario_p 
	where	nr_seq_item		= nr_seq_item_w 
	and	ie_tipo_item		= ie_tipo_item_w;
	 
	end;
end loop;
close C01;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_valores_analise ( nr_seq_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;

