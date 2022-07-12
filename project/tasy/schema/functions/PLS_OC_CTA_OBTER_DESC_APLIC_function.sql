-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_oc_cta_obter_desc_aplic ( nr_seq_validacao_p pls_oc_cta_tipo_validacao.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Centralizar o tratamento para exibição da descrição de aplicação da regra das ocorrências;
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
------------------------------------------------------------------------------------------------------------------
jjung OS 602139 06/06/2013 - Criação da função.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(100);

BEGIN

select	CASE WHEN coalesce(max(cd_validacao)::text, '') = '' THEN  'Conforme filtros' WHEN max(cd_validacao)=1 THEN  'Conforme filtros'  ELSE CASE WHEN max(ie_aplicacao_ocorrencia)='C' THEN 'Conta' WHEN max(ie_aplicacao_ocorrencia)='P' THEN 'Somente Procedimento' WHEN max(ie_aplicacao_ocorrencia)='M' THEN 'Somente Material' WHEN max(ie_aplicacao_ocorrencia)='PM' THEN 'Procedimento ou Material' WHEN coalesce(max(ie_aplicacao_ocorrencia)::text, '') = '' THEN 'Conforme filtros' END  END
into STRICT	ds_retorno_w
from	pls_oc_cta_tipo_validacao
where	nr_sequencia = nr_seq_validacao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_obter_desc_aplic ( nr_seq_validacao_p pls_oc_cta_tipo_validacao.nr_sequencia%type) FROM PUBLIC;
