-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_itens_limite_pck.obter_itens_regra_valor (nr_index_p integer) RETURNS SETOF REGRA_TIPO_ITEM_T AS $body$
DECLARE

			
vet_regra_item_w	regra_tipo_item;

BEGIN

if (current_setting('pls_mens_itens_limite_pck.regra_limite_item_w')::vetor[nr_index_p].regra_item.count > 0) then
	for i in current_setting('pls_mens_itens_limite_pck.regra_limite_item_w')::vetor[nr_index_p].regra_item.first..regra_limite_item_w[nr_index_p].regra_item.last loop
		begin
		vet_regra_item_w.ie_tipo_item 		:= current_setting('pls_mens_itens_limite_pck.regra_limite_item_w')::vetor[nr_index_p].regra_item(i).ie_tipo_item;
		vet_regra_item_w.nr_seq_tipo_lanc 	:= current_setting('pls_mens_itens_limite_pck.regra_limite_item_w')::vetor[nr_index_p].regra_item(i).nr_seq_tipo_lanc;
		RETURN NEXT vet_regra_item_w;
		end;
	end loop;
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_itens_limite_pck.obter_itens_regra_valor (nr_index_p integer) FROM PUBLIC;