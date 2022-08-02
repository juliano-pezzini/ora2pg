-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_permissoes_auditor ( nr_seq_analise_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, ie_auditor_master_p INOUT text, ie_valor_calculado_p INOUT text, ie_valor_apresentado_p INOUT text, ie_melhor_valor_p INOUT text, ie_modificar_item_p INOUT text, ie_substituir_item_p INOUT text, ie_inserir_item_p INOUT text, ie_valor_pagamento_p INOUT text, ie_valor_faturamento_p INOUT text, ie_desfazer_analise_p INOUT text, ie_glosar_p INOUT text, ie_analisar_p INOUT text, ie_finalizar_analise_p INOUT text, ie_modificar_conta_p INOUT text, ie_encaminhar_grupo_p INOUT text, ie_excluir_itens_p INOUT text, ie_excluir_anexo_p INOUT text, ie_excluir_obs_p INOUT text, ie_permite_mod_partic_p INOUT text, ie_ajustar_valor_lib_p INOUT text, ie_liberar_oc_conta_p INOUT text, ie_cancelar_item_p INOUT text) AS $body$
DECLARE


ie_auditor_master_w			varchar(1);


BEGIN
select	max(ie_permissao)
into STRICT	ie_auditor_master_w
from 	pls_grupo_auditor
where	nr_sequencia	= nr_seq_grupo_p;

if (ie_auditor_master_w = 'T') then
	ie_auditor_master_p 	:= 'S';
	ie_valor_calculado_p	:= 'S';
	ie_valor_apresentado_p	:= 'S';
	ie_melhor_valor_p	:= 'S';
	ie_modificar_item_p	:= 'S';
	ie_substituir_item_p	:= 'S';
	ie_inserir_item_p	:= 'S';
	ie_valor_pagamento_p	:= 'S';
	ie_valor_faturamento_p	:= 'S';
	ie_modificar_conta_p	:= 'S';
	ie_desfazer_analise_p	:= 'S';
	ie_glosar_p		:= 'S';
	ie_analisar_p		:= 'S';
	ie_finalizar_analise_p	:= 'S';
	ie_excluir_itens_p	:= 'S';
	ie_encaminhar_grupo_p	:= 'S';
	ie_excluir_anexo_p	:= 'S';
	ie_excluir_obs_p	:= 'S';
	ie_permite_mod_partic_p	:= 'S';
	ie_liberar_oc_conta_p	:= 'S';
	ie_ajustar_valor_lib_p	:= 'S';
	ie_cancelar_item_p	:= 'S';
else
	/*Obtem as permissãoes*/

	begin
	select	coalesce(ie_valor_calculado,'S'),
		coalesce(ie_valor_apresentado,'S'),
		coalesce(ie_melhor_valor,'S'),
		coalesce(ie_modificar_item,'S'),
		coalesce(ie_substituir_item,'S'),
		coalesce(ie_inserir_item,'S'),
		coalesce(ie_valor_pagamento,'S'),
		coalesce(ie_valor_faturamento,'S'),
		coalesce(ie_modificar_conta,'S'),
		coalesce(ie_desfazer_analise,'S'),
		coalesce(ie_glosar,'S'),
		coalesce(ie_analisar,'S'),
		coalesce(ie_finalizar_analise,'S'),
		coalesce(ie_excluir_item,'S'),
		coalesce(ie_encaminhar_grupo,'S'),
		coalesce(ie_excluir_anexo,'S'),
		coalesce(ie_excluir_obs,'S'),
		coalesce(ie_permite_mod_partic,'S'),
		coalesce(ie_liberar_oc_conta,'S'),
		coalesce(ie_ajustar_valor_lib,'S'),
		coalesce(ie_cancelar_item,'S')
	into STRICT	ie_valor_calculado_p,
		ie_valor_apresentado_p,
		ie_melhor_valor_p,
		ie_modificar_item_p,
		ie_substituir_item_p,
		ie_inserir_item_p,
		ie_valor_pagamento_p,
		ie_valor_faturamento_p,
		ie_modificar_conta_p,
		ie_desfazer_analise_p,
		ie_glosar_p,
		ie_analisar_p,
		ie_finalizar_analise_p,
		ie_excluir_itens_p,
		ie_encaminhar_grupo_p,
		ie_excluir_anexo_p,
		ie_excluir_obs_p,
		ie_permite_mod_partic_p,
		ie_liberar_oc_conta_p,
		ie_ajustar_valor_lib_p,
		ie_cancelar_item_p
	from	pls_membro_grupo_aud
	where	upper(nm_usuario_exec)	= upper(nm_usuario_p)
	and	nr_seq_grupo	  	= nr_seq_grupo_p
	and	ie_situacao		= 'A';
	exception
	when others then
		ie_valor_calculado_p	:= 'N';
		ie_valor_apresentado_p	:= 'N';
		ie_melhor_valor_p	:= 'N';
		ie_modificar_item_p	:= 'N';
		ie_substituir_item_p	:= 'N';
		ie_inserir_item_p	:= 'N';
		ie_valor_pagamento_p	:= 'N';
		ie_valor_faturamento_p	:= 'N';
		ie_modificar_conta_p	:= 'N';
		ie_desfazer_analise_p	:= 'N';
		ie_glosar_p		:= 'N';
		ie_analisar_p		:= 'N';
		ie_finalizar_analise_p	:= 'N';
		ie_excluir_itens_p	:= 'N';
		ie_encaminhar_grupo_p	:= 'N';
		ie_excluir_anexo_p	:= 'N';
		ie_excluir_obs_p	:= 'N';
		ie_permite_mod_partic_p := 'N';
		ie_liberar_oc_conta_p	:= 'N';
		ie_ajustar_valor_lib_p	:= 'N';
		ie_cancelar_item_p	:= 'N';
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_permissoes_auditor ( nr_seq_analise_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, ie_auditor_master_p INOUT text, ie_valor_calculado_p INOUT text, ie_valor_apresentado_p INOUT text, ie_melhor_valor_p INOUT text, ie_modificar_item_p INOUT text, ie_substituir_item_p INOUT text, ie_inserir_item_p INOUT text, ie_valor_pagamento_p INOUT text, ie_valor_faturamento_p INOUT text, ie_desfazer_analise_p INOUT text, ie_glosar_p INOUT text, ie_analisar_p INOUT text, ie_finalizar_analise_p INOUT text, ie_modificar_conta_p INOUT text, ie_encaminhar_grupo_p INOUT text, ie_excluir_itens_p INOUT text, ie_excluir_anexo_p INOUT text, ie_excluir_obs_p INOUT text, ie_permite_mod_partic_p INOUT text, ie_ajustar_valor_lib_p INOUT text, ie_liberar_oc_conta_p INOUT text, ie_cancelar_item_p INOUT text) FROM PUBLIC;

