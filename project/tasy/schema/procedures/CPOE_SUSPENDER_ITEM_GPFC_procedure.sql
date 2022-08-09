-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_suspender_item_gpfc ( nr_Sequencia_p bigint, ie_tipo_item_p text, nr_atendimento_p bigint, nr_seq_motivo_susp_p bigint, ds_motivo_susp_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_w					varchar(2000);
ds_lista_ww					varchar(2000);
ie_tipo_item_w				varchar(10);
lista_itens_ret_w			varchar(2000);
lista_itens_ret2_w			varchar(2000);
ds_lista_proc_susp_out_w	varchar(4000);
					

BEGIN

if (ie_tipo_item_p	in ('D','J','SNE','LD','S')) then
	ie_tipo_item_w	:= 'N';
elsif (ie_tipo_item_p in ('MAT','SOL')) then	
	ie_tipo_item_w	:= 'M';
elsif (ie_tipo_item_p	= 'O') then	
	ie_tipo_item_w	:= 'G';
else
	ie_tipo_item_w	:= ie_tipo_item_p;
end if;	

ds_lista_w	:= 	'['||nr_sequencia_p||';'||ie_tipo_item_w||']';

SELECT * FROM cpoe_ajustar_itens_susp(lista_itens_p => ds_lista_w, dt_suspensao_p => clock_timestamp(), nm_usuario_p => nm_usuario_p, lista_itens_ret_p => lista_itens_ret_w, ie_forma_suspensao_p => 'I', ds_lista_sol_consistir_p => lista_itens_ret2_w, lista_itens_ex_p => ds_lista_ww) INTO STRICT lista_itens_ret_p => lista_itens_ret_w, ds_lista_sol_consistir_p => lista_itens_ret2_w, lista_itens_ex_p => ds_lista_ww;

ds_lista_w	:=	'['||nr_sequencia_p||';'||ie_tipo_item_w||';S]';

ds_lista_proc_susp_out_w := CPOE_Suspender_item_prescr(ds_lista_w, nr_Atendimento_p, nm_usuario_p, nr_seq_motivo_susp_p, ds_motivo_susp_p, 'N', ds_lista_proc_susp_out_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_suspender_item_gpfc ( nr_Sequencia_p bigint, ie_tipo_item_p text, nr_atendimento_p bigint, nr_seq_motivo_susp_p bigint, ds_motivo_susp_p text, nm_usuario_p text) FROM PUBLIC;
