-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_alt_valor_pos_pck.pls_calcula_valor_proced ( qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_p pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_p pls_conta_proc_v.vl_lib_taxa_servico%type, tx_intercambio_imp_p pls_conta_proc_v.tx_intercambio_imp%type, nr_seq_procedimento_p pls_conta_proc_v.nr_sequencia%type, nr_seq_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, ie_opcao_p text, ie_intercambio_p text, ie_novo_pos_estab_p text, vl_unitario_out_p INOUT pls_conta_proc_v.vl_unitario%type, vl_liberado_out_p INOUT pls_conta_proc_v.vl_liberado%type, vl_liberado_co_out_p INOUT pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_out_p INOUT pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_out_p INOUT pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_out_p INOUT pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_out_p INOUT pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_out_p INOUT pls_conta_proc_v.vl_lib_taxa_servico%type) AS $body$
DECLARE


qt_liberada_w				pls_conta_proc_v.qt_procedimento%type		:= 0;
qt_apresentada_w			pls_conta_proc_v.qt_procedimento%type		:= 0;
vl_unitario_item_w			pls_conta_proc_v.vl_unitario%type		:= 0;
vl_unitario_w				pls_conta_proc_v.vl_unitario%type		:= 0;
vl_liberado_w				pls_conta_proc_v.vl_liberado%type		:= 0;
vl_liberado_co_w      			pls_conta_proc_v.vl_liberado_co%type		:= 0;
vl_liberado_hi_w        		pls_conta_proc_v.vl_liberado_hi%type		:= 0;
vl_liberado_material_w			pls_conta_proc_v.vl_liberado_material%type	:= 0;
vl_lib_taxa_co_w     			pls_conta_proc_v.vl_lib_taxa_co%type		:= 0;
vl_lib_taxa_material_w			pls_conta_proc_v.vl_lib_taxa_material%type	:= 0;
vl_lib_taxa_servico_w   		pls_conta_proc_v.vl_lib_taxa_servico%type	:= 0;
vl_liberado_co_pag_w         		pls_conta_proc_v.vl_liberado_co%type		:= 0;
vl_liberado_hi_pag_w          		pls_conta_proc_v.vl_liberado_hi%type		:= 0;
vl_liberado_material_pag_w        	pls_conta_proc_v.vl_liberado_material%type	:= 0;	
vl_lib_taxa_co_pag_w          		pls_conta_proc_v.vl_lib_taxa_co%type		:= 0;
vl_lib_taxa_material_pag_w    		pls_conta_proc_v.vl_lib_taxa_material%type	:= 0;
vl_lib_taxa_servico_pag_w		pls_conta_proc_v.vl_lib_taxa_servico%type	:= 0;
vl_liberado_co_fat_w              	pls_conta_pos_estabelecido.vl_liberado_co_fat%type	:= 0;
vl_liberado_hi_fat_w              	pls_conta_pos_estabelecido.vl_liberado_hi_fat%type	:= 0;
vl_liberado_material_fat_w        	pls_conta_pos_estabelecido.vl_liberado_material_fat%type:= 0;
vl_lib_taxa_co_fat_w                  	pls_conta_pos_estabelecido.vl_lib_taxa_co%type		:= 0;
vl_lib_taxa_material_fat_w            	pls_conta_pos_estabelecido.vl_lib_taxa_material%type	:= 0;
vl_lib_taxa_servico_fat_w		pls_conta_pos_estabelecido.vl_lib_taxa_servico%type	:= 0;
vl_materiais_calc_w			pls_conta_pos_estabelecido.vl_materiais_calc%type	:= 0;
vl_medico_calc_w			pls_conta_pos_estabelecido.vl_medico_calc%type		:= 0;
vl_custo_operacional_calc_w		pls_conta_pos_estabelecido.vl_custo_operacional_calc%type:= 0;
vl_taxa_co_fat_w              		pls_conta_pos_estabelecido.vl_taxa_co%type		:= 0;
vl_taxa_material_fat_w        		pls_conta_pos_estabelecido.vl_taxa_material%type	:= 0;
vl_taxa_servico_fat_w			pls_conta_pos_estabelecido.vl_taxa_servico%type	:= 0;



BEGIN

