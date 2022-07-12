-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_item_desc_opme ( nr_seq_item_p bigint, ie_origem_item text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter se o item possui descrição OPME
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*IE_ORIGEM_ITEM
G - Guia
R - Requisição
E - Execução
*/
qt_reg_proc_w			bigint;
qt_reg_mat_w			bigint;
ie_reg_mat_w			bigint;
ds_retorno_w			varchar(2)	:= 'N';
ie_utiliza_opme_ptu_w		pls_param_requisicao.ie_utiliza_opme_ptu%type;


BEGIN




if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then
	if (ie_origem_item = 'G') then
		begin
			select	coalesce(ie_utiliza_opme_ptu, 'N')
			into STRICT	ie_utiliza_opme_ptu_w
			from	pls_param_autorizacao;
		exception
		when others then
			ie_utiliza_opme_ptu_w	:= 'N';
		end;

		select	count(1)
		into STRICT	qt_reg_proc_w
		from	pls_guia_plano_proc
		where	nr_sequencia		= nr_seq_item_p
		and	(ds_procedimento_ptu IS NOT NULL AND ds_procedimento_ptu::text <> '');

		select	count(1)
		into STRICT	qt_reg_mat_w
		from	pls_guia_plano_mat
		where	nr_sequencia		= nr_seq_item_p
		and	(ds_material_ptu IS NOT NULL AND ds_material_ptu::text <> '');

		select	count(1)
		into STRICT	ie_reg_mat_w
		from	pls_guia_plano_mat
		where	nr_sequencia		= nr_seq_item_p;
	elsif (ie_origem_item = 'R') then
		begin
			select	coalesce(ie_utiliza_opme_ptu, 'N')
			into STRICT	ie_utiliza_opme_ptu_w
			from	pls_param_requisicao;
		exception
		when others then
			ie_utiliza_opme_ptu_w	:= 'N';
		end;

		select	count(1)
		into STRICT	qt_reg_proc_w
		from	pls_requisicao_proc
		where	nr_sequencia		= nr_seq_item_p
		and	(ds_procedimento_ptu IS NOT NULL AND ds_procedimento_ptu::text <> '');

		select	count(1)
		into STRICT	qt_reg_mat_w
		from	pls_requisicao_mat
		where	nr_sequencia		= nr_seq_item_p
		and	(ds_material_ptu IS NOT NULL AND ds_material_ptu::text <> '');

		select	count(1)
		into STRICT	ie_reg_mat_w
		from	pls_requisicao_mat
		where	nr_sequencia		= nr_seq_item_p;
	end if;

	if (qt_reg_proc_w	> 0) or (qt_reg_mat_w	> 0) or
		(ie_reg_mat_w	> 0 AND ie_utiliza_opme_ptu_w = 'S')then
		ds_retorno_w	:= 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_item_desc_opme ( nr_seq_item_p bigint, ie_origem_item text) FROM PUBLIC;
