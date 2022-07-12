-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_mat_anexo_guia ( nr_seq_guia_plano_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao_mat.nr_sequencia%type, ie_campo_p text) RETURNS varchar AS $body$
DECLARE


/*ie_campo_w

anv - Número de registro do material/medicamento na anvisa para esta marca
aut - número de autorização de funcionamento da empresa  da qual o material esta sendo importado
ref - código de referência do fabricante

*/
ds_retorno_w	varchar(255) := null;


BEGIN

if (ie_campo_p = 'anv') then
	if (nr_seq_guia_plano_p IS NOT NULL AND nr_seq_guia_plano_p::text <> '') then
		select	max(a.nr_registro_anvisa)
		into STRICT	ds_retorno_w
		from	pls_lote_anexo_mat_aut a
		where 	nr_seq_plano_mat in (	SELECT nr_sequencia
						from	pls_guia_plano_mat
						where 	nr_seq_guia	= nr_seq_guia_plano_p);

	elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		select	max(a.nr_registro_anvisa)
		into STRICT	ds_retorno_w
		from	pls_lote_anexo_mat_aut a
		where 	nr_seq_req_mat in (	SELECT nr_sequencia
						from	pls_requisicao_mat
						where 	nr_seq_requisicao	= nr_seq_requisicao_p);
	end if;

elsif (ie_campo_p = 'aut') then
	if (nr_seq_guia_plano_p IS NOT NULL AND nr_seq_guia_plano_p::text <> '') then
		select	max(a.cd_aut_funcionamento)
		into STRICT	ds_retorno_w
		from	pls_lote_anexo_mat_aut a
		where 	nr_seq_plano_mat in (	SELECT nr_sequencia
						from	pls_guia_plano_mat
						where 	nr_seq_guia	= nr_seq_guia_plano_p);
	elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		select	max(a.nr_registro_anvisa)
		into STRICT	ds_retorno_w
		from	pls_lote_anexo_mat_aut a
		where 	nr_seq_req_mat in (	SELECT nr_sequencia
						from	pls_requisicao_mat
						where 	nr_seq_requisicao	= nr_seq_requisicao_p);

	end if;
elsif (ie_campo_p = 'ref') then
	if (nr_seq_guia_plano_p IS NOT NULL AND nr_seq_guia_plano_p::text <> '') then
		select	max(a.cd_ref_fabricante_imp)
		into STRICT	ds_retorno_w
		from	pls_lote_anexo_mat_aut a
		where 	nr_seq_plano_mat in (	SELECT 	nr_sequencia
						from	pls_guia_plano_mat
						where 	nr_seq_guia	= nr_seq_guia_plano_p);
	elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		select	max(a.nr_registro_anvisa)
		into STRICT	ds_retorno_w
		from	pls_lote_anexo_mat_aut a
		where 	nr_seq_req_mat in (	SELECT nr_sequencia
						from	pls_requisicao_mat
						where 	nr_seq_requisicao	= nr_seq_requisicao_p);

	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_mat_anexo_guia ( nr_seq_guia_plano_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao_mat.nr_sequencia%type, ie_campo_p text) FROM PUBLIC;

