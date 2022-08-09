-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_ocor_pre_analise ( nr_seq_ocorrencia_p bigint, ie_origem_p text, ie_pre_analise_p text, ie_retorno_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
ie_origem_p
O - Ocorrência - quando for salva uma ocorrência alterada, que for alterado o campo ie_pre_analise, esta ocorrência não poderá estar vínculada a nenhuma outra
V - Vinculada    - quando for inseria uma nova ocorrência vinculada esta não poderá ser de pré - análise

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_pre_analise_w	varchar(1);
qt_ocor_vinculada	bigint;
ie_retorno_w		varchar(1)	:= 'N';

BEGIN
if (ie_origem_p = 'V') then

	select	coalesce(ie_pre_analise,'N')
	into STRICT	ie_pre_analise_w
	from	pls_ocorrencia
	where	nr_sequencia = nr_seq_ocorrencia_p;

	if (ie_pre_analise_w = 'S') then
		ie_retorno_w := 'S';
	end if;
elsif (ie_origem_p = 'O') then
	select 	count(1)
	into STRICT	qt_ocor_vinculada
	from	pls_ocorrencia_vinculo
	where	nr_seq_ocor_conta = nr_seq_ocorrencia_p;

	if (qt_ocor_vinculada > 0) and (ie_pre_analise_p = 'S') then
		ie_retorno_w := 'S';
	end if;
end if;

ie_retorno_p := ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_ocor_pre_analise ( nr_seq_ocorrencia_p bigint, ie_origem_p text, ie_pre_analise_p text, ie_retorno_p INOUT text, nm_usuario_p text) FROM PUBLIC;