qt_liberada_w		:= coalesce(qt_liberada_p,0);
vl_unitario_w		:= coalesce(vl_unitario_p,0);
vl_liberado_w		:= coalesce(vl_liberado_p,0);
vl_lib_taxa_co_w     	:= coalesce(vl_lib_taxa_co_p,0);
vl_lib_taxa_material_w	:= coalesce(vl_lib_taxa_material_p,0);
vl_lib_taxa_servico_w   := coalesce(vl_lib_taxa_servico_p,0);
vl_liberado_material_w	:= coalesce(vl_liberado_material_p,0);
vl_liberado_co_w      	:= coalesce(vl_liberado_co_p,0);
vl_liberado_hi_w        := coalesce(vl_liberado_hi_p,0);

select	qt_procedimento_imp,
	vl_liberado_co,
	vl_liberado_hi,          
	vl_liberado_material,        
	vl_lib_taxa_co,          
	vl_lib_taxa_material,    
	vl_lib_taxa_servico     
into STRICT	qt_apresentada_w,   
	vl_liberado_co_pag_w,          
	vl_liberado_hi_pag_w,          
	vl_liberado_material_pag_w,        
	vl_lib_taxa_co_pag_w,          
	vl_lib_taxa_material_pag_w,    
	vl_lib_taxa_servico_pag_w 
from	pls_conta_proc_v	a
where	nr_sequencia	= nr_seq_procedimento_p;

if (ie_novo_pos_estab_p = 'N') then
	select	coalesce(vl_liberado_co_fat,0),
		coalesce(vl_liberado_hi_fat,0),              
		coalesce(vl_liberado_material_fat,0),        
		coalesce(vl_lib_taxa_co,0),                  
		coalesce(vl_lib_taxa_material,0),            
		coalesce(vl_lib_taxa_servico,0),
		coalesce(vl_materiais_calc,0),
		coalesce(vl_medico_calc,0),
		coalesce(vl_custo_operacional_calc,0),
		coalesce(vl_taxa_co,0),
		coalesce(vl_taxa_material,0),        
		coalesce(vl_taxa_servico,0)         	
	into STRICT	vl_liberado_co_fat_w,              
		vl_liberado_hi_fat_w,              
		vl_liberado_material_fat_w,        
		vl_lib_taxa_co_fat_w,                  
		vl_lib_taxa_material_fat_w,            
		vl_lib_taxa_servico_fat_w,
		vl_materiais_calc_w,
		vl_medico_calc_w,
		vl_custo_operacional_calc_w,
		vl_taxa_co_fat_w,
		vl_taxa_material_fat_w,        
		vl_taxa_servico_fat_w
	from	pls_conta_pos_estabelecido
	where	nr_sequencia	= nr_seq_pos_estab_p;	
else

	select	coalesce(vl_liberado_co_fat,0),
		coalesce(vl_liberado_hi_fat,0),              
		coalesce(vl_liberado_material_fat,0),        
		coalesce(vl_lib_taxa_co,0),                  
		coalesce(vl_lib_taxa_material,0),            
		coalesce(vl_lib_taxa_servico,0),
		coalesce(vl_materiais_calc,0),
		coalesce(vl_medico_calc,0),
		coalesce(vl_custo_operacional_calc,0),
		coalesce(vl_taxa_co,0),
		coalesce(vl_taxa_material,0),        
		coalesce(vl_taxa_servico,0)         	
	into STRICT	vl_liberado_co_fat_w,              
		vl_liberado_hi_fat_w,              
		vl_liberado_material_fat_w,        
		vl_lib_taxa_co_fat_w,                  
		vl_lib_taxa_material_fat_w,            
		vl_lib_taxa_servico_fat_w,
		vl_materiais_calc_w,
		vl_medico_calc_w,
		vl_custo_operacional_calc_w,
		vl_taxa_co_fat_w,
		vl_taxa_material_fat_w,        
		vl_taxa_servico_fat_w
	from	pls_conta_pos_proc_v
	where	nr_sequencia	= nr_seq_pos_estab_p;	

end if;

/*Calculo quando da saída do campo quantidade*/

