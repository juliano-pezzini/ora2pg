-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valida_atrib_padrao_tiss ( ie_atributo_p pls_ocorrencia_conta_atrib.ie_atributo%type, ds_atributo_p text) RETURNS varchar AS $body$
DECLARE


/*
Essa function é responsável para verificar se os atributos
da regra de atributos está dentro do padrão TISS, a principio
ela foi criada somente para validar um campo, mas conforme
for validado os demais, é só ir alterando essa function.
O conceito é simples, no parâmetro "ie_atributo_p" é
passado o número do atributo na regra (pls_ocorrencia_conta_atrib.ie_atributo)
e no parâmetro "ds_atributo_p" é passado o valor do atributo
caso o valor esteja fora do padrão TISS o retorno deve ser 'N'
*/
ie_valido_w		varchar(1) := 'S';


BEGIN

if (ie_atributo_p = 28) and (ds_atributo_p not in ('1','2','3','4')) then
	ie_valido_w := 'N';
end if;

return	ie_valido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valida_atrib_padrao_tiss ( ie_atributo_p pls_ocorrencia_conta_atrib.ie_atributo%type, ds_atributo_p text) FROM PUBLIC;