if (ie_opcao_p	= '1') then

	vl_liberado_hi_w	:= dividir(vl_medico_calc_w,qt_apresentada_w) * qt_liberada_w;

	vl_liberado_material_w	:= dividir(vl_materiais_calc_w,qt_apresentada_w) * qt_liberada_w;

	vl_liberado_co_w	:= dividir(vl_custo_operacional_calc_w,qt_apresentada_w) * qt_liberada_w;

	vl_lib_taxa_co_w     	:= pls_cta_alt_valor_pos_pck.pls_obter_val_taxa(tx_intercambio_imp_p,vl_liberado_co_w,qt_liberada_w );

	vl_lib_taxa_material_w	:= pls_cta_alt_valor_pos_pck.pls_obter_val_taxa(tx_intercambio_imp_p,vl_liberado_material_w,qt_liberada_w );

	vl_lib_taxa_servico_w   := pls_cta_alt_valor_pos_pck.pls_obter_val_taxa(tx_intercambio_imp_p,vl_liberado_hi_w,qt_liberada_w );

	vl_liberado_w		:= 	coalesce(vl_liberado_hi_w,0) + coalesce(vl_liberado_material_w,0) + coalesce(vl_liberado_co_w,0) +
					coalesce(vl_lib_taxa_co_w,0) + coalesce(vl_lib_taxa_material_w,0) + coalesce(vl_lib_taxa_servico_w,0);
	if (qt_liberada_w	= 0) then
		vl_unitario_w	:= 0;
	end if;
--Calculo quando da saída do campo valor total liberado 
elsif (ie_opcao_p	= '2') then
	vl_unitario_w	:= pls_cta_alt_valor_pos_pck.pls_obter_val_liberado_uni(qt_liberada_w,vl_liberado_w );
	
--Calculo quando da saída do campo valor liberado proc
elsif (ie_opcao_p	= '3') then

	vl_lib_taxa_servico_w   := pls_cta_alt_valor_pos_pck.pls_obter_val_taxa(tx_intercambio_imp_p,vl_liberado_hi_w,qt_liberada_w );

--Calculo quando da saída do campo valor liberado co
elsif (ie_opcao_p	= '4') then

	vl_lib_taxa_co_w     	:= pls_cta_alt_valor_pos_pck.pls_obter_val_taxa(tx_intercambio_imp_p,vl_liberado_co_w,qt_liberada_w );
		
--Calculo quando da saída do campo valor liberado mat
elsif (ie_opcao_p	= '5') then
	vl_lib_taxa_material_w	:= pls_cta_alt_valor_pos_pck.pls_obter_val_taxa(tx_intercambio_imp_p,vl_liberado_material_w,qt_liberada_w );
end if;	

if (ie_opcao_p	in ('3','4','5','6','7','8','9')) then
	
	vl_liberado_w	:= 	vl_lib_taxa_servico_w + vl_lib_taxa_co_w + vl_lib_taxa_material_w +
				vl_liberado_hi_w + vl_liberado_co_w + vl_liberado_material_w;
	if (qt_liberada_w	= 0 ) and (vl_liberado_w	> 0) then
		vl_liberado_w	:= 0;
	end if;
end if;

vl_unitario_out_p		:= coalesce(vl_unitario_w,0);
vl_liberado_out_p		:= coalesce(vl_liberado_w,0);
vl_liberado_co_out_p      	:= coalesce(vl_liberado_co_w,0);
vl_liberado_hi_out_p        	:= coalesce(vl_liberado_hi_w,0);
vl_liberado_material_out_p	:= coalesce(vl_liberado_material_w,0);
vl_lib_taxa_co_out_p     	:= coalesce(vl_lib_taxa_co_w,0);
vl_lib_taxa_material_out_p	:= coalesce(vl_lib_taxa_material_w,0);
vl_lib_taxa_servico_out_p   	:= coalesce(vl_lib_taxa_servico_w,0);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_alt_valor_pos_pck.pls_calcula_valor_proced ( qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_unitario_p pls_conta_proc_v.vl_unitario%type, vl_liberado_p pls_conta_proc_v.vl_liberado%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_p pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_p pls_conta_proc_v.vl_lib_taxa_servico%type, tx_intercambio_imp_p pls_conta_proc_v.tx_intercambio_imp%type, nr_seq_procedimento_p pls_conta_proc_v.nr_sequencia%type, nr_seq_pos_estab_p pls_conta_pos_estabelecido.nr_sequencia%type, ie_opcao_p text, ie_intercambio_p text, ie_novo_pos_estab_p text, vl_unitario_out_p INOUT pls_conta_proc_v.vl_unitario%type, vl_liberado_out_p INOUT pls_conta_proc_v.vl_liberado%type, vl_liberado_co_out_p INOUT pls_conta_proc_v.vl_liberado_co%type, vl_liberado_hi_out_p INOUT pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_material_out_p INOUT pls_conta_proc_v.vl_liberado_material%type, vl_lib_taxa_co_out_p INOUT pls_conta_proc_v.vl_lib_taxa_co%type, vl_lib_taxa_material_out_p INOUT pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_servico_out_p INOUT pls_conta_proc_v.vl_lib_taxa_servico%type) FROM PUBLIC;
